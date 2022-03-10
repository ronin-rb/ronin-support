# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/binary/template'

describe Binary::Template do
  describe "TYPES" do
    subject { described_class::TYPES }

    it("uint8      => C")  { expect(subject[:uint8]).to       eq('C' ) }
    it("uint16     => S")  { expect(subject[:uint16]).to      eq('S' ) }
    it("uint32     => L")  { expect(subject[:uint32]).to      eq('L' ) }
    it("uint64     => Q")  { expect(subject[:uint64]).to      eq('Q' ) }
    it("int8       => C")  { expect(subject[:int8]).to        eq('c' ) }
    it("int16      => S")  { expect(subject[:int16]).to       eq('s' ) }
    it("int32      => L")  { expect(subject[:int32]).to       eq('l' ) }
    it("int64      => Q")  { expect(subject[:int64]).to       eq('q' ) }
    it("uchar      => Z")  { expect(subject[:uchar]).to      eq('Z' ) }
    it("ushort     => S!") { expect(subject[:ushort]).to     eq('S!') }
    it("uint       => I!") { expect(subject[:uint]).to       eq('I!') }
    it("ulong      => L!") { expect(subject[:ulong]).to      eq('L!') }
    it("ulong_long => Q")  { expect(subject[:ulong_long]).to eq('Q' ) }
    it("char       => Z")  { expect(subject[:char]).to       eq('Z' ) }
    it("short      => s!") { expect(subject[:short]).to      eq('s!') }
    it("int        => i!") { expect(subject[:int]).to        eq('i!') }
    it("long       => l!") { expect(subject[:long]).to       eq('l!') }
    it("long_long  => q")  { expect(subject[:long_long]).to  eq('q' ) }
    it("utf8       => U")  { expect(subject[:utf8]).to       eq('U' ) }
    it("float      => F")  { expect(subject[:float]).to       eq('F' ) }
    it("double     => D")  { expect(subject[:double]).to      eq('D' ) }
    it("float_le   => e")  { expect(subject[:float_le]).to    eq('e' ) }
    it("double_le  => E")  { expect(subject[:double_le]).to   eq('E' ) }
    it("float_be   => g")  { expect(subject[:float_be]).to    eq('g' ) }
    it("double_ge  => G")  { expect(subject[:double_be]).to   eq('G' ) }
    it("ubyte      => C")  { expect(subject[:ubyte]).to       eq('C' ) }
    it("byte       => c")  { expect(subject[:byte]).to        eq('c' ) }
    it("string     => Z*") { expect(subject[:string]).to     eq('Z*') }

    it("uint16_le     => S<") { expect(subject[:uint16_le]).to      eq('S<' ) }
    it("uint32_le     => L<") { expect(subject[:uint32_le]).to      eq('L<' ) }
    it("uint64_le     => Q<") { expect(subject[:uint64_le]).to      eq('Q<' ) }
    it("int16_le      => S<") { expect(subject[:int16_le]).to       eq('s<' ) }
    it("int32_le      => L<") { expect(subject[:int32_le]).to       eq('l<' ) }
    it("int64_le      => Q<") { expect(subject[:int64_le]).to       eq('q<' ) }
    it("uint16_be     => S>") { expect(subject[:uint16_be]).to      eq('S>' ) }
    it("uint32_be     => L>") { expect(subject[:uint32_be]).to      eq('L>' ) }
    it("uint64_be     => Q>") { expect(subject[:uint64_be]).to      eq('Q>' ) }
    it("int16_be      => S>") { expect(subject[:int16_be]).to       eq('s>' ) }
    it("int32_be      => L>") { expect(subject[:int32_be]).to       eq('l>' ) }
    it("int64_be      => Q>") { expect(subject[:int64_be]).to       eq('q>' ) }
    it("ushort_le     => S!<") { expect(subject[:ushort_le]).to     eq('S!<') }
    it("uint_le       => I!<") { expect(subject[:uint_le]).to       eq('I!<') }
    it("ulong_le      => L!<") { expect(subject[:ulong_le]).to      eq('L!<') }
    it("ulong_long_le => L!<") { expect(subject[:ulong_long_le]).to eq('Q<' ) }
    it("short_le      => S!<") { expect(subject[:short_le]).to      eq('s!<') }
    it("int_le        => I!<") { expect(subject[:int_le]).to        eq('i!<') }
    it("long_le       => L!<") { expect(subject[:long_le]).to       eq('l!<') }
    it("long_long_le  => L!<") { expect(subject[:long_long_le]).to  eq('q<' ) }
    it("ushort_be     => S!>") { expect(subject[:ushort_be]).to     eq('S!>') }
    it("uint_be       => I!>") { expect(subject[:uint_be]).to       eq('I!>') }
    it("ulong_be      => L!>") { expect(subject[:ulong_be]).to      eq('L!>') }
    it("ulong_long_be => L!>") { expect(subject[:ulong_long_be]).to eq('Q>' ) }
    it("short_be      => S!>") { expect(subject[:short_be]).to      eq('s!>') }
    it("int_be        => I!>") { expect(subject[:int_be]).to        eq('i!>') }
    it("long_be       => L!>") { expect(subject[:long_be]).to       eq('l!>') }
    it("long_long_be  => L!>") { expect(subject[:long_long_be]).to  eq('q>' ) }
  end

  describe "compile" do
    let(:type) { :uint }
    let(:code) { subject::TYPES[type] }

    subject { described_class }

    it "must translate types to their pack codes" do
      expect(subject.compile([type])).to eq(code)
    end

    it "must support specifying the length of a field" do
      expect(subject.compile([[type, 10]])).to eq("#{code}10")
    end

    it "must allow fields of arbitrary length" do
      expect(subject.compile([[type]])).to eq("#{code}*")
    end

    it "must raise ArgumentError for unknown types" do
      expect {
        subject.compile([:foo])
      }.to raise_error(ArgumentError)
    end

    context "when the :endian is given" do
      let(:endian) { :big  }
      let(:code)   { 'I!>' }

      it "must translate endian types" do
        expect(subject.compile([type], endian: endian)).to eq(code)
      end

      it "must not translate non-endian types" do
        expect(subject.compile([:byte], endian: endian)).to eq('c')
      end
    end
  end

  describe "#initialize" do
    subject { described_class.new [:uint32, :string] }

    it "must store the types" do
      expect(subject.fields).to eq([
        :uint32,
        :string
      ])
    end

    it "must raise ArgumentError for unknown types" do
      expect {
        described_class.new [:foo]
      }.to raise_error(ArgumentError)
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

      it "must pack a signed byte" do
        expect(subject.pack(byte)).to eq(char)
      end
    end

    context "[:byte, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:byte, n]] }

      it "must pack multiple signed characters" do
        expect(subject.pack(*bytes)).to eq(chars)
      end
    end

    context ":char" do
      subject { described_class.new [:char] }

      it "must pack a signed character" do
        expect(subject.pack(char)).to eq(char)
      end
    end

    context "[:char, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:char, n]] }

      it "must pack multiple signed characters" do
        expect(subject.pack(*chars)).to eq(string)
      end

      context "padding" do
        let(:padding) { 10 }
        subject { described_class.new [[:char, n + padding]] }

        it "must pad the string with '\\0' characters" do
          expect(subject.pack(*chars)).to eq((string + ("\0" * padding)))
        end
      end
    end

    context ":uint8" do
      subject { described_class.new [:uint8] }

      it "must pack an unsigned 8bit integer" do
        expect(subject.pack(uint8)).to eq("\xff")
      end
    end

    context ":uint16" do
      subject { described_class.new [:uint16] }

      it "must pack an unsigned 16bit integer" do
        expect(subject.pack(uint16)).to eq("\xff\xff")
      end
    end

    context ":uint32" do
      subject { described_class.new [:uint32] }

      it "must pack an unsigned 32bit integer" do
        expect(subject.pack(uint32)).to eq("\xff\xff\xff\xff")
      end
    end

    context ":uint64" do
      subject { described_class.new [:uint64] }

      it "must pack an unsigned 64bit integer" do
        expect(subject.pack(uint64)).to eq("\xff\xff\xff\xff\xff\xff\xff\xff")
      end
    end

    context ":int8" do
      subject { described_class.new [:int8] }

      it "must pack an signed 8bit integer" do
        expect(subject.pack(int8)).to eq("\xff")
      end
    end

    context ":int16" do
      subject { described_class.new [:int16] }

      it "must pack an unsigned 16bit integer" do
        expect(subject.pack(int16)).to eq("\xff\xff")
      end
    end

    context ":int32" do
      subject { described_class.new [:int32] }

      it "must pack an unsigned 32bit integer" do
        expect(subject.pack(int32)).to eq("\xff\xff\xff\xff")
      end
    end

    context ":int64" do
      subject { described_class.new [:int64] }

      it "must pack an unsigned 64bit integer" do
        expect(subject.pack(int64)).to eq("\xff\xff\xff\xff\xff\xff\xff\xff")
      end
    end

    context ":string" do
      subject { described_class.new [:string] }

      it "must pack a string" do
        expect(subject.pack(string)).to eq("#{string}\0")
      end
    end
  end

  describe "#unpack" do
    context ":byte" do
      subject { described_class.new [:byte] }

      it "must unpack a signed byte" do
        expect(subject.unpack(char)).to eq([byte])
      end
    end

    context "[:byte, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:byte, n]] }

      it "must pack multiple signed characters" do
        expect(subject.unpack(chars)).to eq(bytes)
      end
    end

    context ":char" do
      subject { described_class.new [:char] }

      it "must unpack a signed character" do
        expect(subject.unpack(char)).to eq([char])
      end
    end

    context "[:char, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:char, n]] }

      it "must unpack multiple signed characters" do
        expect(subject.unpack(string)).to eq([chars])
      end

      context "padding" do
        let(:padding) { 10 }
        subject { described_class.new [[:char, n + padding]] }

        it "must strip '\\0' padding characters" do
          expect(subject.unpack(string + ("\0" * padding))).to eq([chars])
        end
      end
    end

    context ":uint8" do
      subject { described_class.new [:uint8] }

      it "must unpack an unsigned 8bit integer" do
        expect(subject.unpack("\xff")).to eq([uint8])
      end
    end

    context "[:uint8]" do
      subject { described_class.new [[:uint8]] }

      let(:n) { 4 }

      it "must unpack an arbitrary number of 8bit integers" do
        expect(subject.unpack("\xff" * n)).to eq([uint8] * n)
      end
    end

    context ":uint16" do
      subject { described_class.new [:uint16] }

      it "must unpack an unsigned 16bit integer" do
        expect(subject.unpack("\xff\xff")).to eq([uint16])
      end
    end

    context ":uint32" do
      subject { described_class.new [:uint32] }

      it "must unpack an unsigned 32bit integer" do
        expect(subject.unpack("\xff\xff\xff\xff")).to eq([uint32])
      end
    end

    context ":uint64" do
      subject { described_class.new [:uint64] }

      it "must unpack an unsigned 64bit integer" do
        expect(subject.unpack("\xff\xff\xff\xff\xff\xff\xff\xff")).to eq([uint64])
      end
    end

    context ":int8" do
      subject { described_class.new [:int8] }

      it "must unpack an signed 8bit integer" do
        expect(subject.unpack("\xff")).to eq([int8])
      end
    end

    context ":int16" do
      subject { described_class.new [:int16] }

      it "must unpack an unsigned 16bit integer" do
        expect(subject.unpack("\xff\xff")).to eq([int16])
      end
    end

    context ":int32" do
      subject { described_class.new [:int32] }

      it "must unpack an unsigned 32bit integer" do
        expect(subject.unpack("\xff\xff\xff\xff")).to eq([int32])
      end
    end

    context ":int64" do
      subject { described_class.new [:int64] }

      it "must unpack an unsigned 64bit integer" do
        expect(subject.unpack("\xff\xff\xff\xff\xff\xff\xff\xff")).to eq([int64])
      end
    end

    context ":string" do
      subject { described_class.new [:string] }

      it "must unpack a string" do
        expect(subject.unpack("#{string}\0")).to eq([string])
      end
    end
  end

  describe "#to_s" do
    subject { described_class.new [:uint32, :string] }

    it "must return the pack format String" do
      expect(subject.to_s).to eq("LZ*")
    end
  end

  describe "#inspect" do
    let(:template) { described_class.new [:uint32, :string] }

    subject { template.inspect }

    it "must inspect the class" do
      expect(subject).to include(described_class.name)
    end

    it "must inspect the template" do
      expect(subject).to include(template.fields.inspect)
    end
  end
end
