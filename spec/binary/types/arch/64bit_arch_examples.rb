require 'rspec'

shared_examples_for "64bit Arch examples" do
  describe "ADDRESS_SIZE" do
    subject { described_class::ADDRESS_SIZE }

    it { expect(subject).to eq(8) }
  end

  describe "LONG" do
    subject { described_class::LONG }

    it "must equal INT64" do
      expect(subject).to be(described_class::INT64)
    end
  end

  describe "ULONG" do
    subject { described_class::ULONG }

    it "must equal UINT64" do
      expect(subject).to be(described_class::UINT64)
    end
  end

  describe "MACHINE_WORD" do
    subject { described_class::MACHINE_WORD }

    it "must equal UINT64" do
      expect(subject).to be(described_class::UINT64)
    end
  end

  describe "POINTER" do
    subject { described_class::POINTER }

    it "must equal MACHINE_WORD" do
      expect(subject).to be(described_class::MACHINE_WORD)
    end
  end

  describe "TYPES" do
    subject { described_class::TYPES }

    describe ":long" do
      it "must equal LONG" do
        expect(subject[:long]).to eq(described_class::LONG)
      end
    end

    describe ":ulong" do
      it "must equal ULONG" do
        expect(subject[:ulong]).to eq(described_class::ULONG)
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

      it "must equal POINTER" do
        expect(subject).to be(described_class::POINTER)
      end
    end
  end
end
