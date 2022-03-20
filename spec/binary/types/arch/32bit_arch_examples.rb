require 'rspec'

shared_examples_for "32bit Arch examples" do
  describe "ADDRESS_SIZE" do
    subject { described_class::ADDRESS_SIZE }

    it { expect(subject).to eq(4) }
  end

  describe "MACHINE_WORD" do
    subject { described_class::MACHINE_WORD }

    it "must equal UInt32" do
      expect(subject).to be(described_class::UInt32)
    end
  end

  describe "TYPES" do
    subject { described_class::TYPES }

    describe ":long" do
      it "must be an alias to :int32" do
        expect(subject[:long]).to be(subject[:int32])
      end
    end

    describe ":ulong" do
      it "must be an alias to :uint32" do
        expect(subject[:ulong]).to be(subject[:uint32])
      end
    end

    describe ":machine_word" do
      subject { super()[:machine_word] }

      it "must equal MACHINE_WORD" do
        expect(subject).to be(described_class::MACHINE_WORD)
      end
    end

    describe ":pointer" do
      subject { super()[:pointer] }

      it "must equal MACHINE_WORD" do
        expect(subject).to be(described_class::MACHINE_WORD)
      end
    end
  end
end
