require 'spec_helper'
require 'ronin/formatting/extensions/binary/array'

describe Array do
  subject { [0x1234, "hello"] }

  it "should provide Array#pack" do
    should respond_to(:pack)
  end

  describe "#pack" do
    let(:packed) { "\x34\x12hello\0" }

    context "when only given a String" do
      it "should pack elements using Array#pack codes" do
        subject.pack('vZ*').should == packed
      end
    end

    context "otherwise" do
      it "should pack fields using Binary::Template" do
        subject.pack(:uint16_le, :string).should == packed
      end
    end
  end
end
