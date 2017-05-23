require 'rails/all'

module Foo
  class BarMailer < ActionMailer::Base
    include InlineStylesMailer

    def bar
      mail(:to => "test@localhost", :subject => "Test Bar")
    end
  end
end