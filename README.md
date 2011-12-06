## Inline Styles Mailer

Using Jack Danger's excellent [Inline Styles](https://github.com/jackdanger/inline_styles) gem is even easier if you're using Rails 3.1 too.

The Inline Styles gem helps you embed CSS styles into your markup so that you can send pretty HTML emails that won't get butchered by email clients that strip out CSS. Or, more precisely, will help reduce the amount of butchering (even with inline CSS some styles, like background images, are often cut out).

This gem stands on the shoulder's of the [inline_styles](https://github.com/jackdanger/inline_styles) and [sass-rails](https://github.com/rails/sass-rails) gem, merely adding some code to make it more convenient to use.

## Installation

If you're using Bundler:

```ruby
gem 'inline_styles_mailer'
```

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

If you have a CSS file <code>app/assets/stylesheets/_foo_mailer.css.scss</code> then it will get automatically applied to the mail using the inline_styles gem. That name (<code>_foo_mailer.css.scss</code>) is based on the mailer class name, FooMailer.

Want to use a different file? Declare <code>use_stylesheet</code>:

```ruby
class FooMailer < ActionMailer::Base
  include InlineStylesMailer
  use_stylesheet '_bar'


  def foo(email)
    mail(:to => email, :subject => "Foo foo!")
  end

end
```

The location of that file (<code>app/assets/stylesheets/</code>) is fixed. It will use one of three preprocessing methods based on the filename:

* .scss
* .sass
* .css (i.e. no preprocessing at all)

## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/billhorsman/inline_styles_mailer/issues). You can contribute changes by forking the project and submitting a pull request. You can ensure the tests passing by running `bundle` and `rake`.

This gem was created by Bill Horsman and is under the MIT License.