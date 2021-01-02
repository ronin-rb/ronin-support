# encoding: US-ASCII

require 'spec_helper'
require 'ronin/binary/template'

describe Binary::Template do
  describe "TYPES" do
    subject { described_class::TYPES }

    it("uint8      => C")  { expect(subject[:uint8]).to       be == 'C' }
    it("uint16     => S")  { expect(subject[:uint16]).to      be == 'S' }
    it("uint32     => L")  { expect(subject[:uint32]).to      be == 'L' }
    it("uint64     => Q")  { expect(subject[:uint64]).to      be == 'Q' }
    it("int8       => C")  { expect(subject[:int8]).to        be == 'c' }
    it("int16      => S")  { expect(subject[:int16]).to       be == 's' }
    it("int32      => L")  { expect(subject[:int32]).to       be == 'l' }
    it("int64      => Q")  { expect(subject[:int64]).to       be == 'q' }
    if RUBY_VERSION < '1.9.'
    it("uint16_le  => v")  { expect(subject[:uint16_le]).to   be == 'v' }
    it("uint32_le  => V")  { expect(subject[:uint32_le]).to   be == 'V' }
    it("uint16_be  => n")  { expect(subject[:uint16_be]).to   be == 'n' }
    it("uint32_be  => N")  { expect(subject[:uint32_be]).to   be == 'N' }
    end
    it("uchar      => Z")  { expect(subject[:uchar]).to      be == 'Z' }
    it("ushort     => S!") { expect(subject[:ushort]).to     be == 'S!'}
    it("uint       => I!") { expect(subject[:uint]).to       be == 'I!'}
    it("ulong      => L!") { expect(subject[:ulong]).to      be == 'L!'}
    it("ulong_long => Q")  { expect(subject[:ulong_long]).to be == 'Q' }
    it("char       => Z")  { expect(subject[:char]).to       be == 'Z' }
    it("short      => s!") { expect(subject[:short]).to      be == 's!'}
    it("int        => i!") { expect(subject[:int]).to        be == 'i!'}
    it("long       => l!") { expect(subject[:long]).to       be == 'l!'}
    it("long_long  => q")  { expect(subject[:long_long]).to  be == 'q' }
    it("utf8       => U")  { expect(subject[:utf8]).to       be == 'U' }
    it("float      => F")  { expect(subject[:float]).to       be == 'F' }
    it("double     => D")  { expect(subject[:double]).to      be == 'D' }
    it("float_le   => e")  { expect(subject[:float_le]).to    be == 'e' }
    it("double_le  => E")  { expect(subject[:double_le]).to   be == 'E' }
    it("float_be   => g")  { expect(subject[:float_be]).to    be == 'g' }
    it("double_ge  => G")  { expect(subject[:double_be]).to   be == 'G' }
    it("ubyte      => C")  { expect(subject[:ubyte]).to       be == 'C' }
    it("byte       => c")  { expect(subject[:byte]).to        be == 'c' }
    it("string     => Z*") { expect(subject[:string]).to     be == 'Z*'}

    if RUBY_VERSION > '1.9.'
      context "Ruby 1.9" do
        it("uint16_le     => S<") { expect(subject[:uint16_le]).to      be == 'S<' }
        it("uint32_le     => L<") { expect(subject[:uint32_le]).to      be == 'L<' }
        it("uint64_le     => Q<") { expect(subject[:uint64_le]).to      be == 'Q<' }
        it("int16_le      => S<") { expect(subject[:int16_le]).to       be == 's<' }
        it("int32_le      => L<") { expect(subject[:int32_le]).to       be == 'l<' }
        it("int64_le      => Q<") { expect(subject[:int64_le]).to       be == 'q<' }
        it("uint16_be     => S>") { expect(subject[:uint16_be]).to      be == 'S>' }
        it("uint32_be     => L>") { expect(subject[:uint32_be]).to      be == 'L>' }
        it("uint64_be     => Q>") { expect(subject[:uint64_be]).to      be == 'Q>' }
        it("int16_be      => S>") { expect(subject[:int16_be]).to       be == 's>' }
        it("int32_be      => L>") { expect(subject[:int32_be]).to       be == 'l>' }
        it("int64_be      => Q>") { expect(subject[:int64_be]).to       be == 'q>' }
        it("ushort_le     => S!<") { expect(subject[:ushort_le]).to     be == 'S!<'}
        it("uint_le       => I!<") { expect(subject[:uint_le]).to       be == 'I!<'}
        it("ulong_le      => L!<") { expect(subject[:ulong_le]).to      be == 'L!<'}
        it("ulong_long_le => L!<") { expect(subject[:ulong_long_le]).to be == 'Q<' }
        it("short_le      => S!<") { expect(subject[:short_le]).to      be == 's!<'}
        it("int_le        => I!<") { expect(subject[:int_le]).to        be == 'i!<'}
        it("long_le       => L!<") { expect(subject[:long_le]).to       be == 'l!<'}
        it("long_long_le  => L!<") { expect(subject[:long_long_le]).to  be == 'q<' }
        it("ushort_be     => S!>") { expect(subject[:ushort_be]).to     be == 'S!>'}
        it("uint_be       => I!>") { expect(subject[:uint_be]).to       be == 'I!>'}
        it("ulong_be      => L!>") { expect(subject[:ulong_be]).to      be == 'L!>'}
        it("ulong_long_be => L!>") { expect(subject[:ulong_long_be]).to be == 'Q>' }
        it("short_be      => S!>") { expect(subject[:short_be]).to      be == 's!>'}
        it("int_be        => I!>") { expect(subject[:int_be]).to        be == 'i!>'}
        it("long_be       => L!>") { expect(subject[:long_be]).to       be == 'l!>'}
        it("long_long_be  => L!>") { expect(subject[:long_long_be]).to  be == 'q>' }
      end
    end
  end

  describe "translate" do
    subject { described_class }

    context "when given :endian" do
      it "should translate endian-types" do
        expect(subject.translate(:uint, :endian => :little)).to be == :uint_le
      end

      it "should not translate non-endian-types" do
        expect(subject.translate(:string, :endian => :little)).to be == :string
      end

      it "should raise an ArgumentError for unknown endianness" do
        expect {
          subject.translate(:uint, :endian => :foo)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "compile" do
    let(:type) { :uint }
    let(:code) { subject::TYPES[type] }

    subject { described_class }

    it "should translate types to their pack codes" do
      expect(subject.compile([type])).to be == code
    end

    it "should support specifying the length of a field" do
      expect(subject.compile([[type, 10]])).to be == "#{code}10"
    end

    it "should raise ArgumentError for unknown types" do
      expect {
        subject.compile([:foo])
      }.to raise_error(ArgumentError)
    end
  end

  describe "#initialize" do
    subject { described_class.new [:uint32, :string] }

    it "should store the types" do
      expect(subject.fields).to be == [
        :uint32,
        :string
      ]
    end

    it "should raise ArgumentError for unknown types" do
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

      it "should pack a signed byte" do
        expect(subject.pack(byte)).to be == char
      end
    end

    context "[:byte, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:byte, n]] }

      it "should pack multiple signed characters" do
        expect(subject.pack(*bytes)).to be == chars
      end
    end

    context ":char" do
      subject { described_class.new [:char] }

      it "should pack a signed character" do
        expect(subject.pack(char)).to be == char
      end
    end

    context "[:char, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:char, n]] }

      it "should pack multiple signed characters" do
        expect(subject.pack(*chars)).to be == string
      end

      context "padding" do
        let(:padding) { 10 }
        subject { described_class.new [[:char, n + padding]] }

        it "should pad the string with '\\0' characters" do
          expect(subject.pack(*chars)).to be == (string + ("\0" * padding))
        end
      end
    end

    context ":uint8" do
      subject { described_class.new [:uint8] }

      it "should pack an unsigned 8bit integer" do
        expect(subject.pack(uint8)).to be == "\xff"
      end
    end

    context ":uint16" do
      subject { described_class.new [:uint16] }

      it "should pack an unsigned 16bit integer" do
        expect(subject.pack(uint16)).to be == "\xff\xff"
      end
    end

    context ":uint32" do
      subject { described_class.new [:uint32] }

      it "should pack an unsigned 32bit integer" do
        expect(subject.pack(uint32)).to be == "\xff\xff\xff\xff"
      end
    end

    context ":uint64" do
      subject { described_class.new [:uint64] }

      it "should pack an unsigned 64bit integer" do
        expect(subject.pack(uint64)).to be == "\xff\xff\xff\xff\xff\xff\xff\xff"
      end
    end

    context ":int8" do
      subject { described_class.new [:int8] }

      it "should pack an signed 8bit integer" do
        expect(subject.pack(int8)).to be == "\xff"
      end
    end

    context ":int16" do
      subject { described_class.new [:int16] }

      it "should pack an unsigned 16bit integer" do
        expect(subject.pack(int16)).to be == "\xff\xff"
      end
    end

    context ":int32" do
      subject { described_class.new [:int32] }

      it "should pack an unsigned 32bit integer" do
        expect(subject.pack(int32)).to be == "\xff\xff\xff\xff"
      end
    end

    context ":int64" do
      subject { described_class.new [:int64] }

      it "should pack an unsigned 64bit integer" do
        expect(subject.pack(int64)).to be == "\xff\xff\xff\xff\xff\xff\xff\xff"
      end
    end

    context ":string" do
      subject { described_class.new [:string] }

      it "should pack a string" do
        expect(subject.pack(string)).to be == "#{string}\0"
      end
    end
  end

  describe "#unpack" do
    context ":byte" do
      subject { described_class.new [:byte] }

      it "should unpack a signed byte" do
        expect(subject.unpack(char)).to be == [byte]
      end
    end

    context "[:byte, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:byte, n]] }

      it "should pack multiple signed characters" do
        expect(subject.unpack(chars)).to be == bytes
      end
    end

    context ":char" do
      subject { described_class.new [:char] }

      it "should unpack a signed character" do
        expect(subject.unpack(char)).to be == [char]
      end
    end

    context "[:char, n]" do
      let(:n) { string.length }
      subject { described_class.new [[:char, n]] }

      it "should unpack multiple signed characters" do
        expect(subject.unpack(string)).to be == [chars]
      end

      context "padding" do
        let(:padding) { 10 }
        subject { described_class.new [[:char, n + padding]] }

        it "should strip '\\0' padding characters" do
          expect(subject.unpack(string + ("\0" * padding))).to be == [chars]
        end
      end
    end

    context ":uint8" do
      subject { described_class.new [:uint8] }

      it "should unpack an unsigned 8bit integer" do
        expect(subject.unpack("\xff")).to be == [uint8]
      end
    end

    context ":uint16" do
      subject { described_class.new [:uint16] }

      it "should unpack an unsigned 16bit integer" do
        expect(subject.unpack("\xff\xff")).to be == [uint16]
      end
    end

    context ":uint32" do
      subject { described_class.new [:uint32] }

      it "should unpack an unsigned 32bit integer" do
        expect(subject.unpack("\xff\xff\xff\xff")).to be == [uint32]
      end
    end

    context ":uint64" do
      subject { described_class.new [:uint64] }

      it "should unpack an unsigned 64bit integer" do
        expect(subject.unpack("\xff\xff\xff\xff\xff\xff\xff\xff")).to be == [uint64]
      end
    end

    context ":int8" do
      subject { described_class.new [:int8] }

      it "should unpack an signed 8bit integer" do
        expect(subject.unpack("\xff")).to be == [int8]
      end
    end

    context ":int16" do
      subject { described_class.new [:int16] }

      it "should unpack an unsigned 16bit integer" do
        expect(subject.unpack("\xff\xff")).to be == [int16]
      end
    end

    context ":int32" do
      subject { described_class.new [:int32] }

      it "should unpack an unsigned 32bit integer" do
        expect(subject.unpack("\xff\xff\xff\xff")).to be == [int32]
      end
    end

    context ":int64" do
      subject { described_class.new [:int64] }

      it "should unpack an unsigned 64bit integer" do
        expect(subject.unpack("\xff\xff\xff\xff\xff\xff\xff\xff")).to be == [int64]
      end
    end

    context ":string" do
      subject { described_class.new [:string] }

      it "should unpack a string" do
        expect(subject.unpack("#{string}\0")).to be == [string]
      end
    end
  end

  describe "#to_s" do
    subject { described_class.new [:uint32, :string] }

    it "should return the pack format String" do
      expect(subject.to_s).to be == "LZ*"
    end
  end

  describe "#inspect" do
    let(:template) { described_class.new [:uint32, :string] }

    subject { template.inspect }

    it "should inspect the class" do
      expect(subject).to include(described_class.name)
    end

    it "should inspect the template" do
      expect(subject).to include(template.fields.inspect)
    end
  end
end
