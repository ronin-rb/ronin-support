require 'spec_helper'
require 'ronin/formatting/http'

describe String do
  subject { "hello" }

  it "should provide String#uri_encode" do
    should respond_to(:uri_encode)
  end

  it "should provide String#uri_decode" do
    should respond_to(:uri_decode)
  end

  it "should provide String#uri_escape" do
    should respond_to(:uri_escape)
  end

  it "should provide String#uri_unescape" do
    should respond_to(:uri_unescape)
  end

  it "should provide String#format_http" do
    should respond_to(:format_http)
  end

  describe "uri_encode" do
    subject { "mod % 3" }

    let(:uri_encoded) { "mod%20%25%203" }

    it "should URI encode itself" do
      subject.uri_encode.should == uri_encoded
    end
  end

  describe "uri_decode" do
    subject { "mod%20%25%203" }

    let(:uri_unencoded) { "mod % 3" }

    it "should URI decode itself" do
      subject.uri_decode.should == uri_unencoded
    end
  end

  describe "uri_escape" do
    subject { "x + y" }

    let(:uri_escaped) { "x+%2B+y" }

    it "should URI escape itself" do
      subject.uri_escape.should == uri_escaped
    end
  end

  describe "uri_unescape" do
    subject { "x+%2B+y" }

    let(:uri_unescaped) { "x + y" }

    it "should URI unescape itself" do
      subject.uri_unescape.should == uri_unescaped
    end
  end

  describe "format_http" do
    subject { "mod % 3" }

    let(:uri_http_encoded) { "%6d%6f%64%20%25%20%33" }

    it "should format each byte of the String" do
      subject.format_http.should == uri_http_encoded
    end
  end
end
