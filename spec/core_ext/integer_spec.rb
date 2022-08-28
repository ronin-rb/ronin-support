require 'spec_helper'
require 'ronin/support/core_ext/integer'

describe Integer do
  subject { 0x41 }

  describe "#char" do
    it "must alias char to the #chr method" do
      expect(subject.char).to eq(subject.chr)
    end
  end

  describe "#to_hex" do
    it "must return a hexadecimal formatted String of the Integer" do
      expect(subject.to_hex).to eq('41')
    end
  end
end
