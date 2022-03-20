require 'rspec'

shared_examples_for "64bit Arch examples" do
  describe "ADDRESS_SIZE" do
    subject { described_class::ADDRESS_SIZE }

    it { expect(subject).to eq(8) }
  end

  describe "MACHINE_WORD" do
    subject { described_class::MACHINE_WORD }

    it "must equal UInt64" do
      expect(subject).to be(described_class::UInt64)
    end
  end

  describe "TYPES" do
    subject { described_class::TYPES }

    describe ":long" do
      it "must be an alias to :int64" do
        expect(subject[:long]).to be(subject[:int64])
      end
    end

    describe ":ulong" do
      it "must be an alias to :uint64" do
        expect(subject[:ulong]).to be(subject[:uint64])
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
