require 'spec_helper'
require 'foo_mailer'
require 'rails/all'

describe InlineStylesMailer do
  before(:each) do
    FooMailer.reset
    Rails.stub(:root).and_return(Pathname.new(File.join("spec", "fixtures")))
  end

  describe "Inlining CSS" do
    before do
      FooMailer.stylesheet_path "assets/stylesheets"
    end

    context "Default CSS file" do
      it "should inline the CSS" do
        mail = FooMailer.foo
        mail.body.parts.length.should eq(2)
        mail.body.parts[1].body.should =~ /<p style="color: red;">Testing foo text\/html\.<\/p>/
        mail.body.parts[1].body.should =~ /<body style="background: yellow;">/
      end
    end

    context "SCSS preprocessing" do
      before(:each) do
        FooMailer.use_stylesheet("_override.css.scss")
      end
      it "should inline the CSS" do
        mail = FooMailer.foo
        mail.body.parts.length.should eq(2)
        mail.body.parts[1].body.should =~ /<p style="color: orange;">Testing foo text\/html\.<\/p>/
        mail.body.parts[1].body.should =~ /<body style="background: yellow;">/
      end
    end

    context "SASS preprocessing" do
      before(:each) do
        FooMailer.use_stylesheet("_override.css.sass")
      end
      it "should inline the CSS" do
        mail = FooMailer.foo
        mail.body.parts.length.should eq(2)
        mail.body.parts[1].body.should =~ /<p style="color: green;">Testing foo text\/html\.<\/p>/
        mail.body.parts[1].body.should =~ /<body style="background: yellow;">/
      end
    end

    context "No preprocessing (plain old CSS)" do
      before(:each) do
        FooMailer.use_stylesheet("_override.css")
      end
      it "should inline the CSS" do
        mail = FooMailer.foo
        mail.body.parts.length.should eq(2)
        mail.body.parts[1].body.should =~ /<p style="color: blue;">Testing foo text\/html\.<\/p>/
        mail.body.parts[1].body.should =~ /<body style="background: yellow;">/
      end
    end

  end

  describe "Switch parts order" do

    context "text/plain first (default)" do
      it "should inline the CSS" do
        mail = FooMailer.foo
        mail.body.parts.length.should eq(2)
        mail.body.parts[0].content_type.should =~ /^text\/plain/
        mail.body.parts[1].content_type.should =~ /^text\/html/
      end
    end

    context "text/html first" do
      it "should inline the CSS" do
        mail = FooMailer.backwards
        mail.body.parts.length.should eq(2)
        mail.body.parts[0].content_type.should =~ /^text\/html/
        mail.body.parts[1].content_type.should =~ /^text\/plain/
      end
    end

  end

end
