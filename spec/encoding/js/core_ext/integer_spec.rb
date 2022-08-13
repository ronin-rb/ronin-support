require 'spec_helper'
require 'ronin/support/encoding/js/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it { expect(subject).to respond_to(:js_escape) }
  it { expect(subject).to respond_to(:js_encode) }

  describe "#js_escape" do
    context "when given a byte that maps to a special character" do
      subject {  0x0a }

      let(:escaped_special_byte) { '\n' }

      it "must escape special JavaScript characters" do
        expect(subject.js_escape).to eq(escaped_special_byte)
      end
    end

    context "when given a byte that maps to a printable ASCII character" do
      subject { 0x41 }

      let(:normal_char) { 'A' }

      it "must ignore normal characters" do
        expect(subject.js_escape).to eq(normal_char)
      end
    end
  end

  describe "#js_encode" do
    context "when given a ASCII byte" do
      let(:js_escaped) { '\x26' }

      it "must JavaScript format ascii bytes" do
        expect(subject.js_encode).to eq(js_escaped)
      end
    end

    context "when given a unicode byte" do
      subject { 0xd556 }

      let(:escaped_unicode_byte) { '\uD556' }

      it "must JavaScript format unicode bytes" do
        expect(subject.js_encode).to eq('\uD556')
      end
    end
  end
end
