require 'spec_helper'
require 'ronin/support/format/uuencoding/core_ext/string'

describe String do
  subject { "hello world" }

  it "must provide String#uu_encode" do
    expect(subject).to respond_to(:uu_encode)
  end

  it "must provide String#uu_decode" do
    expect(subject).to respond_to(:uu_decode)
  end

  it "must provide String#uu_escape" do
    expect(subject).to respond_to(:uu_escape)
  end

  it "must provide String#uu_unescape" do
    expect(subject).to respond_to(:uu_unescape)
  end

  it "must provide String#uuencode" do
    expect(subject).to respond_to(:uuencode)
  end

  it "must provide String#uudecode" do
    expect(subject).to respond_to(:uudecode)
  end

  describe "#uu_encode" do
    it "must UU encode the String" do
      expect(subject.uu_encode).to eq("+:&5L;&\\@=V]R;&0`\n")
    end
  end

  describe "#uu_decode" do
    subject { "+:&5L;&\\@=V]R;&0`\n" }

    it "must UU encode the String" do
      expect(subject.uu_decode).to eq("hello world")
    end
  end
end
