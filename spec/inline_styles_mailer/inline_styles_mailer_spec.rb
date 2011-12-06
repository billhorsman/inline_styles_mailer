require 'spec_helper'
require 'foo_mailer'
require 'rails/all'

describe InlineStylesMailer do

  it "should instantiate FooMailer" do
    FooMailer.should_receive(:locate_css_file).and_return(File.join("spec", "fixtures", "assets", "stylesheets", "_foo_mailer.css.scss"))
    Rails.should_receive(:root).any_number_of_times.and_return(Pathname.new(File.join("spec", "fixtures")))
    mail = FooMailer.foo
    mail.body.should =~ /<p style="color: red;">Testing foo\.<\/p>/
    mail.body.should =~ /<body style="background: yellow;">/
  end

end