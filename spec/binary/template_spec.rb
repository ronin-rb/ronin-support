require 'spec_helper'
require 'ronin/binary/template'

describe Binary::Template do
  subject { described_class.new(:uint32, :string) }

  describe "TYPES" do
    subject { described_class::TYPES }

    it("uint8      => C") { subject[:uint8].should       == 'C' }
    it("uint16     => S") { subject[:uint16].should      == 'S' }
    it("uint32     => L") { subject[:uint32].should      == 'L' }
    it("uint64     => Q") { subject[:uint64].should      == 'Q' }
    it("int8       => C") { subject[:int8].should        == 'c' }
    it("int16      => S") { subject[:int16].should       == 's' }
    it("int32      => L") { subject[:int32].should       == 'l' }
    it("int64      => Q") { subject[:int64].should       == 'q' }
    if RUBY_VERSION < '1.9'
    it("uint16_le  => v") { subject[:uint16_le].should   == 'v' }
    it("uint32_le  => V") { subject[:uint32_le].should   == 'V' }
    it("uint16_be  => n") { subject[:uint16_be].should   == 'n' }
    it("uint32_be  => N") { subject[:uint32_be].should   == 'N' }
    end
    it("uchar      => C")  { subject[:uchar].should      == 'C' }
    it("ushort     => S!") { subject[:ushort].should     == 'S!'}
    it("uint       => I!") { subject[:uint].should       == 'I!'}
    it("ulong      => L!") { subject[:ulong].should      == 'L!'}
    it("ulong_long => Q")  { subject[:ulong_long].should == 'Q' }
    it("char       => c")  { subject[:char].should       == 'c' }
    it("short      => s!") { subject[:short].should      == 's!'}
    it("int        => i!") { subject[:int].should        == 'i!'}
    it("long       => l!") { subject[:long].should       == 'l!'}
    it("long_long  => q")  { subject[:long_long].should  == 'q' }
    it("utf8       => U")  { subject[:utf8].should       == 'U' }
    it("float      => F") { subject[:float].should       == 'F' }
    it("double     => D") { subject[:double].should      == 'D' }
    it("float_le   => e") { subject[:float_le].should    == 'e' }
    it("double_le  => E") { subject[:double_le].should   == 'E' }
    it("float_be   => g") { subject[:float_be].should    == 'g' }
    it("double_ge  => G") { subject[:double_be].should   == 'G' }
    it("string     => Z*") { subject[:string].should     == 'Z*'}

    if RUBY_VERSION > '1.9'
      context "Ruby 1.9" do
        it("uint16_le     => S<") { subject[:uint16_le].should      == 'S<' }
        it("uint32_le     => L<") { subject[:uint32_le].should      == 'L<' }
        it("uint64_le     => Q<") { subject[:uint64_le].should      == 'Q<' }
        it("int16_le      => S<") { subject[:int16_le].should       == 's<' }
        it("int32_le      => L<") { subject[:int32_le].should       == 'l<' }
        it("int64_le      => Q<") { subject[:int64_le].should       == 'q<' }
        it("uint16_be     => S>") { subject[:uint16_be].should      == 'S>' }
        it("uint32_be     => L>") { subject[:uint32_be].should      == 'L>' }
        it("uint64_be     => Q>") { subject[:uint64_be].should      == 'Q>' }
        it("int16_be      => S>") { subject[:int16_be].should       == 's>' }
        it("int32_be      => L>") { subject[:int32_be].should       == 'l>' }
        it("int64_be      => Q>") { subject[:int64_be].should       == 'q>' }
        it("ushort_le     => S!<") { subject[:ushort_le].should     == 'S!<'}
        it("uint_le       => I!<") { subject[:uint_le].should       == 'I!<'}
        it("ulong_le      => L!<") { subject[:ulong_le].should      == 'L!<'}
        it("ulong_long_le => L!<") { subject[:ulong_long_le].should == 'Q<' }
        it("short_le      => S!<") { subject[:short_le].should      == 's!<'}
        it("int_le        => I!<") { subject[:int_le].should        == 'i!<'}
        it("long_le       => L!<") { subject[:long_le].should       == 'l!<'}
        it("long_long_le  => L!<") { subject[:long_long_le].should  == 'q<' }
        it("ushort_be     => S!>") { subject[:ushort_be].should     == 'S!>'}
        it("uint_be       => I!>") { subject[:uint_be].should       == 'I!>'}
        it("ulong_be      => L!>") { subject[:ulong_be].should      == 'L!>'}
        it("ulong_long_be => L!>") { subject[:ulong_long_be].should == 'Q>' }
        it("short_be      => S!>") { subject[:short_be].should      == 's!>'}
        it("int_be        => I!>") { subject[:int_be].should        == 'i!>'}
        it("long_be       => L!>") { subject[:long_be].should       == 'l!>'}
        it("long_long_be  => L!>") { subject[:long_long_be].should  == 'q>' }
      end
    end
  end

  describe "#initialize" do
    it "should store the types" do
      subject.types.should == [
        :uint32,
        :string
      ]
    end

    it "should raise ArgumentError for unknown types" do
      lambda {
        described_class.new(:uint, :foo)
      }.should raise_error(ArgumentError)
    end
  end

  ENDIANNESS = if [0x1234].pack('S') == "\x34\x12"
                 :little
               else
                 :big
               end

  let(:byte) { 0x41 }
  let(:char) { 'A' }

  let(:bytes) { [104, 101, 108, 108, 111] }
  let(:chars) { ["h", "e", "l", "l", "o"] }
  let(:string) { "hello" }

  describe "#pack" do
    context ":char" do
      subject { described_class.new(:char) }

      it "should pack a signed character" do
        subject.pack(byte).should == char
      end
    end

    context "[:char, n]" do
      let(:n) { string.length }
      subject { described_class.new([:char, n]) }

      it "should pack multiple signed characters" do
        subject.pack(*bytes).should == string
      end
    end

    context ":string" do
      subject { described_class.new(:string) }

      it "should pack a string" do
        subject.pack(string).should == "#{string}\0"
      end
    end
  end

  describe "#unpack" do
    context ":char" do
      subject { described_class.new(:char) }

      it "should unpack a signed character" do
        subject.unpack(char).should == [byte]
      end
    end

    context "[:char, n]" do
      let(:n) { string.length }
      subject { described_class.new([:char, n]) }

      it "should unpack multiple signed characters" do
        subject.unpack(string).should == bytes
      end
    end

    context ":string" do
      subject { described_class.new(:string) }

      it "should unpack a string" do
        subject.unpack("#{string}\0").should == [string]
      end
    end
  end

  describe "#to_s" do
    it "should return the pack format String" do
      subject.to_s.should == "LZ*"
    end
  end
end
