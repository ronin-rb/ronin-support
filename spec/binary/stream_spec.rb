require 'spec_helper'
require 'ronin/support/binary/stream'

require 'stringio'

describe Ronin::Support::Binary::Stream do
  let(:buffer) { String.new }
  let(:io)     { StringIO.new(buffer.encode(Encoding::ASCII_8BIT)) }

  subject { described_class.new(io) }

  describe "#initialize" do
    subject { described_class.new(io) }

    it "must set #io" do
      expect(subject.io).to be(io)
    end

    it "must default #endian to nil" do
      expect(subject.endian).to be(nil)
    end

    it "must default #arch to nil" do
      expect(subject.arch).to be(nil)
    end

    it "must default #type_system to Ronin::Support::Binary::Types" do
      expect(subject.type_system).to be(Ronin::Support::Binary::Types)
    end

    context "when the endian: keyword argument is given" do
      let(:endian) { :little }

      subject { described_class.new(io, endian: endian) }

      it "must set #endian" do
        expect(subject.endian).to be(endian)
      end

      it "must set #type_system to the Ronin::Support::Binary::Types:: module" do
        expect(subject.type_system).to be(Ronin::Support::Binary::Types.endian(endian))
      end
    end

    context "when the arch: keyword argument is given" do
      let(:arch) { :x86 }

      subject { described_class.new(io, arch: arch) }

      it "must set #arch" do
        expect(subject.arch).to be(arch)
      end

      it "must set #type_system to the Ronin::Support::Binary::Types::Arch:: module" do
        expect(subject.type_system).to be(Ronin::Support::Binary::Types::Arch[arch])
      end
    end
  end

  describe ".open" do
    let(:path) { __FILE__ }

    subject { described_class.open(path) }

    it "must return a new #{described_class} object" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must set #io to a File object with the given path" do
      expect(subject.io).to be_kind_of(File)
      expect(subject.io.path).to eq(path)
    end

    it "must open the File in binary mode" do
      expect(subject.io.binmode?).to be(true)
    end

    context "when a mode argument is given" do
      require 'tempfile'

      let(:path) { Tempfile.new('ronin-support-binary-stream').path }
      let(:mode) { 'w' }

      subject { described_class.open(path,mode) }

      it "must open the File with the given mode" do
        expect {
          subject.write("test")
        }.to_not raise_error(IOError,"not opened for writing")
      end

      it "must still open the File in binary mode" do
        expect(subject.io.binmode?).to be(true)
      end
    end
  end

  describe "#read" do
    let(:buffer) { "ABCAAAAAA" }
    let(:length) { 3 }

    it "must read the given number of bytes and return a String" do
      expect(subject.read(length)).to eq(buffer[0,length])
    end

    context "when no arguments are given" do
      it "must read until the end of the stream and return a String" do
        expect(subject.read).to eq(buffer)
      end
    end
  end

  describe "#eof?" do
    let(:buffer) { "AAAAAAA" }

    context "when there is still data to be read in the stream" do
      it "must return false" do
        expect(subject.eof?).to be(false)
      end
    end

    context "when the end of the stream has been reached" do
      before { subject.read }

      it "must return true" do
        expect(subject.eof?).to be(true)
      end
    end
  end

  describe "#write" do
    let(:string) { "ABC" }

    it "must write the String to the stream" do
      subject.write(string)

      expect(io.string).to eq(string)
    end
  end

  describe "#read_value" do
    let(:type_name) { :int32_le }
    let(:type)      { Ronin::Support::Binary::Types[type_name] }
    let(:value)     { -1 }
    let(:buffer)    { type.pack(value) }

    it "must read and unpack the value of the given type from the stream" do
      expect(subject.read_value(type_name)).to eq(value)
    end

    context "when EOF is reached" do
      let(:buffer) { "" }

      it "must return nil" do
        subject.read_value(type_name)

        expect(subject.read_value(type_name)).to be(nil)
      end
    end
  end

  describe "#write_value" do
    let(:type_name) { :int32_le }
    let(:type)      { Ronin::Support::Binary::Types[type_name] }
    let(:value)     { -1 }

    let(:packed_value) { type.pack(value) }

    it "must write the given value of the given type to the stream" do
      subject.write_value(type_name,value)

      expect(io.string).to eq(packed_value)
    end

    it "must return self" do
      expect(subject.write_value(type_name,value)).to be(subject)
    end
  end

  [
    :byte,
    :char, :uchar,
    :int8, :int16, :int32, :int64,
    :short, :int, :long, :long_long,
    :uint8, :uint16, :uint32, :uint64,
    :ushort, :uint, :ulong, :ulong_long,
    :float32, :float64,
    :float, :double
  ].each do |type_name|
    describe "#read_#{type_name}" do
      let(:type_name) { type_name }

      it "must call #read_value with :#{type_name}" do
        expect(subject).to receive(:read_value).with(type_name)

        subject.send("read_#{type_name}")
      end
    end

    describe "#write_#{type_name}" do
      let(:type_name) { type_name }
      let(:value)     { double("#{type_name} value}") }

      it "must call #write_value with :#{type_name} and the given value" do
        expect(subject).to receive(:write_value).with(type_name,value)

        subject.send("write_#{type_name}",value)
      end
    end
  end

  describe "#read_string" do
    let(:offset) { 1 }
    let(:string) { "ABC" }
    let(:buffer) { "#{string}\0" }

    it "must read the string at the given offset, until a null-byte is read" do
      expect(subject.read_string).to eq(string)
    end

    context "when the string does not end in a null-byte" do
      let(:string) { "ABCAAAAAA" }
      let(:buffer) { "#{string}" }

      it "must read until EOF is reached" do
        expect(subject.read_string).to eq(string)
      end
    end
  end

  describe "#write_string" do
    let(:string) { "ABC" }

    before { subject.write_string(string) }

    it "must write the string and a null-byte to the stream" do
      expect(io.string).to eq("#{string}\0")
    end

    context "when the given string already ends in a null-byte" do
      let(:string) { "ABC\0" }

      it "must not add an additional null-byte" do
        expect(io.string).to eq(string)
      end
    end
  end

  describe "#get_array_of" do
    let(:type_name)  { :int32_le }
    let(:type)       { Ronin::Support::Binary::Types[type_name] }
    let(:array_type) { type[array.length]  }
    let(:array)      { [-1, -2, -3] }
    let(:count)      { array.length }
    let(:buffer)     { array_type.pack(array) }

    it "must read an Array of types of the given count from the stream" do
      expect(subject.read_array_of(type_name,count)).to eq(array)
    end

    context "when EOF is reached while reading the array" do
      let(:array)   { [-1, -2, -3, -4] }
      let(:missing) { 2 }
      let(:buffer)  { super()[0,type.size * (count - missing)] }

      let(:partial_array)    { array[0,count - missing] }
      let(:nil_padded_array) { partial_array + Array.new(missing) }

      it "must return nil for the remaining missing elements" do
        expect(subject.read_array_of(type_name,count)).to eq(nil_padded_array)
      end
    end
  end

  describe "#write_array_of" do
    let(:type_name)  { :int32_le }
    let(:type)       { Ronin::Support::Binary::Types[type_name] }
    let(:array_type) { type[array.length]  }
    let(:array)      { [-1, -2, -3] }
    let(:array_type) { type[array.length] }
    let(:count)      { array.length }

    let(:packed_array) { array_type.pack(array) }

    it "must read an Array of types at the given offset of the given count" do
      subject.write_array_of(type_name,array)

      expect(io.string).to eq(packed_array)
    end

    it "must return self" do
      expect(subject.write_array_of(type_name,array)).to be(subject)
    end
  end

  [
    :byte,
    :char, :uchar,
    :int8, :int16, :int32, :int64,
    :short, :int, :long, :long_long,
    :uint8, :uint16, :uint32, :uint64,
    :ushort, :uint, :ulong, :ulong_long,
    :float32, :float64,
    :float, :double
  ].each do |type_name|
    describe "#read_#{type_name}" do
      let(:type_name) { type_name }
      let(:count)     { double('count')  }

      it "must call #read_array_of with :#{type_name} and the given count" do
        expect(subject).to receive(:read_array_of).with(type_name,count)

        subject.send("read_array_of_#{type_name}",count)
      end
    end

    describe "#write_#{type_name}" do
      let(:type_name) { type_name }
      let(:array)     { double("#{type_name} array") }

      it "must call #write_array_of  with :#{type_name} and the given value" do
        expect(subject).to receive(:write_array_of).with(type_name,array)

        subject.send("write_array_of_#{type_name}",array)
      end
    end
  end
end
