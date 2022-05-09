require 'rspec'

shared_examples_for "64bit BE Arch examples" do
  it { expect(subject).to include(Ronin::Support::Binary::CTypes::BigEndian) }

  describe "ADDRESS_SIZE" do
    subject { described_class::ADDRESS_SIZE }

    it { expect(subject).to eq(8) }
  end

  let(:int64)  { Ronin::Support::Binary::CTypes::BigEndian::INT64  }
  let(:uint64) { Ronin::Support::Binary::CTypes::BigEndian::UINT64 }

  describe "LONG" do
    subject { described_class::LONG }

    it "must equal INT64" do
      expect(subject).to be(int64)
    end
  end

  describe "ULONG" do
    subject { described_class::ULONG }

    it "must equal UINT64" do
      expect(subject).to be(uint64)
    end
  end

  describe "MACHINE_WORD" do
    subject { described_class::MACHINE_WORD }

    it "must equal UINT64" do
      expect(subject).to be(uint64)
    end
  end

  describe "POINTER" do
    subject { described_class::POINTER }

    it "must equal UINT64" do
      expect(subject).to be(uint64)
    end
  end

  describe "TYPES" do
    subject { described_class::TYPES }

    describe ":long" do
      subject { super()[:long] }

      it "must equal INT64" do
        expect(subject).to be(int64)
      end
    end

    describe ":ulong" do
      subject { super()[:ulong] }

      it "must equal UINT64" do
        expect(subject).to be(uint64)
      end
    end

    describe ":machine_word" do
      subject { super()[:machine_word] }

      it "must equal UINT64" do
        expect(subject).to be(uint64)
      end
    end

    describe ":pointer" do
      subject { super()[:machine_word] }

      it "must equal UINT64" do
        expect(subject).to be(uint64)
      end
    end
  end
end
