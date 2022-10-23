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
    [*(0..32), 34, 35, 37, 60, 62, 92, 94, 96, *(123..125), *(127..255)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:uri_escaped) { "%%%2X" % byte }

        it "must URI escape the Integer" do
          expect(subject.uri_escape).to eq(uri_escaped)
        end
      end
    end

    context "when called on a printable ASCII character" do
      subject { 0x41 }

      it "must return that character" do
        expect(subject.uri_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      let(:uri_escaped) { '%FF' }

      it "must URI encode the Integer" do
        expect(subject.uri_escape).to eq(uri_escaped)
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
    [*(0..31), 34, 35, 37, 60, 62, 92, 94, 96, *(123..125), *(127..255)].each do |byte|
      context "when given the byte 0x#{byte.to_s(16)}" do
        subject { byte }

        let(:uri_escaped) { "%%%2X" % byte }

        it "must URI escape the Integer" do
          expect(subject.uri_form_escape).to eq(uri_escaped)
        end
      end
    end

    context "when the Integer is 0x20" do
      subject { 0x20 }

      it "must return '+'" do
        expect(subject.uri_form_escape).to eq('+')
      end
    end

    context "when the Integer maps to a special character" do
      subject { 0x23 } # '#'

      let(:uri_form_escaped) { '%23' }

      it "must URI escape the Integer" do
        expect(subject.uri_form_escape).to eq(uri_form_escaped)
      end
    end

    context "when called on a printable ASCII character" do
      subject { 0x41 }

      it "must return that character" do
        expect(subject.uri_form_escape).to eq(subject.chr)
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
