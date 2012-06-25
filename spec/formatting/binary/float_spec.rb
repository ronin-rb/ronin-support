require 'spec_helper'
require 'ronin/formatting/extensions/binary/float'

describe Float do
  subject { 0.42 }

  it "should provide Float#pack" do
    should respond_to(:pack)
  end

  describe "#pack" do
    let(:packed) { "\xE1z\x14\xAEG\xE1\xDA?" }

    context "when only given a String" do
      it "should unpack Strings using String#unpack template Strings" do
        subject.pack('E').should == packed
      end
    end

    context "when given a Binary::Template Float type" do
      it "should unpack Strings using Binary::Template" do
        subject.pack(:double_le).should == packed
      end
    end

    context "when given non-Float Binary::Template types" do
      it "should raise an ArgumentError" do
        lambda {
          subject.pack(:int)
        }.should raise_error(ArgumentError)
      end
    end
  end
end
