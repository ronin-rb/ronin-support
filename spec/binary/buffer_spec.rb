require 'spec_helper'
require 'ronin/support/binary/buffer'
require 'ronin/support/binary/struct'
require 'ronin/support/binary/union'

describe Ronin::Support::Binary::Buffer do
  let(:length) { 10 }

  describe "#initialize" do
    subject { described_class.new(length) }

    it "must default #endian to nil" do
      expect(subject.endian).to be(nil)
    end

    context "when the endian: keyword argument is given" do
      let(:endian) { :little }

      subject { described_class.new(length, endian: endian) }

      it "must set #endian" do
        expect(subject.endian).to be(endian)
      end

      it "must set #type_system using Ronin::Support::Binary::Types.platform(endian: ...)" do
        expect(subject.type_system).to be(
          Ronin::Support::Binary::Types.platform(endian: endian)
        )
      end
    end

    it "must default #arch to nil" do
      expect(subject.arch).to be(nil)
    end

    context "when the arch: keyword argument is given" do
      let(:arch) { :x86 }

      subject { described_class.new(length, arch: arch) }

      it "must set #arch" do
        expect(subject.arch).to be(arch)
      end

      it "must set #type_system using Ronin::Support::Binary::Types.platform(arch: ...)" do
        expect(subject.type_system).to be(
          Ronin::Support::Binary::Types.platform(arch: arch)
        )
      end
    end

    it "must default #type_system to Ronin::Support::Binary::Types" do
      expect(subject.type_system).to be(Ronin::Support::Binary::Types)
    end

    context "when an Integer argument is given instead of a String argument" do
      subject { described_class.new(length) }

      it "must set #length" do
        expect(subject.length).to eq(length)
      end

      it "must initialize #string with Encoding::ASCII_8BIT" do
        expect(subject.string.encoding).to be(Encoding::ASCII_8BIT)
      end

      it "must initialize #string to the given length" do
        expect(subject.string.bytesize).to eq(length)
      end

      it "must initialize #string to all null-bytes" do
        expect(subject.string).to eq("\0" * length)
      end
    end

    context "when a String argument is given instead of a length argument" do
      let(:string) { "A" * length }

      subject { described_class.new(string) }

      it "must set #string to the given string value" do
        expect(subject.string).to be(string)
      end

      it "must set #length to the string's byte size" do
        expect(subject.length).to eq(string.bytesize)
      end
    end

    context "when not given a length or a string argument" do
      let(:arg) { :foo }

      it do
        expect {
          described_class.new(arg)
        }.to raise_error(ArgumentError,"first argument must be either a size (Integer) or a buffer (String): #{arg.inspect}")
      end
    end
  end

  subject { described_class.new(length) }

  describe "#[]=" do
    let(:index) { 1 }

    context "when given a character value" do
      let(:value) { 0x41.chr }

      before { subject[index] = value }

      it "must write the character value to the given index within #string" do
        expect(subject.string[index]).to eq(value)
      end
    end

    context "when given an byte value" do
      let(:value) { 0x41 }

      before { subject[index] = value }

      it "must convert the byte into a character before writing" do
        expect(subject.string[index]).to eq(value.chr)
      end
    end

    context "when given a Range index" do
      let(:range) { (1..3) }

      before { subject[range] = values }

      context "and given an Array of bytes" do
        let(:values) { [0x41, 0x42, 0x43]    }
        let(:slice)  { values.map(&:chr).join }

        it "must convert the byte into a character before writing" do
          expect(subject.string[range]).to eq(slice)
        end
      end

      context "and given an Array of chars" do
        let(:values)  { %w[A B C]  }
        let(:slice)  { values.join }

        it "must combine the Array of chars into a String before writing" do
          expect(subject.string[range]).to eq(slice)
        end
      end
    end

    context "when given an index and a length" do
      let(:index)  { 1 }
      let(:length) { 3 }

      before { subject[index,length] = values }

      context "and given an Array of bytes" do
        let(:values) { [0x41, 0x42, 0x43]     }
        let(:slice)  { values.map(&:chr).join }

        it "must convert the byte into a character before writing" do
          expect(subject.string[index,length]).to eq(slice)
        end
      end

      context "and given an Array of chars" do
        let(:values) { %w[A B C]  }
        let(:slice)  { values.join }

        it "must combine the Array of chars into a String before writing" do
          expect(subject.string[index,length]).to eq(slice)
        end
      end
    end
  end

  describe "#get" do
    let(:type_name) { :int32_le }
    let(:type)      { Ronin::Support::Binary::Types[type_name] }
    let(:offset)    { 1  }
    let(:value)     { -1 }

    context "when the offset + type size is within bounds" do
      before do
        subject[1] = 0xff
        subject[2] = 0xff
        subject[3] = 0xff
        subject[4] = 0xff
      end

      it "must read and unpack the value at the given offset with the given type" do
        expect(subject.get(type_name,offset)).to eq(value)
      end
    end

    context "when the offset is less than 0" do
      let(:offset) { -1 }

      it do
        expect {
          subject.get(type_name,offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset + type size exceeds the buffer's size" do
      let(:offset) { subject.size - type.size + 1 }

      it do
        expect {
          subject.get(type_name,offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset is equal to the size of the buffer" do
      let(:offset) { subject.size }

      it do
        expect {
          subject.get(type_name,offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset is greater than the size of the buffer" do
      let(:offset) { subject.size + 1 }

      it do
        expect {
          subject.get(type_name,offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - type.size}")
      end
    end
  end

  describe "#put" do
    let(:type_name) { :int32_le }
    let(:type)      { Ronin::Support::Binary::Types[type_name] }
    let(:offset)    { 1 }
    let(:value)     { -1 }

    let(:packed_value) { type.pack(value) }

    context "when the offset + type size is within bounds" do
      it "must write the given value at the given offset with the given type" do
        subject.put(type_name,offset,value)

        expect(subject.string[offset,type.size]).to eq(packed_value)
      end

      it "must return self" do
        expect(subject.put(type_name,offset,value)).to be(subject)
      end
    end

    context "when the offset is less than 0" do
      let(:offset) { -1 }

      it do
        expect {
          subject.put(type_name,offset,value)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset + type size exceeds the buffer's size" do
      let(:offset) { subject.size - type.size + 1 }

      it do
        expect {
          subject.put(type_name,offset,value)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset is equal to the size of the buffer" do
      let(:offset) { subject.size }

      it do
        expect {
          subject.put(type_name,offset,value)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset is greater than the size of the buffer" do
      let(:offset) { subject.size + 1 }

      it do
        expect {
          subject.put(type_name,offset,value)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - type.size}")
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
    describe "#get_#{type_name}" do
      let(:type_name) { type_name }
      let(:offset)    { double("offset") }

      it "must call #get with :#{type_name} and the given offset" do
        expect(subject).to receive(:get).with(type_name,offset)

        subject.send("get_#{type_name}",offset)
      end
    end

    describe "#put_#{type_name}" do
      let(:type_name) { type_name }
      let(:offset)    { double("offset") }
      let(:value)     { double("#{type_name} value}") }

      it "must call #put with :#{type_name}, the given offset, and value" do
        expect(subject).to receive(:put).with(type_name,offset,value)

        subject.send("put_#{type_name}",offset,value)
      end
    end
  end

  describe "#get_array_of" do
    let(:type_name)  { :int32_le }
    let(:type)       { Ronin::Support::Binary::Types[type_name] }
    let(:array_type) { type[array.length]  }
    let(:array)      { [-1, -2, -3] }
    let(:offset)     { 1 }
    let(:count)      { array.length }

    let(:length)     { 1 + (type.size*count) }

    context "when the offset + array type size is within bounds" do
      before do
        subject.put(type_name, 1,               array[0])
        subject.put(type_name, 1+type.size,     array[1])
        subject.put(type_name, 1+(type.size*2), array[2])
      end

      it "must read an Array of types at the given offset of the given count" do
        expect(subject.get_array_of(type_name,offset,count)).to eq(array)
      end
    end

    context "when the offset is less than 0" do
      let(:offset) { -1 }

      it do
        expect {
          subject.get_array_of(type_name,offset,count)
        }.to raise_error(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset + array type size exceeds the buffer's size" do
      let(:offset) { subject.size - type.size + 1 }

      it do
        expect {
          subject.get_array_of(type_name,offset,count)
        }.to raise_error(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset is equal to the size of the buffer" do
      let(:offset) { subject.size }

      it do
        expect {
          subject.get_array_of(type_name,offset,count)
        }.to raise_error(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset is greater than the size of the buffer" do
      let(:offset) { subject.size + 1 }

      it do
        expect {
          subject.get_array_of(type_name,offset,count)
        }.to raise_error(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{subject.size - type.size}")
      end
    end
  end

  describe "#put_array_of" do
    let(:type_name)  { :int32_le }
    let(:type)       { Ronin::Support::Binary::Types[type_name] }
    let(:array_type) { type[array.length]  }
    let(:array)      { [-1, -2, -3] }
    let(:array_type) { type[array.length] }
    let(:offset)     { 1 }
    let(:count)      { array.length }
    let(:length)     { 1 + (type.size*count) }

    let(:packed_array) { array_type.pack(array) }

    context "when the offset + array type size is within bounds" do
      it "must read an Array of types at the given offset of the given count" do
        subject.put_array_of(type_name,offset,array)

        expect(subject.string[offset,array_type.size]).to eq(packed_array)
      end

      it "must return self" do
        expect(subject.put_array_of(type_name,offset,array)).to be(subject)
      end
    end

    context "when the offset is less than 0" do
      let(:offset) { -1 }

      it do
        expect {
          subject.put_array_of(type_name,offset,array)
        }.to raise_error(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset + array type size exceeds the buffer's size" do
      let(:offset) { subject.size - type.size + 1 }

      it do
        expect {
          subject.put_array_of(type_name,offset,array)
        }.to raise_error(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset is equal to the size of the buffer" do
      let(:offset) { subject.size }

      it do
        expect {
          subject.put_array_of(type_name,offset,array)
        }.to raise_error(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{subject.size - type.size}")
      end
    end

    context "when the offset is greater than the size of the buffer" do
      let(:offset) { subject.size + 1 }

      it do
        expect {
          subject.put_array_of(type_name,offset,array)
        }.to raise_error(IndexError,"offset #{offset} or size #{array_type.size} is out of bounds: 0...#{subject.size - type.size}")
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
    describe "#get_#{type_name}" do
      let(:type_name) { type_name }
      let(:offset)    { double("offset") }
      let(:count)     { double('count')  }

      it "must call #get_array_of with :#{type_name} and the given offset and count" do
        expect(subject).to receive(:get_array_of).with(type_name,offset,count)

        subject.send("get_array_of_#{type_name}",offset,count)
      end
    end

    describe "#put_#{type_name}" do
      let(:type_name) { type_name }
      let(:offset)    { double("offset") }
      let(:array)     { double("#{type_name} array") }

      it "must call #put_array_of with :#{type_name}, the given offset, and value" do
        expect(subject).to receive(:put_array_of).with(type_name,offset,array)

        subject.send("put_array_of_#{type_name}",offset,array)
      end
    end
  end

  describe "#get_string" do
    let(:offset) { 1 }
    let(:string) { "abc" }
    let(:bytes)  { string.bytes }

    context "when the offset and length are within bounds" do
      before do
        subject[offset]   = bytes[0]
        subject[offset+1] = bytes[1]
        subject[offset+2] = bytes[2]
        subject[offset+3] = 0x00
      end

      it "must read the string at the given offset, until a null-byte is read" do
        expect(subject.get_string(offset)).to eq(string)
      end

      context "when a maximum length is given" do
        let(:max_length) { 2 }

        it "must only read that many bytes" do
          expect(subject.get_string(offset,max_length)).to eq(
            string[0,max_length]
          )
        end
      end
    end

    context "when the offset is less than 0" do
      let(:offset) { -1 }

      it do
        expect {
          subject.get_string(offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - 1}")
      end
    end

    context "when the offset + the max length exceeds the buffer's size" do
      let(:max_length) { 2 }
      let(:offset) { subject.size - max_length + 1 }

      it do
        expect {
          subject.get_string(offset,max_length)
        }.to raise_error(IndexError,"offset #{offset} or length #{max_length} is out of bounds: 0...#{subject.size - 1}")
      end
    end

    context "when the offset is equal to the size of the buffer" do
      let(:offset) { subject.size }

      it do
        expect {
          subject.get_string(offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - 1}")
      end
    end

    context "when the offset is greater than the size of the buffer" do
      let(:offset) { subject.size + 1 }

      it do
        expect {
          subject.get_string(offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - 1}")
      end
    end
  end

  describe "#put_string" do
    let(:offset) { 1 }
    let(:string) { "abc" }

    context "when the offset + string length are within bounds" do
      before do
        subject[0] = 0x41
        subject[1] = 0x41
        subject[2] = 0x41
        subject[3] = 0x41
        subject[4] = 0x41
        subject[5] = 0x41

        subject.put_string(offset,string)
      end

      it "must write the string at the given offset" do
        expect(subject.string[offset,string.bytesize]).to eq(string)
      end

      it "must append a null-byte after the last byte of the string" do
        expect(subject.string[offset+string.bytesize]).to eq("\0")
      end
    end

    context "when the offset is less than 0" do
      let(:offset) { -1 }

      it do
        expect {
          subject.put_string(offset,string)
        }.to raise_error(IndexError,"offset #{offset} or C string size #{string.bytesize+1} is out of bounds: 0...#{subject.size - 1}")
      end
    end

    context "when the offset + the string length exceeds the buffer's size" do
      let(:offset) { subject.size - string.bytesize + 1 }

      it do
        expect {
          subject.put_string(offset,string)
        }.to raise_error(IndexError,"offset #{offset} or C string size #{string.bytesize+1} is out of bounds: 0...#{subject.size - 1}")
      end
    end

    context "when the offset is equal to the size of the buffer" do
      let(:offset) { subject.size }

      it do
        expect {
          subject.put_string(offset,string)
        }.to raise_error(IndexError,"offset #{offset} or C string size #{string.bytesize+1} is out of bounds: 0...#{subject.size - 1}")
      end
    end

    context "when the offset is greater than the size of the buffer" do
      let(:offset) { subject.size + 1 }

      it do
        expect {
          subject.put_string(offset,string)
        }.to raise_error(IndexError,"offset #{offset} or C string size #{string.bytesize+1} is out of bounds: 0...#{subject.size - 1}")
      end
    end
  end

  module TestBinaryBuffer
    class TestStruct < Ronin::Support::Binary::Struct

      member :c, :char
      member :i, :int32_le

    end
  end
  let(:struct_class) { TestBinaryBuffer::TestStruct }

  describe "#get_object" do
    before do
      subject[1] = 0x41 # c
      subject[2] = 0x00 # padding
      subject[3] = 0x00 # padding
      subject[4] = 0x00 # padding
      subject[5] = 0xff # i
      subject[6] = 0xff
      subject[7] = 0xff
      subject[8] = 0xff
    end

    let(:offset)     { 1   }
    let(:char_value) { 'A' }
    let(:int_value)  { -1  }

    context "when the offset + type size is within bounds" do
      it "must return an instance of the Binary::Struct class" do
        expect(subject.get_object(struct_class,offset)).to be_kind_of(struct_class)
      end

      it "must initialize the struct class using a byteslice at the given offset and the struct class'es size" do
        struct = subject.get_object(struct_class,offset)

        expect(struct.string).to be_kind_of(Ronin::Support::Binary::ByteSlice)
        expect(struct.string.offset).to eq(offset)
        expect(struct.string.length).to eq(struct_class.size)
      end

      it "must read values starting at the given offset" do
        struct = subject.get_object(struct_class,offset)

        expect(struct.c).to eq(char_value)
        expect(struct.i).to eq(int_value)
      end
    end

    context "when the offset is less than 0" do
      let(:offset) { -1 }

      it do
        expect {
          subject.get_object(struct_class,offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - struct_class.size}")
      end
    end

    context "when the offset + type size exceeds the buffer's size" do
      let(:offset) { subject.size - struct_class.size + 1 }

      it do
        expect {
          subject.get_object(struct_class,offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - struct_class.size}")
      end
    end

    context "when the offset is equal to the size of the buffer" do
      let(:offset) { subject.size }

      it do
        expect {
          subject.get_object(struct_class,offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - struct_class.size}")
      end
    end

    context "when the offset is greater than the size of the buffer" do
      let(:offset) { subject.size + 1 }

      it do
        expect {
          subject.get_object(struct_class,offset)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - struct_class.size}")
      end
    end

    context "but a non Binary::Struct class is given" do
      let(:type) { Object.new }

      it do
        expect {
          subject.get_object(type,offset)
        }.to raise_error(ArgumentError,"type must be a #{Ronin::Support::Binary::Struct} or #{Ronin::Support::Binary::Union} class: #{type.inspect}")
      end
    end
  end

  describe "#put_object" do
    let(:offset)     { 1   }
    let(:char_value) { 'A' }
    let(:int_value)  { -1  }

    let(:object)        { struct_class.new(c: char_value, i: int_value) }
    let(:packed_object) { object.pack }
    let(:object_size)   { packed_object.bytesize }


    context "when the offset + object size is within bounds" do
      it "must write the packed object at the given offset" do
        subject.put_object(offset,object)

        expect(subject.string[offset,object_size]).to eq(packed_object)
      end

      it "must return self" do
        expect(subject.put_object(offset,object)).to be(subject)
      end
    end

    context "when the offset is less than 0" do
      let(:offset) { -1 }

      it do
        expect {
          subject.put_object(offset,object)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - object_size}")
      end
    end

    context "when the offset + object size exceeds the buffer's size" do
      let(:offset) { subject.size - object_size + 1 }

      it do
        expect {
          subject.put_object(offset,object)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - object_size}")
      end
    end

    context "when the offset is equal to the size of the buffer" do
      let(:offset) { subject.size }

      it do
        expect {
          subject.put_object(offset,object)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - object_size}")
      end
    end

    context "when the offset is greater than the size of the buffer" do
      let(:offset) { subject.size + 1 }

      it do
        expect {
          subject.put_object(offset,object)
        }.to raise_error(IndexError,"offset #{offset} is out of bounds: 0...#{subject.size - object_size}")
      end
    end
  end

  describe "#to_s" do
    it "must return #string" do
      expect(subject.to_s).to be(subject.string)
    end
  end

  describe "#to_str" do
    it "must return #string" do
      expect(subject.to_str).to be(subject.string)
    end
  end
end
