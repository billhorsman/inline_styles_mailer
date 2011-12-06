require 'rails/all'

class FooMailer < ActionMailer::Base
  include InlineStylesMailer

  def foo
    mail(:to => "test@localhost", :subject => "Test")
  end

end