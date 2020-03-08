require 'spec_helper'
require 'ronin/formatting/extensions/binary/base64'

describe Base64 do
  subject { described_class }

  if RUBY_VERSION < '1.9.'
    let(:string) { '>' * 64 }

    let(:base64) { "Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+\nPj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pg==\n" }
    let(:strict_base64) { "Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pg==" }
    let(:urlsafe_base64) { "Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pj4-Pg==" }

    describe "strict_encode64" do
      it "should strictly encode a String" do
        expect(subject.strict_encode64(string)).to eq(strict_base64)
      end
    end

    describe "strict_decode64" do
      it "should strict decode an encoded Base64 String" do
        expect(subject.strict_decode64(strict_base64)).to eq(string)
      end

      it "should raise an ArgumentError for non-strictly encoded Base64" do
        expect {
          subject.strict_decode64(base64)
        }.to raise_error(ArgumentError)
      end
    end

    describe "urlsafe_encode64" do
      it "should encode URL-safe Base64 Strings" do
        expect(subject.urlsafe_encode64(string)).to eq(urlsafe_base64)
      end
    end

    describe "urlsafe_decode64" do
      it "should decode URL-safe Base64 String" do
        expect(subject.urlsafe_decode64(urlsafe_base64)).to eq(string)
      end

      it "should raise an ArgumentError for non-strictly encoded Base64" do
        expect {
          subject.urlsafe_decode64(base64)
        }.to raise_error(ArgumentError)
      end
    end
  end
end
