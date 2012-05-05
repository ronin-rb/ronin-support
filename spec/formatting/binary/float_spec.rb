require 'spec_helper'
require 'ronin/formatting/extensions/binary/float'

describe Float do
  subject { 0.42 }

  it "should provide Float#pack" do
    should respond_to(:pack)
  end

  describe "#pack" do
    let(:packed) { "\xE1z\x14\xAEG\xE1\xDA?" }

    it "should unpack Strings using String#unpack template Strings" do
      subject.pack('E').should == packed
    end

    it "should unpack Strings using a Binary::Template" do
      subject.pack(:double_le).should == packed
    end
  end
end
