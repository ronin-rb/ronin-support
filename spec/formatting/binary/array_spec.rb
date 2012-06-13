require 'spec_helper'
require 'ronin/formatting/extensions/binary/array'

describe Array do
  subject { [0x1234, "hello"] }

  it "should provide Array#pack" do
    should respond_to(:pack)
  end

  describe "#pack" do
    let(:packed) { "\x34\x12hello\0" }

    it "should pack elements using Array#pack codes" do
      subject.pack('vZ*').should == packed
    end

    it "should pack elements using Binary::Template types" do
      subject.pack(:uint16_le, :string).should == packed
    end
  end
end
