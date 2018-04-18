## Update for Rails 5.1+

I've started to use the [premailer](https://github.com/premailer/premailer) gem for Rails > 5.0. I'd welcome patches to keep this gem going.

## Inline Styles Mailer [![Build Status](https://secure.travis-ci.org/billhorsman/inline_styles_mailer.png)](http://travis-ci.org/billhorsman/inline_styles_mailer)

Using Jack Danger's excellent [Inline Styles](https://github.com/jackdanger/inline_styles) gem is even easier if you're using Rails 3.1+ and this gem.

The Inline Styles gem helps you embed CSS styles into your markup so that you can send pretty HTML emails that won't get butchered by email clients that strip out CSS. Or, more precisely, will help reduce the amount of butchering (even with inline CSS some styles, like background images, are often cut out).

This gem stands on the shoulders of the [inline_styles](https://github.com/jackdanger/inline_styles) and [sass-rails](https://github.com/rails/sass-rails) gem, merely adding some code to make it more convenient to use.

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

## Installation

If you're using Bundler:

```ruby
source 'http://rubygems.org'
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

## Upgrading to Version 1.0

We decided to bump up the major version because of a fix (5d0b6f4) we made to the way the template was found. We were incorrectly assuming that all mail templates were only nested one deep in `app/views` but that's not always the case. It now works correctly but you might have worked around this bug (issue #8) by moving your templates. You don't need to do that any more.

## What versions of Rails does this work with?

We run tests using Rails `4.2.6`, `5.0.0.beta3`, `5.1.6` and `5.2`

| Version | Working? |
| --- | --- |
| 3.0 | No * |
| 3.1 | Yes |
| 3.2 | Yes |
| 4.0 | Yes |
| 4.1 | Yes |
| 4.2 | Yes |
| 5.0 | Yes |
| 5.1 | Yes |
| 5.2 | Yes |

\* It relies on the asset pipeline so I'd be surprised if it works. Not tested.

\** I'm recommending using the [premailer](https://github.com/premailer/premailer) gem for Rails > 5.0.

## What about Ruby?

Anything later than Ruby `1.9.2` should be fine. We test using Ruby 2.0.0`, `2.1.8`, `2.2.4` and `2.3.0`.

### 1.9 Support

We don't test with Ruby `1.9` because there is a dependency on the `mime-types-data` gem for which the latest version requires Ruby `2.0` or later. That doesn't mean you can't use Ruby `1.9.3` but you'll need to make sure you're using a version of `mime-types-data` less than `3`.

## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/billhorsman/inline_styles_mailer/issues). You can contribute changes by forking the project and submitting a pull request. You can ensure the tests passing by running `bundle` and `rake`.

The tests also run on [Travis CI](http://travis-ci.org/#!/billhorsman/inline_styles_mailer).

This gem was created by Bill Horsman and is under the MIT License.
