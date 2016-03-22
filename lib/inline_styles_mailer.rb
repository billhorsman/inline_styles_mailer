require "inline_styles"
require "inline_styles_mailer/version"
require "sass"

module InlineStylesMailer

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def use_stylesheet(*stylesheets)
      @stylesheets = Array(stylesheets)
    end

    def stylesheet_path(path)
      @stylesheet_path = path
    end

    def locate_template(name)
      "#{self.name.underscore}/#{name}.html"
    end

    def css_content
      @stylesheets ||= ["_#{self.name.underscore}*"]
      @stylesheet_path ||= File.join("app", "assets", "stylesheets")
      @css_content ||= @stylesheets.map {|stylesheet|
        Dir[Rails.root.join(@stylesheet_path, "#{stylesheet}")].map {|file|
          case file
          when /\.scss$/
            Sass::Engine.new(File.read(file), syntax: :scss).render
          when /\.sass$/
            Sass::Engine.new(File.read(file), syntax: :sass).render
          else
            # Plain old CSS? Let's assume it is.
            File.read(file)
          end
        }.join("\n")
      }.compact.join("\n")
      @css_content
    end

    def page
      @page ||= InlineStyles::Page.new.with_css(css_content)
    end

    # For testing
    def reset
      @css_content = nil
      @page = nil
    end

  end

  def mail(options, &block)
    if block
      super(mail, &block) # We'll just let this pass through
    else
      super(options) do |format|
        # Rails 3.1 takes an array, while Rails 3.0 takes a string.
        # See https://github.com/billhorsman/inline_styles_mailer/issues/1
        prefixes = options[:template_path] || self.class.name.underscore
        prefixes = [prefixes] unless Rails.version =~ /^3\.0/
        templates = lookup_context.find_all(options[:template_name] || action_name, prefixes)
        options.reverse_merge!(:mime_version => "1.0", :charset => "UTF-8", :content_type => "text/plain", :parts_order => [ "text/plain", "text/enriched", "text/html"])
        templates.sort_by {|t|
          # Rails 4.1 use #type but earlier versions use #mime_type
          mime_type = t.respond_to?(:mime_type) ? t.mime_type : t.type
          i = options[:parts_order].index(mime_type)
          i > -1 ? i : 99
        }.each do |template|
        # templates.each do |template|
          # e.g. template = app/views/user_mailer/welcome.html.erb
          # e.g. template = app/views/namespace/user_mailer/welcome.html.erb
          template_path = template.inspect.split("views")[1][1..-1] # e.g. user_mailer/welcome.html.erb
          parts = template_path.split('.')
          handler = parts.pop.to_sym # e.g. erb
          extension = parts.pop.to_sym # e.g. html
          file = parts.join('.') # e.g. user_mailer/welcome (you get a deprecation warning if you don't strip off the format and handler)
          format.send(extension) do
            case extension
            when :html
              html = render_to_string :file => file, :layout => layout_to_use, handlers: [handler]
              render :text => self.class.page.with_html(html).apply
            else
              render
            end
          end
        end
      end
    end
  end

  def layout_to_use
    case call_layout
    when ActionView::Template
      call_layout.inspect.split("/").last.split(".").first
    when String
      call_layout.split("/").last.split(".").first
    end
  end

  # Hack to call _layout the right way depending on the Rails version. This is a code smell
  # telling us that we shouldn't be doing this at all...
  def call_layout
    if method(:_layout).arity == 1
      # Rails 5?
      _layout([:html])
    else
      # < Rails 5?
      _layout
    end
  end

end
