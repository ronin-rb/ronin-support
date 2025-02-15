require 'spec_helper'
require 'ronin/support/encoding/node_js/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it { expect(subject).to respond_to(:node_js_escape) }
  it { expect(subject).to respond_to(:node_js_encode) }

  describe "#node_js_escape" do
    context "when given a byte that maps to a special character" do
      subject { 0x0a }

      let(:escaped_special_byte) { '\n' }

      it "must escape special Node.js characters" do
        expect(subject.node_js_escape).to eq(escaped_special_byte)
      end
    end

    context "when given a byte that maps to a printable ASCII character" do
      subject { 0x41 }

      let(:normal_char) { 'A' }

      it "must ignore normal characters" do
        expect(subject.node_js_escape).to eq(normal_char)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      let(:escaped_byte) { '\xFF' }

      it "must escape special Node.js characters" do
        expect(subject.node_js_escape).to eq(escaped_byte)
      end
    end

    context "when called on an Integer between 0x100 and 0xffff" do
      subject { 0xFFFF }

      let(:escaped_byte) { '\uFFFF' }

      it "must return the lowercase '\\uXXXX' escaped Node.js character" do
        expect(subject.node_js_escape).to eq(escaped_byte)
      end
    end
  end

  describe "#node_js_encode" do
    context "when given a ASCII byte" do
      let(:node_js_escaped) { '\x26' }

      it "must Node.js format ascii bytes" do
        expect(subject.node_js_encode).to eq(node_js_escaped)
      end
    end

    context "when given a unicode byte" do
      subject { 0xd556 }

      let(:escaped_unicode_byte) { '\uD556' }

      it "must Node.js format unicode bytes" do
        expect(subject.node_js_encode).to eq('\uD556')
      end
    end
  end
end
