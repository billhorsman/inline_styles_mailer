require 'spec_helper'
require 'foo_mailer'
require 'rails/all'

describe InlineStylesMailer do
  before(:each) do
    FooMailer.reset
    Rails.should_receive(:root).any_number_of_times.and_return(Pathname.new(File.join("spec", "fixtures")))
    FooMailer.stylesheet_path "assets/stylesheets"
  end

  context "Default CSS file" do
    it "should inline the CSS" do
      mail = FooMailer.foo
      mail.body.should =~ /<p style="color: red;">Testing foo\.<\/p>/
      mail.body.should =~ /<body style="background: yellow;">/
    end
  end

  context "SCSS preprocessing" do
    before(:each) do
      FooMailer.use_stylesheet("_override.css.scss")
    end
    it "should inline the CSS" do
      mail = FooMailer.foo
      mail.body.should =~ /<p style="color: orange;">Testing foo\.<\/p>/
      mail.body.should =~ /<body style="background: yellow;">/
    end
  end

  context "SASS preprocessing" do
    before(:each) do
      FooMailer.use_stylesheet("_override.css.sass")
    end
    it "should inline the CSS" do
      mail = FooMailer.foo
      mail.body.should =~ /<p style="color: green;">Testing foo\.<\/p>/
      mail.body.should =~ /<body style="background: yellow;">/
    end
  end

  context "No preprocessing (plain old CSS)" do
    before(:each) do
      FooMailer.use_stylesheet("_override.css")
    end
    it "should inline the CSS" do
      mail = FooMailer.foo
      mail.body.should =~ /<p style="color: blue;">Testing foo\.<\/p>/
      mail.body.should =~ /<body style="background: yellow;">/
    end
  end

end