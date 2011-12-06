## Inline Styles Mailer

Using Jack Danger's excellent [Inline Styles](https://github.com/jackdanger/inline_styles) gem is even easier if you're using Rails 3.1 too.

The Inline Styles gem helps you embed CSS styles into your markup so that you can send pretty HTML emails that won't get butchered by email clients that strip out CSS. Or, more precisely, will help reduce the amount of butchering (even with inline CSS some styles, like background images, are often cut out).

This gem stands on the shoulder's of the [inline_styles](https://github.com/jackdanger/inline_styles) and [sass-rails](https://github.com/rails/sass-rails) gem, merely adding some code to make it more convenient to use.

## Installation

If you're using Bundler:

```ruby
gem 'inline_styles_mailer'
```

## What do you mean, "inline style"?

Let's say you have a mail template like this:

```html
<html>
  <body>
    <p>Hello World</p>
  </body>
</html>
```

And a CSS file like this:

```css
p {
  color: red;
}
```

Then this gem will mash that all up into:

```html
<html>
  <body>
    <p style="color: red;">Hello World</p>
  </body>
</html>
```

So you can keep your templates clean and take advantage of CSS preprocessing goodness if you want without compromising the portability of your HTML in various email clients.

MailChimp have a nice article: [How To Code HTML Emails](http://kb.mailchimp.com/article/how-to-code-html-emails/).

## Usage

If you keep things simple, then it's just one line:

```ruby
class FooMailer < ActionMailer::Base
  include InlineStylesMailer

  def foo(email)
    mail(:to => email, :subject => "Foo foo!")
  end

end
```

If you have a CSS file <code>app/assets/stylesheets/_foo_mailer*</code> (where * can be .css, .css.scss or .css.sass) then it will get automatically applied to the mail using the inline_styles gem. That name (<code>_foo_mailer</code>) is based on your mailer class name, e.g. FooMailer. If you have more than one file matching that pattern then it will use them all.

It will use one of three preprocessing methods based on the filename:

* [.scss](http://sass-lang.com/)
* [.sass](http://sass-lang.com/)
* anything else (e.g. .css) no preprocessing at all

Want to use a different css file? Declare <code>use_stylesheet</code>:

```ruby
class FooMailer < ActionMailer::Base
  include InlineStylesMailer
  use_stylesheet '_bar.css.sass'
  ...
end
```

You can use an array of stylesheets if you like. Don't keep your stylesheets in <code>app/assets/stylesheets</code>? Declare <code>stylesheet_path</code>:

```ruby
class FooMailer < ActionMailer::Base
  include InlineStylesMailer
  stylesheet_path 'public/stylesheets'
  ...
end
```

## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/billhorsman/inline_styles_mailer/issues). You can contribute changes by forking the project and submitting a pull request. You can ensure the tests passing by running `bundle` and `rake`.

This gem was created by Bill Horsman and is under the MIT License.