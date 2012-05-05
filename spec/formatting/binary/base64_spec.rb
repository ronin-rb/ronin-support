require 'spec_helper'
require 'ronin/formatting/extensions/binary/base64'

describe Base64 do
  subject { described_class }

  if RUBY_VERSION < '1.9'
    let(:string) { '>' * 64 }

    let(:base64) { "Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+\nPj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pg==\n" }
    let(:strict_base64) { "Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pg==" }
    let(:urlsafe_base64) { "Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pg==" }

    describe "strict_encode64" do
      it "should strictly encode a String" do
        subject.strict_encode64(string).should == strict_base64
      end
    end

    describe "strict_decode64" do
      it "should strict decode an encoded Base64 String" do
        subject.strict_decode64(strict_base64).should == string
      end

      it "should raise an ArgumentError for non-strictly encoded Base64" do
        lambda {
          subject.strict_decode64(base64)
        }.should raise_error(ArgumentError)
      end
    end

    describe "urlsafe_encode64" do
      it "should encode URL-safe Base64 Strings" do
        subject.urlsafe_encode64(string).should == urlsafe_base64
      end
    end

    describe "urlsafe_decode64" do
      it "should decode URL-safe Base64 String" do
        subject.urlsafe_decode64(urlsafe_base64).should == string
      end

      it "should raise an ArgumentError for non-strictly encoded Base64" do
        lambda {
          subject.urlsafe_decode64(base64)
        }.should raise_error(ArgumentError)
      end
    end
  end
end
