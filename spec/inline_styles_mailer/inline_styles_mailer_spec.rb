require 'spec_helper'
require 'foo_mailer'
require 'rails/all'

describe InlineStylesMailer do
  before(:each) do
    FooMailer.reset
    Rails.should_receive(:root).any_number_of_times.and_return(Pathname.new(File.join("spec", "fixtures")))
  end

  context "SCSS preprocessing" do
    before(:each) do
      file = File.join("spec", "fixtures", "assets", "stylesheets", "_foo_mailer.css.scss")
      FooMailer.should_receive(:locate_css_file).and_return(file)
    end
    it "should inline the CSS" do
      mail = FooMailer.foo
      mail.body.should =~ /<p style="color: red;">Testing foo\.<\/p>/
      mail.body.should =~ /<body style="background: yellow;">/
    end
  end

  context "SASS preprocessing" do
    before(:each) do
      file = File.join("spec", "fixtures", "assets", "stylesheets", "_foo_mailer.css.sass")
      FooMailer.should_receive(:locate_css_file).and_return(file)
    end
    it "should inline the CSS" do
      mail = FooMailer.foo
      mail.body.should =~ /<p style="color: red;">Testing foo\.<\/p>/
      mail.body.should =~ /<body style="background: yellow;">/
    end
  end

  context "No preprocessing (plain old CSS)" do
    before(:each) do
      file = File.join("spec", "fixtures", "assets", "stylesheets", "_foo_mailer.css")
      FooMailer.should_receive(:locate_css_file).and_return(file)
    end
    it "should inline the CSS" do
      mail = FooMailer.foo
      mail.body.should =~ /<p style="color: red;">Testing foo\.<\/p>/
      mail.body.should =~ /<body style="background: yellow;">/
    end
  end

end