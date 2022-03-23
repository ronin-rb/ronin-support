require 'spec_helper'
require 'ronin/support/binary/stack'

describe Ronin::Support::Binary::Stack do
  describe "#initialize" do
    subject { described_class.new }

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

      subject { described_class.new(endian: endian) }

      it "must set #endian" do
        expect(subject.endian).to be(endian)
      end

      it "must set #type_system to the Ronin::Support::Binary::Types:: module" do
        expect(subject.type_system).to be(Ronin::Support::Binary::Types.endian(endian))
      end
    end

    context "when the arch: keyword argument is given" do
      let(:arch) { :x86 }

      subject { described_class.new(arch: arch) }

      it "must set #arch" do
        expect(subject.arch).to be(arch)
      end

      it "must set #type_system to the Ronin::Support::Binary::Types::Arch:: module" do
        expect(subject.type_system).to be(Ronin::Support::Binary::Types::Arch[arch])
      end
    end

    context "when a String argument is given instead of a length argument" do
      let(:length) { 8 }
      let(:string) { "A" * length }

      subject { described_class.new(string) }

      it "must set #string to the given string value" do
        expect(subject.string).to be(string)
      end

      it "must set #size to the string's byte size" do
        expect(subject.size).to eq(string.bytesize)
      end

      it "must calculate #length by dividing #size by #machine_word.size" do
        expect(subject.length).to eq(subject.size / subject.machine_word.size)
      end
    end
  end

  let(:machine_word) { subject.machine_word }

  describe "#[]" do
    context "when the stack is empty" do
      let(:index)  { 0 }

      it do
        expect {
          subject[index]
        }.to raise_error(IndexError,"index #{index} is out of bounds: 0...0")
      end
    end

    context "when the stack is populated" do
      let(:value1) { 1          }
      let(:value2) { 0x41       }
      let(:value3) { 0x11223344 }

      before do
        subject.push(value1)
        subject.push(value2)
        subject.push(value3)
      end

      let(:index)  { 1 }
      let(:offset) { index * machine_word.size }

      it "must allow reading arbitrary values at offsets within the stack" do
        expect(subject[offset]).to eq(value2)
      end

      context "when a negative index is given" do
        let(:offset) { -(machine_word.size * 2) }

        it "must read the value relative to beginning of the buffer" do
          expect(subject[offset]).to eq(value2)
        end
      end
    end
  end

  describe "#[]=" do
    context "when the stack is empty" do
      let(:index) { 0 }
      let(:value) { 1 }

      it do
        expect {
          subject[index] = value
        }.to raise_error(IndexError,"index #{index} is out of bounds: 0...0")
      end
    end

    context "when the stack is populated" do
      let(:value1) { 1          }
      let(:value2) { 0x41       }
      let(:value3) { 0x11223344 }

      let(:index)     { 1 * machine_word.size }
      let(:new_value) { 0x42 }

      before do
        subject.push(value1)
        subject.push(value2)
        subject.push(value3)

        subject[index] = new_value
      end

      let(:packed_value) { machine_word.pack(new_value) }

      it "must write the new value into the buffer at the offset" do
        expect(subject.string[index,machine_word.size]).to eq(packed_value)
      end

      context "when a negative index is given" do
        let(:index )  { -(machine_word.size * 2) }
        let(:offset)  { index.abs - machine_word.size }

        it "must write the value relative to the beginning of the buffer" do
          expect(subject.string[offset,machine_word.size]).to eq(packed_value)
        end
      end
    end
  end

  describe "#push" do
    let(:value) { 0x11223344 }

    let(:machine_word) { subject.machine_word     }
    let(:packed_value) { machine_word.pack(value) }

    before { subject.push(value) }

    it "must write a machine word to the end of the buffer" do
      expect(subject.string[-machine_word.size..]).to eq(packed_value)
    end
  end

  describe "#pop" do
    let(:value) { 0x11223344 }

    let(:machine_word) { subject.machine_word     }
    let(:packed_value) { machine_word.pack(value) }

    context "when there is only one value on the stack" do
      before { subject.push(value) }

      it "must return the only value on the stack" do
        expect(subject.pop).to eq(value)
      end

      it "must make #string empty" do
        subject.pop

        expect(subject.string).to eq('')
      end
    end

    context "when there is multiple values on the stack" do
      let(:last_value) { 0x11223344 }
      let(:values)     { [1, 0x41414141, last_value] }

      before do
        values.each do |value|
          subject.push(value)
        end
      end

      it "must return the last value pushed onto the stack" do
        expect(subject.pop).to eq(last_value)
      end

      it "must truncate the end of the buffer by #machine_word.size bytes" do
        subject.pop

        expect(subject.string.bytesize).to eq(
          (values.length * machine_word.size) - machine_word.size
        )
      end
    end
  end

  describe "#to_s" do
    context "when the stack is empty" do
      it "must return an empty String" do
        expect(subject.to_s).to eq('')
      end
    end

    context "when the stack is populated" do
      before do
        subject.push 1
        subject.push 2
        subject.push 3
      end

      it "must return #string" do
        expect(subject.to_s).to be(subject.string)
      end
    end
  end

  describe "#to_str" do
    context "when the stack is empty" do
      it "must return an empty String" do
        expect(subject.to_s).to eq('')
      end
    end

    context "when the stack is populated" do
      before do
        subject.push 1
        subject.push 2
        subject.push 3
      end

      it "must return #string" do
        expect(subject.to_s).to be(subject.string)
      end
    end
  end

  describe "#inspect" do
    it "must return the class name and the buffer string" do
      expect(subject.inspect).to eq("#<#{described_class}: #{subject.string.inspect}>")
    end
  end
end
