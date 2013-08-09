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
      subject.class.layout.should == [
        :x,
        :y
      ]
    end

    context "when given fields" do
      it "should populate fields" do
        subject.class.fields.should == {
          x: [:uint, nil],
          y: [:uint, nil]
        }
      end

      it "should define reader methods" do
        subject.should respond_to(:x)
        subject.should respond_to(:y)
      end

      it "should define writer methods" do
        subject.should respond_to(:x=)
        subject.should respond_to(:y=)
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
      subject.field?(:x).should == true
      subject.field?(:foo).should == false
    end
  end

  describe "endian" do
    subject do
      struct = Class.new(described_class)
      struct.class_eval { endian :little }
      struct
    end

    it "should return the endianness of the Struct" do
      subject.endian.should == :little
    end

    context "when given an argument" do
      it "should set the endianness" do
        subject.endian :big

        subject.endian.should == :big
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
      subject.typedefs.should have_key(:test_t)
    end

    it "should resolve the existing type" do
      subject.typedefs[:test_t].should == :uint32
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
      subject[:int].should == 0
    end

    it "should set arrays of integers to [0, ...]" do
      subject[:int_array].should == [0, 0]
    end

    it "should set floats to 0.0" do
      subject[:float].should == 0.0
    end

    it "should set arrays of floats to [0.0, ...]" do
      subject[:float_array].should == [0.0, 0.0]
    end

    it "should set chars to '\\0'" do
      subject[:char].should == "\0"
    end

    it "should set arrays of chars to ''" do
      subject[:char_array].should == ''
    end

    it "should set strings to ''" do
      subject[:string].should == ''
    end

    it "should initialize nested structs" do
      subject[:struct][:int].should == 0
    end

    it "should initialize arrays of nested structs" do
      subject[:struct_array][0][:int].should == 0
      subject[:struct_array][1][:int].should == 0
    end
  end

  describe "#[]" do
    subject do
      struct_class = Class.new(described_class)
      struct_class.class_eval do
        layout :x, :uint,
               :y, :uint
      end

      struct_class.new.tap do |struct|
        struct.instance_variable_set('@x',10)
      end
    end

    it "should access the instance variable" do
      subject[:x].should == 10
    end

    it "should still call the underlying reader method" do
      subject.should_receive(:x).and_return(10)

      subject[:x]
    end

    it "should raise ArgumentError for unknown fields" do
      lambda {
        subject[:foo]
      }.should raise_error(ArgumentError)
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

    before(:each) do
      subject.instance_variable_set('@x',0)
    end

    it "should set the underlying instance variable" do
      subject[:x] = 20

      subject.instance_variable_get('@x').should == 20
    end

    it "should still call the underlying writer method" do
      subject.should_receive(:x=).with(20)

      subject[:x] = 20
    end

    it "should raise ArgumentError for unknown fields" do
      lambda {
        subject[:foo] = 20
      }.should raise_error(ArgumentError)
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

    before(:each) do
      subject.x = x
      subject.y = y
    end

    it "should return the values of the fields" do
      subject.values.should == [x, y]
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

      before(:each) do
        subject.z.int = z
      end

      it "should nest the values of nested structs" do
        subject.values.should == [x, y, [z]]
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

      before(:each) do
        subject.z[0].int = z
        subject.z[1].int = z
      end

      it "should nest the values of nested structs" do
        subject.values.should == [x, y, [[z], [z]]]
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

      struct_class.new.tap do |struct|
        struct.x = 100
        struct.y = 15.0
        struct.z.int = -1
      end
    end

    before { subject.clear }

    it "should reset fields to their default values" do
      subject.x.should == 0
      subject.y.should == 0.0
    end

    it "should reinitialize nested structs" do
      subject.z.int.should == 0
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

      before(:each) do
        subject.chars = string
      end

      it "should pack arrays of chars into a String" do
        subject.pack.should == packed
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

      before(:each) do
        subject.int = 10
        subject.struct.int = 20
      end

      it "should pack the nested struct fields" do
        subject.pack.should == packed
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

      before(:each) do
        subject.int = 10
        subject.struct[0].int = 20
        subject.struct[1].int = 30
      end

      it "should pack the nested fields" do
        subject.pack.should == packed
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

        subject.chars.should == string
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

        subject.int.should        == 10
        subject.struct.int.should == 20
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
        
        subject.int.should           == 10
        subject.struct[0].int.should == 20
        subject.struct[1].int.should == 30
      end
    end
  end
end
