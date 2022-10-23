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

    context "when given `case: :lower`" do
      subject { 0xFF }

      let(:http_encoded) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.http_encode(case: :lower)).to eq(http_encoded)
      end
    end

    context "when given `case: :upper`" do
      subject { 0xFF }

      let(:http_encoded) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.http_encode(case: :upper)).to eq(http_encoded)
      end
    end

    context "when given the `case:` keyword argument with another value" do
      subject { 0xFF }

      it do
        expect {
          subject.http_encode(case: :foo)
        }.to raise_error(ArgumentError,"case (:foo) keyword argument must be either :lower, :upper, or nil")
      end
    end

    context "when given an Integer greater that 0xff" do
      subject { 0x100 }

      it do
        expect {
          subject.http_encode
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end

    context "when given a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.http_encode
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end

  describe "#http_escape" do
    [45, 46, *(48..57), *(65..90), 95, *(97..122), 126].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:char) { subject.chr }

        it "must return the ASCII character for the byte" do
          expect(subject.http_escape).to eq(char)
        end
      end
    end

    context "when given the byte 0x20" do
      subject { 0x20 }

      it "must return '+'" do
        expect(subject.http_escape).to eq('+')
      end
    end

    [*(0..31), *(33..44), 47, *(58..64), *(91..94), 96, *(123..125), *(127..255)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:http_escaped) { "%%%.2X" % subject }

        it "must URI escape the Integer" do
          expect(subject.http_escape).to eq(http_escaped)
        end
      end
    end

    context "when given `case: :lower`" do
      subject { 0xFF }

      let(:http_escaped) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.http_escape(case: :lower)).to eq(http_escaped)
      end
    end

    context "when given `case: :upper`" do
      subject { 0xFF }

      let(:http_escaped) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.http_escape(case: :upper)).to eq(http_escaped)
      end
    end

    context "when given the `case:` keyword argument with another value" do
      subject { 0xFF }

      it do
        expect {
          subject.http_escape(case: :foo)
        }.to raise_error(ArgumentError,"case (:foo) keyword argument must be either :lower, :upper, or nil")
      end
    end

    context "when given an Integer greater that 0xff" do
      subject { 0x100 }

      it do
        expect {
          subject.http_escape
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end

    context "when given a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.http_escape
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end
end
