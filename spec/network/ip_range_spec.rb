require 'spec_helper'
require 'ronin/support/network/ip_range'

describe Ronin::Support::Network::IPRange do
  let(:cidr) { '10.1.1.2/24' }
  let(:glob) { "10.1.1.*"    }

  describe "#initialize" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      it "must set #string to the CIDR IP range" do
        expect(subject.string).to eq(cidr)
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      it "must set #string" do
        expect(subject.string).to eq(glob)
      end
    end
  end

  describe ".parse" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.parse(cidr) }

      it "must return a #{described_class}" do
        expect(subject).to be_kind_of(described_class)
      end

      it "must set #string" do
        expect(subject.string).to eq(cidr)
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.parse(glob) }

      it "must return a #{described_class}" do
        expect(subject).to be_kind_of(described_class)
      end

      it "must set #string" do
        expect(subject.string).to eq(glob)
      end
    end
  end

  describe ".each" do
    subject { described_class }

    context "when given a CIDR IP range" do
      context "when initialized with a class-D IP address" do
        let(:cidr) { '10.1.1.2' }

        it "must only iterate over one IP address for an address" do
          expect { |b|
            described_class.each(cidr,&b)
          }.to yield_successive_args(cidr)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(described_class.each(cidr).to_a).to eq([cidr])
          end
        end
      end

      context "when initialized with a class-C IP address range" do
        let(:cidr) { '10.1.1.2/24' }
        let(:addresses) do
          (0..255).map { |d| "10.1.1.#{d}" }
        end

        it "must iterate over every IP address within the IP range" do
          expect { |b|
            subject.each(cidr,&b)
          }.to yield_successive_args(*addresses)
        end

        context "when no block is given" do
          it "must return an Enumerator" do
            expect(described_class.each(cidr).to_a).to eq(addresses)
          end
        end
      end
    end

    context "when given a IP glob range" do
      context "and when the IP address range contains '*'" do
        context "and when the IP address is a v4 address" do
          let(:glob) { "10.1.1.*" }
          let(:addresses) do
            (1..254).map { |d| "10.1.1.#{d}" }
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
            (1..254).map { |d| "fe80::abc:%x" % d }
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

  describe "#each" do
    context "when initialized with a CIDR IP range" do
      context "and when initialized with a class-D IP address" do
        let(:cidr) { '10.1.1.2' }
        subject { described_class.new(cidr) }

        it "must only iterate over one IP address for an address" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(cidr)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq([cidr])
          end
        end
      end

      context "and when initialized with a class-C IP address range" do
        let(:cidr) { '10.1.1.2/24' }
        let(:addresses) do
          (0..255).map { |d| "10.1.1.#{d}" }
        end

        subject { described_class.new(cidr) }

        it "must iterate over every IP address within the IP range" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*addresses)
        end

        context "when no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      context "and when the IP address range contains '*'" do
        context "and when the IP address is a v4 address" do
          let(:glob) { "10.1.1.*" }
          let(:addresses) do
            (1..254).map { |d| "10.1.1.#{d}" }
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
            (1..254).map { |d| "fe80::abc:%x" % d }
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
  end

  describe "#to_s" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      it "must return the original string" do
        expect(subject.to_s).to eq(cidr)
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      it "must return the original string" do
        expect(subject.to_s).to eq(glob)
      end
    end
  end

  describe "#inspect" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      it "must include the class name and original CIDR string" do
        expect(subject.inspect).to eq("#<#{described_class}: #{cidr}>")
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      it "must include the class name and original string" do
        expect(subject.inspect).to eq("#<#{described_class}: #{glob}>")
      end
    end
  end
end
