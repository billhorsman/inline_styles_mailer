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

    def locate_css_file(stylesheet)
      Rails.root.join("app", "assets", "stylesheets", "#{stylesheet}.css.scss")
    end

    def locate_template(name)
      "#{self.name.underscore}/#{name}.html"
    end

    def css_content
      @stylesheets ||= ["_#{self.name.underscore}"]
      @css_content ||= @stylesheets.map {|stylesheet|
        file = locate_css_file(stylesheet)
        if File.exist?(file)
          case file
          when /\.scss$/
            Sass::Engine.new(File.read(file), syntax: :scss).render
          when /\.sass$/
            Sass::Engine.new(File.read(file), syntax: :sass).render
          else
            # Plain old CSS? Let's assume it is.
            File.read(file)
          end
        else
          nil
        end
      }.compact.join
    end

    def locate_layout
      "mailer"
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
        # Only format for text if an appropriate template exists
        # TODO we should be finding this file using Rails
        unless Dir[Rails.root.join('app', 'views', self.class.name.underscore, "#{action_name}.text.*")].empty?
          format.text do
            render
          end
        end
        format.html do
          html = render_to_string :file => self.class.locate_template(action_name), :layout => self.class.locate_layout
          render :text => self.class.page.with_html(html).apply
        end
      end
    end
  end

end
