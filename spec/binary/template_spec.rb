# encoding: US-ASCII

require 'spec_helper'
require 'ronin/binary/template'

describe Binary::Template do
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
    it("uchar      => Z")  { subject[:uchar].should      == 'Z' }
    it("ushort     => S!") { subject[:ushort].should     == 'S!'}
    it("uint       => I!") { subject[:uint].should       == 'I!'}
    it("ulong      => L!") { subject[:ulong].should      == 'L!'}
    it("ulong_long => Q")  { subject[:ulong_long].should == 'Q' }
    it("char       => Z")  { subject[:char].should       == 'Z' }
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
    it("ubyte      => C") { subject[:ubyte].should       == 'C' }
    it("byte       => c") { subject[:byte].should        == 'c' }
    it("string     => Z*") { subject[:string].should     == 'Z*'}

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

  describe "compile" do
    let(:type) { :uint }
    let(:code) { subject::TYPES[type] }

    subject { described_class }

    it "should translate types to their pack codes" do
      subject.compile([type]).should == code
    end

    it "should support specifying the length of a field" do
      subject.compile([[type, 10]]).should == "#{code}10"
    end

    it "should allow fields of arbitrary length" do
      subject.compile([[type]]).should == "#{code}*"
    end

    it "should raise ArgumentError for unknown types" do
      lambda {
        subject.compile([:foo])
      }.should raise_error(ArgumentError)
    end

    context "when the :endian is given" do
      let(:endian) { :big  }
      let(:code)   { 'I!>' }

      it "should translate endian types" do
        subject.compile([type], endian: endian).should == code
      end

      it "should not translate non-endian types" do
        subject.compile([:byte], endian: endian).should == 'c'
      end
    end
  end

  describe "#initialize" do
    subject { described_class.new [:uint32, :string] }

    it "should store the types" do
      subject.fields.should == [
        :uint32,
        :string
      ]
    end

    it "should raise ArgumentError for unknown types" do
      lambda {
        described_class.new [:foo]
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
  let(:chars) { bytes.map(&:chr).join }
  let(:string) { chars }

  let(:uint8)  { 0xff }
  let(:uint16) { 0xffff }
  let(:uint32) { 0xffffffff }
  let(:uint64) { 0xffffffffffffffff }

  let(:int8)  { -1 }
  let(:int16) { -1 }
  let(:int32) { -1 }
  let(:int32) { -1 }
  let(:int64) { -1 }

  describe "#pack" do
    context ":byte" do
      subject { described_class.new [:byte] }

      it "should pack a signed byte" do
        subject.pack(byte).should == char
      end
    end

    context "[:byte, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:byte, n]] }

      it "should pack multiple signed characters" do
        subject.pack(*bytes).should == chars
      end
    end

    context ":char" do
      subject { described_class.new [:char] }

      it "should pack a signed character" do
        subject.pack(char).should == char
      end
    end

    context "[:char, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:char, n]] }

      it "should pack multiple signed characters" do
        subject.pack(*chars).should == string
      end

      context "padding" do
        let(:padding) { 10 }
        subject { described_class.new [[:char, n + padding]] }

        it "should pad the string with '\\0' characters" do
          subject.pack(*chars).should == (string + ("\0" * padding))
        end
      end
    end

    context ":uint8" do
      subject { described_class.new [:uint8] }

      it "should pack an unsigned 8bit integer" do
        subject.pack(uint8).should == "\xff"
      end
    end

    context ":uint16" do
      subject { described_class.new [:uint16] }

      it "should pack an unsigned 16bit integer" do
        subject.pack(uint16).should == "\xff\xff"
      end
    end

    context ":uint32" do
      subject { described_class.new [:uint32] }

      it "should pack an unsigned 32bit integer" do
        subject.pack(uint32).should == "\xff\xff\xff\xff"
      end
    end

    context ":uint64" do
      subject { described_class.new [:uint64] }

      it "should pack an unsigned 64bit integer" do
        subject.pack(uint64).should == "\xff\xff\xff\xff\xff\xff\xff\xff"
      end
    end

    context ":int8" do
      subject { described_class.new [:int8] }

      it "should pack an signed 8bit integer" do
        subject.pack(int8).should == "\xff"
      end
    end

    context ":int16" do
      subject { described_class.new [:int16] }

      it "should pack an unsigned 16bit integer" do
        subject.pack(int16).should == "\xff\xff"
      end
    end

    context ":int32" do
      subject { described_class.new [:int32] }

      it "should pack an unsigned 32bit integer" do
        subject.pack(int32).should == "\xff\xff\xff\xff"
      end
    end

    context ":int64" do
      subject { described_class.new [:int64] }

      it "should pack an unsigned 64bit integer" do
        subject.pack(int64).should == "\xff\xff\xff\xff\xff\xff\xff\xff"
      end
    end

    context ":string" do
      subject { described_class.new [:string] }

      it "should pack a string" do
        subject.pack(string).should == "#{string}\0"
      end
    end
  end

  describe "#unpack" do
    context ":byte" do
      subject { described_class.new [:byte] }

      it "should unpack a signed byte" do
        subject.unpack(char).should == [byte]
      end
    end

    context "[:byte, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:byte, n]] }

      it "should pack multiple signed characters" do
        subject.unpack(chars).should == bytes
      end
    end

    context ":char" do
      subject { described_class.new [:char] }

      it "should unpack a signed character" do
        subject.unpack(char).should == [char]
      end
    end

    context "[:char, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:char, n]] }

      it "should unpack multiple signed characters" do
        subject.unpack(string).should == [chars]
      end

      context "padding" do
        let(:padding) { 10 }
        subject { described_class.new [[:char, n + padding]] }

        it "should strip '\\0' padding characters" do
          subject.unpack(string + ("\0" * padding)).should == [chars]
        end
      end
    end

    context ":uint8" do
      subject { described_class.new [:uint8] }

      it "should unpack an unsigned 8bit integer" do
        subject.unpack("\xff").should == [uint8]
      end
    end

    context "[:uint8]" do
      subject { described_class.new [[:uint8]] }

      let(:n) { 4 }

      it "should unpack an arbitrary number of 8bit integers" do
        subject.unpack("\xff" * n).should == [uint8] * n
      end
    end

    context ":uint16" do
      subject { described_class.new [:uint16] }

      it "should unpack an unsigned 16bit integer" do
        subject.unpack("\xff\xff").should == [uint16]
      end
    end

    context ":uint32" do
      subject { described_class.new [:uint32] }

      it "should unpack an unsigned 32bit integer" do
        subject.unpack("\xff\xff\xff\xff").should == [uint32]
      end
    end

    context ":uint64" do
      subject { described_class.new [:uint64] }

      it "should unpack an unsigned 64bit integer" do
        subject.unpack("\xff\xff\xff\xff\xff\xff\xff\xff").should == [uint64]
      end
    end

    context ":int8" do
      subject { described_class.new [:int8] }

      it "should unpack an signed 8bit integer" do
        subject.unpack("\xff").should == [int8]
      end
    end

    context ":int16" do
      subject { described_class.new [:int16] }

      it "should unpack an unsigned 16bit integer" do
        subject.unpack("\xff\xff").should == [int16]
      end
    end

    context ":int32" do
      subject { described_class.new [:int32] }

      it "should unpack an unsigned 32bit integer" do
        subject.unpack("\xff\xff\xff\xff").should == [int32]
      end
    end

    context ":int64" do
      subject { described_class.new [:int64] }

      it "should unpack an unsigned 64bit integer" do
        subject.unpack("\xff\xff\xff\xff\xff\xff\xff\xff").should == [int64]
      end
    end

    context ":string" do
      subject { described_class.new [:string] }

      it "should unpack a string" do
        subject.unpack("#{string}\0").should == [string]
      end
    end
  end

  describe "#to_s" do
    subject { described_class.new [:uint32, :string] }

    it "should return the pack format String" do
      subject.to_s.should == "LZ*"
    end
  end

  describe "#inspect" do
    let(:template) { described_class.new [:uint32, :string] }

    subject { template.inspect }

    it "should inspect the class" do
      subject.should include(described_class.name)
    end

    it "should inspect the template" do
      subject.should include(template.fields.inspect)
    end
  end
end
