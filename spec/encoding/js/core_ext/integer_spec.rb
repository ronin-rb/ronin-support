require 'spec_helper'
require 'ronin/support/encoding/js/core_ext/integer'

describe Integer do
  subject { 0x26 }

  it { expect(subject).to respond_to(:js_escape) }
  it { expect(subject).to respond_to(:js_encode) }

  describe "#js_escape" do
    let(:special_byte) { 0x0a }
    let(:escaped_special_byte) { '\n' }

    let(:normal_byte) { 0x41 }
    let(:normal_char) { 'A' }

    it "must escape special JavaScript characters" do
      expect(special_byte.js_escape).to eq(escaped_special_byte)
    end

    it "must ignore normal characters" do
      expect(normal_byte.js_escape).to eq(normal_char)
    end
  end

  describe "#js_encode" do
    let(:js_escaped) { '\x26' }

    it "must JavaScript format ascii bytes" do
      expect(subject.js_encode).to eq(js_escaped)
    end

    it "must JavaScript format unicode bytes" do
      expect(0xd556.js_encode).to eq('\uD556')
    end
  end
end
