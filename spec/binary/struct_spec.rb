require 'spec_helper'
require 'ronin/binary/struct'

describe Binary::Struct do
  describe "layout" do
    subject do
      struct = Class.new(described_class)
      struct.class_eval do
        layout :x, :uint,
               :y, :uint
      end

      struct.new
    end

    it "should return the layout" do
      expect(subject.class.layout).to eq([
        :x,
        :y
      ])
    end

    context "when given fields" do
      it "should populate fields" do
        expect(subject.class.fields).to eq({
          x: [:uint, nil],
          y: [:uint, nil]
        })
      end

      it "should define reader methods" do
        expect(subject).to respond_to(:x)
        expect(subject).to respond_to(:y)
      end

      it "should define writer methods" do
        expect(subject).to respond_to(:x=)
        expect(subject).to respond_to(:y=)
      end
    end
  end

  describe "field?" do
    subject do
      struct = Class.new(described_class)
      struct.class_eval { layout :x, :uint }
      struct
    end

    it "should determine if fields exist" do
      expect(subject.field?(:x)).to be(true)
      expect(subject.field?(:foo)).to be(false)
    end
  end

  describe "endian" do
    subject do
      struct = Class.new(described_class)
      struct.class_eval { endian :little }
      struct
    end

    it "should return the endianness of the Struct" do
      expect(subject.endian).to eq(:little)
    end

    context "when given an argument" do
      it "should set the endianness" do
        subject.endian :big

        expect(subject.endian).to eq(:big)
      end
    end
  end

  describe "typedefs" do
  end

  describe "typedef" do
    subject do
      struct = Class.new(described_class)
      struct.class_eval do
        typedef :uint32_t, :test_t
      end

      struct
    end

    it "should register a new type in typedefs" do
      expect(subject.typedefs).to have_key(:test_t)
    end

    it "should resolve the existing type" do
      expect(subject.typedefs[:test_t]).to eq(:uint32)
    end
  end

  describe "#initialize" do
    subject do
      struct = Class.new(described_class)
      struct.class_eval do
        nested_struct = Class.new(Ronin::Binary::Struct)
        nested_struct.class_eval do
          layout :int, :uint
        end

        layout :int,          :uint,
               :int_array,    [:uint, 2],
               :float,        :float,
               :float_array,  [:float, 2],
               :char,         :char,
               :char_array,   [:char, 2],
               :string,       :string,
               :struct,       nested_struct,
               :struct_array, [nested_struct, 2]
      end

      struct.new
    end

    it "should set integers to 0" do
      expect(subject[:int]).to eq(0)
    end

    it "should set arrays of integers to [0, ...]" do
      expect(subject[:int_array]).to eq([0, 0])
    end

    it "should set floats to 0.0" do
      expect(subject[:float]).to eq(0.0)
    end

    it "should set arrays of floats to [0.0, ...]" do
      expect(subject[:float_array]).to eq([0.0, 0.0])
    end

    it "should set chars to '\\0'" do
      expect(subject[:char]).to eq("\0")
    end

    it "should set arrays of chars to ''" do
      expect(subject[:char_array]).to eq('')
    end

    it "should set strings to ''" do
      expect(subject[:string]).to eq('')
    end

    it "should initialize nested structs" do
      expect(subject[:struct][:int]).to eq(0)
    end

    it "should initialize arrays of nested structs" do
      expect(subject[:struct_array][0][:int]).to eq(0)
      expect(subject[:struct_array][1][:int]).to eq(0)
    end
  end

  describe "#[]" do
    subject do
      struct_class = Class.new(described_class)
      struct_class.class_eval do
        layout :x, :uint,
               :y, :uint
      end

      struct_class.new
    end

    before do
      subject.instance_variable_set('@x',10)
    end

    it "should access the instance variable" do
      expect(subject[:x]).to eq(10)
    end

    it "should still call the underlying reader method" do
      expect(subject).to receive(:x).and_return(10)

      subject[:x]
    end

    it "should raise ArgumentError for unknown fields" do
      expect {
        subject[:foo]
      }.to raise_error(ArgumentError)
    end
  end

  describe "#[]=" do
    subject do
      struct = Class.new(described_class)
      struct.class_eval do
        layout :x, :uint,
               :y, :uint
      end

      struct.new
    end

    before do
      subject.instance_variable_set('@x',0)
    end

    it "should set the underlying instance variable" do
      subject[:x] = 20

      expect(subject.instance_variable_get('@x')).to eq(20)
    end

    it "should still call the underlying writer method" do
      expect(subject).to receive(:x=).with(20)

      subject[:x] = 20
    end

    it "should raise ArgumentError for unknown fields" do
      expect {
        subject[:foo] = 20
      }.to raise_error(ArgumentError)
    end
  end

  describe "#values" do
    let(:x) { 10 }
    let(:y) { 20 }

    subject do
      struct = Class.new(described_class)
      struct.class_eval do
        layout :x, :uint,
               :y, :uint
      end

      struct.new
    end

    before do
      subject.x = x
      subject.y = y
    end

    it "should return the values of the fields" do
      expect(subject.values).to eq([x, y])
    end

    context "nested structs" do
      let(:z) { 30 }

      subject do
        struct = Class.new(described_class)
        struct.class_eval do
          nested_struct = Class.new(Ronin::Binary::Struct)
          nested_struct.class_eval do
            layout :int, :uint
          end

          layout :x, :uint,
                 :y, :uint,
                 :z, nested_struct
        end

        struct.new
      end

      before do
        subject.z.int = z
      end

      it "should nest the values of nested structs" do
        expect(subject.values).to eq([x, y, [z]])
      end
    end

    context "arrays of nested structs" do
      let(:z) { 30 }

      subject do
        struct = Class.new(described_class)
        struct.class_eval do
          nested_struct = Class.new(Ronin::Binary::Struct)
          nested_struct.class_eval do
            layout :int, :uint
          end

          layout :x, :uint,
                 :y, :uint,
                 :z, [nested_struct, 2]
        end

        struct.new
      end

      before do
        subject.z[0].int = z
        subject.z[1].int = z
      end

      it "should nest the values of nested structs" do
        expect(subject.values).to eq([x, y, [[z], [z]]])
      end
    end
  end

  describe "#clear" do
    subject do
      struct_class = Class.new(described_class)
      struct_class.class_eval do
        nested_struct_class = Class.new(Ronin::Binary::Struct)
        nested_struct_class.class_eval do
          layout :int, :int
        end

        layout :x, :uint,
               :y, :float,
               :z, nested_struct_class
      end

      struct_class.new
    end

    before do
      subject.x = 100
      subject.y = 15.0
      subject.z.int = -1

      subject.clear
    end

    it "should reset fields to their default values" do
      expect(subject.x).to eq(0)
      expect(subject.y).to eq(0.0)
    end

    it "should reinitialize nested structs" do
      expect(subject.z.int).to eq(0)
    end
  end

  describe "#pack" do
    context "arrays of chars" do
      let(:string) { "hello" }
      let(:packed) { string.ljust(10,"\0") }

      subject do
        struct = Class.new(described_class)
        struct.class_eval do
          layout :chars, [:char, 10]
        end

        struct.new
      end

      before do
        subject.chars = string
      end

      it "should pack arrays of chars into a String" do
        expect(subject.pack).to eq(packed)
      end
    end

    context "structs" do
      let(:packed) { "\x0a\x00\x14\x00\x00\x00" }

      subject do
        struct = Class.new(described_class)
        struct.class_eval do
          nested_struct = Class.new(Ronin::Binary::Struct)
          nested_struct.class_eval do
            layout :int, :uint32_le
          end

          layout :int,    :uint16_le,
                 :struct, nested_struct
        end

        struct.new
      end

      before do
        subject.int = 10
        subject.struct.int = 20
      end

      it "should pack the nested struct fields" do
        expect(subject.pack).to eq(packed)
      end
    end

    context "arrays of structs" do
      let(:packed) { "\x0a\x00\x14\x00\x00\x00\x1e\x00\x00\x00" }

      subject do
        struct = Class.new(described_class)
        struct.class_eval do
          nested_struct = Class.new(Ronin::Binary::Struct)
          nested_struct.class_eval do
            layout :int, :uint32_le
          end

          layout :int,    :uint16_le,
                 :struct, [nested_struct, 2]
        end

        struct.new
      end

      before do
        subject.int = 10
        subject.struct[0].int = 20
        subject.struct[1].int = 30
      end

      it "should pack the nested fields" do
        expect(subject.pack).to eq(packed)
      end
    end
  end

  describe "#unpack" do
    context "arrays of chars" do
      let(:string) { "hello" }
      let(:packed) { string.ljust(10,"\0") }

      subject do
        struct = Class.new(described_class)
        struct.class_eval do
          layout :chars, [:char, 10]
        end

        struct.new
      end

      it "should unpack arrays of chars into a String" do
        subject.unpack(packed)

        expect(subject.chars).to eq(string)
      end
    end

    context "structs" do
      let(:packed) { "\x0a\x00\x14\x00\x00\x00" }

      subject do
        struct = Class.new(described_class)
        struct.class_eval do
          nested_struct = Class.new(Ronin::Binary::Struct)
          nested_struct.class_eval do
            layout :int, :uint32_le
          end

          layout :int,    :uint16_le,
                 :struct, nested_struct
        end

        struct.new
      end

      it "should unpack the nested struct fields" do
        subject.unpack(packed)

        expect(subject.int).to        eq(10)
        expect(subject.struct.int).to eq(20)
      end
    end

    context "arrays of structs" do
      let(:packed) { "\x0a\x00\x14\x00\x00\x00\x1e\x00\x00\x00" }

      subject do
        struct = Class.new(described_class)
        struct.class_eval do
          nested_struct = Class.new(Ronin::Binary::Struct)
          nested_struct.class_eval do
            layout :int, :uint32_le
          end

          layout :int,    :uint16_le,
                 :struct, [nested_struct, 2]
        end

        struct.new
      end

      it "should unpack the nested fields" do
        subject.unpack(packed)
        
        expect(subject.int).to           eq(10)
        expect(subject.struct[0].int).to eq(20)
        expect(subject.struct[1].int).to eq(30)
      end
    end
  end
end
