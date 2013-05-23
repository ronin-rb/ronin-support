require 'spec_helper'
require 'ronin/formatting/extensions/js/integer'

describe Integer do
  subject { 0x26 }

  it "should provide String#js_escape" do
    should respond_to(:js_escape)
  end

  it "should provide String#format_js" do
    should respond_to(:format_js)
  end

  describe "#js_escape" do
    let(:special_byte) { 0x0a }
    let(:escaped_special_byte) { '\n' }

    let(:normal_byte) { 0x41 }
    let(:normal_char) { 'A' }

    it "should escape special JavaScript characters" do
      special_byte.js_escape.should == escaped_special_byte
    end

    it "should ignore normal characters" do
      normal_byte.js_escape.should == normal_char
    end
  end

  describe "#format_js" do
    let(:js_escaped) { '\x26' }

    it "should JavaScript format ascii bytes" do
      subject.format_js.should == js_escaped
    end

    it "should JavaScript format unicode bytes" do
      0xd556.format_js.should == '\uD556'
    end
  end
end