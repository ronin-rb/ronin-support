require 'spec_helper'
require 'ronin/formatting/extensions/js/string'

describe String do
  subject { "one & two" }

  it "should provide String#js_escape" do
    should respond_to(:js_escape)
  end

  it "should provide String#js_unescape" do
    should respond_to(:js_unescape)
  end

  it "should provide String#format_js" do
    should respond_to(:format_js)
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
    let(:js_mixed) { "%u6F%u6E%u65 %26 two" }

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
    let(:js_formatted) { '\x6F\x6E\x65\x20\x26\x20\x74\x77\x6F' }

    it "should JavaScript escape all characters" do
      subject.format_js.should == js_formatted
    end
  end
end
