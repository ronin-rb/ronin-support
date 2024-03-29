require 'spec_helper'
require 'ronin/support/encoding/uri/core_ext/integer'

describe Integer do
  subject { 0x20 }

  it { expect(subject).to respond_to(:uri_encode) }
  it { expect(subject).to respond_to(:uri_escape) }
  it { expect(subject).to respond_to(:uri_form_encode) }
  it { expect(subject).to respond_to(:uri_form_escape) }

  describe "#uri_encode" do
    subject { 0x41 }

    let(:uri_encoded) { '%41' }

    it "must URI encode the Integer" do
      expect(subject.uri_encode).to eq(uri_encoded)
    end

    context "when the byte is less than 0x10" do
      subject { 0x01 }

      let(:uri_encoded) { '%01' }

      it "must zero-pad the escaped character" do
        expect(subject.uri_encode).to eq(uri_encoded)
      end
    end

    context "when given `case: :lower`" do
      subject { 0xFF }

      let(:uri_encoded) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.uri_encode(case: :lower)).to eq(uri_encoded)
      end
    end

    context "when given `case: :upper`" do
      subject { 0xFF }

      let(:uri_encoded) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.uri_encode(case: :upper)).to eq(uri_encoded)
      end
    end

    context "when given an Integer greater that 0xff" do
      subject { 0x100 }

      it do
        expect {
          subject.uri_encode
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end

    context "when given a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.uri_encode
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end

  describe "#uri_escape" do
    [33, 36, 38, *(39..59), 61, *(63..91), 93, 95, *(97..122), 126].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:char) { byte.chr }

        it "must return the ASCII character for the byte" do
          expect(subject.uri_escape).to eq(char)
        end
      end
    end

    [*(0..32), 34, 35, 37, 60, 62, 92, 94, 96, *(123..125), *(127..255)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:uri_escaped) { "%%%.2X" % byte }

        it "must URI escape the Integer" do
          expect(subject.uri_escape).to eq(uri_escaped)
        end
      end
    end

    context "when given `case: :lower`" do
      subject { 0xFF }

      let(:uri_escaped) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.uri_escape(case: :lower)).to eq(uri_escaped)
      end
    end

    context "when given `case: :upper`" do
      subject { 0xFF }

      let(:uri_escaped) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.uri_escape(case: :upper)).to eq(uri_escaped)
      end
    end

    context "when given an Integer greater that 0xff" do
      subject { 0x100 }

      it do
        expect {
          subject.uri_escape
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end

    context "when given a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.uri_escape
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end

  describe "#uri_form_encode" do
    subject { 0x41 }

    let(:uri_form_encoded) { '%41' }

    it "must URI encode the Integer" do
      expect(subject.uri_form_encode).to eq(uri_form_encoded)
    end

    context "when given `case: :lower`" do
      subject { 0xFF }

      let(:uri_form_encoded) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.uri_form_encode(case: :lower)).to eq(uri_form_encoded)
      end
    end

    context "when given `case: :upper`" do
      subject { 0xFF }

      let(:uri_form_encoded) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.uri_form_encode(case: :upper)).to eq(uri_form_encoded)
      end
    end

    context "when given an Integer greater that 0xff" do
      subject { 0x100 }

      it do
        expect {
          subject.uri_encode
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end

    context "when given a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.uri_encode
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end

  describe "#uri_form_escape" do
    [42, 45, 46, *(48..57), *(65..90), 95, *(97..122)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:char) { byte.chr }

        it "must return the ASCII character for the byte" do
          expect(subject.uri_form_escape).to eq(char)
        end
      end
    end

    context "when the Integer is 0x20" do
      subject { 0x20 }

      it "must return '+'" do
        expect(subject.uri_form_escape).to eq('+')
      end
    end

    [*(0..31), *(33..41), 43, 44, 47, *(58..64), *(91..94), 96, *(123..255)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:uri_escaped) { "%%%.2X" % byte }

        it "must URI escape the Integer" do
          expect(subject.uri_form_escape).to eq(uri_escaped)
        end
      end
    end

    context "when given `case: :lower`" do
      subject { 0xFF }

      let(:uri_form_escaped) { '%ff' }

      it "must return a lowercase hexadecimal escaped character" do
        expect(subject.uri_form_escape(case: :lower)).to eq(uri_form_escaped)
      end
    end

    context "when given `case: :upper`" do
      subject { 0xFF }

      let(:uri_form_escaped) { '%FF' }

      it "must return a uppercase hexadecimal escaped character" do
        expect(subject.uri_form_escape(case: :upper)).to eq(uri_form_escaped)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      let(:uri_form_escaped) { '%FF' }

      it "must URI encode the Integer" do
        expect(subject.uri_form_escape).to eq(uri_form_escaped)
      end
    end

    context "when given an Integer greater that 0xff" do
      subject { 0x100 }

      it do
        expect {
          subject.uri_escape
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end

    context "when given a negative Integer" do
      subject { -1 }

      it do
        expect {
          subject.uri_escape
        }.to raise_error(RangeError,"#{subject.inspect} out of char range")
      end
    end
  end
end
