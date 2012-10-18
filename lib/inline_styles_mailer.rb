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
        templates.each do |template|
          # e.g. template = app/views/user_mailer/welcome.html.erb
          template_path = template.inspect.split("/").slice(-2, 2).join("/") # e.g. user_mailer/welcome.html.erb
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
    case _layout
    when ActionView::Template
      _layout.inspect.split("/").last.split(".").first
    when String
      _layout.split("/").last.split(".").first
    end
  end

end
