require 'spec_helper'
require 'ronin/support/binary/types/arch'

describe Ronin::Support::Binary::Types::Arch do
  describe "ARCHES" do
    subject { described_class::ARCHES }

    describe "x86" do
      subject { super()[:x86] }

      it { expect(subject).to be(Ronin::Support::Binary::Types::Arch::X86) }
    end

    describe "x86_64" do
      subject { super()[:x86_64] }

      it { expect(subject).to be(Ronin::Support::Binary::Types::Arch::X86_64) }
    end

    describe "ia64" do
      it "must be an alias to :x86_64" do
        expect(subject[:ia64]).to be(subject[:x86_64])
      end
    end

    describe "amd64" do
      it "must be an alias to :x86_64" do
        expect(subject[:amd64]).to be(subject[:x86_64])
      end
    end

    describe "ppc" do
      subject { super()[:ppc] }

      it { expect(subject).to be(Ronin::Support::Binary::Types::Arch::PPC) }
    end

    describe "ppc64" do
      subject { super()[:ppc64] }

      it { expect(subject).to be(Ronin::Support::Binary::Types::Arch::PPC64) }
    end

    describe "mips" do
      subject { super()[:mips] }

      it { expect(subject).to be(Ronin::Support::Binary::Types::Arch::MIPS) }
    end

    describe "mips_le" do
      subject { super()[:mips_le] }

      it do
        expect(subject).to be(Ronin::Support::Binary::Types::Arch::MIPS::LittleEndian)
      end
    end

    describe "mips_be" do
      it "must be an alias to :mips" do
        expect(subject[:mips_be]).to be(subject[:mips])
      end
    end

    describe "mips64" do
      subject { super()[:mips64] }

      it { expect(subject).to be(Ronin::Support::Binary::Types::Arch::MIPS64) }
    end

    describe "mips64_le" do
      subject { super()[:mips64_le] }

      it do
        expect(subject).to be(Ronin::Support::Binary::Types::Arch::MIPS64::LittleEndian)
      end
    end

    describe "mips64_be" do
      it "must be an alias to :mips64" do
        expect(subject[:mips64_be]).to be(subject[:mips64])
      end
    end

    describe "arm" do
      subject { super()[:arm] }

      it { expect(subject).to be(Ronin::Support::Binary::Types::Arch::ARM) }
    end

    describe "arm_le" do
      it "must be an alias to :arm" do
        expect(subject[:arm_le]).to be(subject[:arm])
      end
    end

    describe "arm_be" do
      subject { super()[:arm_be] }

      it do
        expect(subject).to be(Ronin::Support::Binary::Types::Arch::ARM::BigEndian)
      end
    end

    describe "arm64" do
      subject { super()[:arm64] }

      it { expect(subject).to be(Ronin::Support::Binary::Types::Arch::ARM64) }
    end

    describe "arm64_le" do
      it "must be an alias to :arm64" do
        expect(subject[:arm64_le]).to be(subject[:arm64])
      end
    end

    describe "arm64_be" do
      subject { super()[:arm64_be] }

      it do
        expect(subject).to be(Ronin::Support::Binary::Types::Arch::ARM64::BigEndian)
      end
    end
  end
end
