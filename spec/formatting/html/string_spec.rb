require 'spec_helper'
require 'ronin/formatting/extensions/html/string'

describe String do
  subject { "one & two" }

  it "should provide String#html_escape" do
    should respond_to(:html_escape)
  end

  it "should provide String#html_unescape" do
    should respond_to(:html_unescape)
  end

  it "should provide String#format_html" do
    should respond_to(:format_html)
  end

  it "should provide String#js_escape" do
    should respond_to(:js_escape)
  end

  it "should provide String#js_unescape" do
    should respond_to(:js_unescape)
  end

  it "should provide String#format_js" do
    should respond_to(:format_js)
  end

  describe "#html_escape" do
    let(:html_escaped) { "one &amp; two" }

    it "should HTML escape itself" do
      subject.html_escape.should == html_escaped
    end
  end

  describe "#html_unescape" do
    let(:html_escaped) { "one &amp; two" }

    it "should HTML unescape itself" do
      html_escaped.html_unescape.should == subject
    end
  end

  describe "#format_html" do
    let(:formatted_html) do
      "&#111;&#110;&#101;&#32;&#38;&#32;&#116;&#119;&#111;"
    end

    it "should HTML format all chars" do
      subject.format_html.should == formatted_html
    end
  end

  describe "#js_escape" do
    let(:special_chars) { "\t\n\r" }
    let(:escaped_special_chars) { '\t\n\r' }

    let(:normal_chars) { "abc" }

    it "should escape special JavaScript characters" do
      special_chars.js_escape.should == escaped_special_chars
    end

    it "should ignore normal characters" do
      normal_chars.js_escape.should == normal_chars
    end
  end

  describe "#js_unescape" do
    let(:js_unicode) do
      "%u006F%u006E%u0065%u0020%u0026%u0020%u0074%u0077%u006F"
    end
    let(:js_hex) { "%6F%6E%65%20%26%20%74%77%6F" }
    let(:js_mixed) { "one %26 two" }

    it "should unescape JavaScript unicode characters" do
      js_unicode.js_unescape.should == subject
    end

    it "should unescape JavaScript hex characters" do
      js_hex.js_unescape.should == subject
    end

    it "should unescape backslash-escaped characters" do
      "\\b\\t\\n\\f\\r\\\"\\\\".js_unescape.should == "\b\t\n\f\r\"\\"
    end

    it "should ignore non-escaped characters" do
      js_mixed.js_unescape.should == subject
    end
  end

  describe "#format_js" do
    let(:js_formatted) { "%6F%6E%65%20%26%20%74%77%6F" }

    it "should JavaScript escape all characters" do
      subject.format_js.should == js_formatted
    end
  end
end
