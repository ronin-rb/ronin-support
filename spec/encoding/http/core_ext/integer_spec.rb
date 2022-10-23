require 'spec_helper'
require 'ronin/support/encoding/http/core_ext/integer'

describe Integer do
  subject { 0x20 }

  it "must provide Integer#http_encode" do
    expect(subject).to respond_to(:http_encode)
  end

  it "must provide Integer#http_escape" do
    expect(subject).to respond_to(:http_escape)
  end

  describe "#http_encode" do
    let(:http_formatted) { '%20' }

    it "must format the byte" do
      expect(subject.http_encode).to eq(http_formatted)
    end

    context "when the Integer is below 0x10" do
      subject { 0x01 }

      let(:encoded_byte) { '%01' }

      it "must zero-pad the escaped character to ensure two digits" do
        expect(subject.http_encode).to eq(encoded_byte)
      end
    end
  end

  describe "#http_escape" do
    let(:http_escaped) { '+' }

    it "must format the byte" do
      expect(subject.http_escape).to eq(http_escaped)
    end
  end
end
