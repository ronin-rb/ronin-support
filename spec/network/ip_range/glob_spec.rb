require 'spec_helper'
require 'ronin/support/network/ip_range/glob'

describe Ronin::Support::Network::IPRange::Glob do
  let(:glob) { "10.1.1.*" }

  describe "#initialize" do
    subject { described_class.new(glob) }

    it "must set #string" do
      expect(subject.string).to eq(glob)
    end
  end

  describe ".parse" do
    subject { described_class.parse(glob) }

    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must set #string" do
      expect(subject.string).to eq(glob)
    end
  end

  describe ".each" do
    subject { described_class }

    context "and when the IP address range contains '*'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.*" }
        let(:addresses) do
          (0..255).map { |d| "10.1.1.#{d}" }
        end

        it "must expand '*' globs to 1-254" do
          expect { |b|
            subject.each(glob,&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:*" }
        let(:addresses) do
          (0..255).map { |d| "fe80::abc:%x" % d }
        end

        it "must expand '*' globs to 01-fe" do
          expect { |b|
            subject.each(glob,&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end
    end

    context "when the IP address range contains 'i-j'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.10-20" }
        let(:addresses) do
          (10..20).map { |d| "10.1.1.#{d}" }
        end

        it "must expend 'i-j' ranges" do
          expect { |b|
            subject.each(glob,&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:a-14" }
        let(:addresses) do
          (0x0a..0x14).map { |d| "fe80::abc:%x" % d }
        end

        it "must expand 'i-j' ranges" do
          expect { |b|
            subject.each(glob,&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end
    end

    context "when the IP address range contains 'i,j,k'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.1,2,4" }
        let(:addresses) do
          [1,2,4].map { |d| "10.1.1.#{d}" }
        end

        it "must expand 'i,j,k' ranges" do
          expect { |b|
            subject.each(glob,&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:1,2,4" }
        let(:addresses) do
          [0x01, 0x02, 0x04].map { |d| "fe80::abc:%x" % d }
        end

        it "must expand 'i,j,k' ranges" do
          expect { |b|
            subject.each(glob,&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end
    end

    context "when the IP address range contains 'i,j-k'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.1,3-4" }
        let(:addresses) do
          [1, *(3..4)].map { |d| "10.1.1.#{d}" }
        end

        it "must expand combination 'i,j-k' ranges" do
          expect { |b|
            subject.each(glob,&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:1,3-4" }
        let(:addresses) do
          [1, *(3..4)].map { |d| "fe80::abc:%x" % d }
        end

        it "must expand 'i,j-k' ranges" do
          expect { |b|
            subject.each(glob,&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end
    end
  end

  subject { described_class.new(glob) }

  describe "#each" do
    context "and when the IP address range contains '*'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.*" }
        let(:addresses) do
          (0..255).map { |d| "10.1.1.#{d}" }
        end

        it "must expand '*' globs to 1-254" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:*" }
        let(:addresses) do
          (0..255).map { |d| "fe80::abc:%x" % d }
        end

        it "must expand '*' globs to 01-fe" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end
    end

    context "when the IP address range contains 'i-j'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.10-20" }
        let(:addresses) do
          (10..20).map { |d| "10.1.1.#{d}" }
        end

        it "must expend 'i-j' ranges" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:a-14" }
        let(:addresses) do
          (0x0a..0x14).map { |d| "fe80::abc:%x" % d }
        end

        it "must expand 'i-j' ranges" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end
    end

    context "when the IP address range contains 'i,j,k'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.1,2,4" }
        let(:addresses) do
          [1,2,4].map { |d| "10.1.1.#{d}" }
        end

        it "must expand 'i,j,k' ranges" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:1,2,4" }
        let(:addresses) do
          [0x01, 0x02, 0x04].map { |d| "fe80::abc:%x" % d }
        end

        it "must expand 'i,j,k' ranges" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end
    end

    context "when the IP address range contains 'i,j-k'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.1,3-4" }
        let(:addresses) do
          [1, *(3..4)].map { |d| "10.1.1.#{d}" }
        end

        it "must expand combination 'i,j-k' ranges" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:1,3-4" }
        let(:addresses) do
          [1, *(3..4)].map { |d| "fe80::abc:%x" % d }
        end

        it "must expand 'i,j-k' ranges" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end
    end
  end

  describe "#to_s" do
    it "must return the original string" do
      expect(subject.to_s).to eq(glob)
    end
  end

  describe "#inspect" do
    it "must include the class name and original string" do
      expect(subject.inspect).to eq("#<#{described_class}: #{glob}>")
    end
  end
end
