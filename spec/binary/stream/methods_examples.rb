require 'rspec'
require 'ronin/support/binary/types'
require 'ronin/support/binary/memory'

shared_examples_for "Ronin::Support::Binary::Stream::Methods examples" do
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

  describe "#read_array_of" do
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

  describe "#read_into" do
    let(:memory) { Ronin::Support::Binary::Memory.new(10) }
    let(:data)   { "0123456789"   }
    let(:buffer) { "#{data}AAAAA" }

    it "must the size of the memory object into the memory object" do
      subject.read_into(memory)

      expect(memory.string).to eq(data)
    end
  end

  describe "#read_buffer" do
    let(:data)   { "ABCDEFG" }
    let(:buffer) { "#{data}AAAAAA" }
    let(:count)  { data.bytesize }

    it "musst read the given number of bytes and return a new Buffer" do
      new_buffer = subject.read_buffer(count)

      expect(new_buffer).to be_kind_of(Ronin::Support::Binary::Buffer)
      expect(new_buffer.string).to eq(data)
      expect(new_buffer.size).to eq(count)
    end
  end

  describe "#read_array" do
    let(:type) { :int16_le }
    let(:length) { 3 }
    let(:array) do
      Ronin::Support::Binary::Array.new(type,length).tap do |array|
        array[0] = 1
        array[1] = 2
        array[2] = 3
      end
    end

    let(:data)   { array.pack }
    let(:buffer) { "#{data}AAAAAA" }

    it "musst read the necessary number of bytes and return a new Binary::Array" do
      new_array = subject.read_array(type,length)

      expect(new_array).to be_kind_of(Ronin::Support::Binary::Array)
      expect(new_array.string).to eq(data)
      expect(new_array.length).to eq(length)
    end
  end

  module TestBinaryStreamMethods
    class TestStruct < Ronin::Support::Binary::Struct

      member :c, :char
      member :i, :int32_le

    end

    class TestUnion < Ronin::Support::Binary::Union

      member :c, :char
      member :i, :int32_le

    end
  end
  let(:struct_class) { TestBinaryStreamMethods::TestStruct }
  let(:union_class)  { TestBinaryStreamMethods::TestUnion  }

  describe "#read_struct" do
    let(:struct) { struct_class.new(c: 'A', i: -1) }
    let(:data)   { struct.pack }
    let(:buffer) { "#{data}AAAAAA" }

    it "musst read the necessary number of bytes and return a new struct" do
      new_array = subject.read_struct(struct_class)

      expect(new_array).to be_kind_of(struct_class)
      expect(new_array.string).to eq(data)
    end
  end

  describe "#read_union" do
    let(:union) { union_class.new(c: 'A') }
    let(:data)   { union.pack }
    let(:buffer) { "#{data}AAAAAA" }

    it "musst read the necessary number of bytes and return a new union" do
      new_array = subject.read_union(union_class)

      expect(new_array).to be_kind_of(union_class)
      expect(new_array.string).to eq(data)
    end
  end

  describe "#write_value" do
    let(:type_name) { :int32_le }
    let(:type)      { Ronin::Support::Binary::Types[type_name] }
    let(:value)     { -1 }

    let(:packed_value) { type.pack(value) }

    it "must write the given value of the given type to the stream" do
      expect(subject).to receive(:write).with(packed_value)

      subject.write_value(type_name,value)
    end

    it "must return self" do
      expect(subject.write_value(type_name,value)).to be(subject)
    end
  end

  describe "#write_string" do
    let(:string) { "ABC" }

    it "must write the string and a null-byte to the stream" do
      expect(subject).to receive(:write).with("#{string}\0")

      subject.write_string(string)
    end

    context "when the given string already ends in a null-byte" do
      let(:string) { "ABC\0" }

      it "must not add an additional null-byte" do
        expect(subject).to receive(:write).with(string)

        subject.write_string(string)
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
      expect(subject).to receive(:write).with(packed_array)

      subject.write_array_of(type_name,array)
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
