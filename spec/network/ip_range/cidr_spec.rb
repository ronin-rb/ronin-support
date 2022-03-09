require 'spec_helper'
require 'ronin/support/network/ip_range/cidr'

describe Ronin::Support::Network::IPRange::CIDR do
  let(:cidr) { '10.1.1.2/24' }

  it "must inherit IPAddr" do
    expect(described_class).to be < IPAddr
  end

  describe "#initialize" do
    subject { described_class.new(cidr) }

    it "must set #string" do
      expect(subject.string).to eq(cidr)
    end
  end

  describe ".parse" do
    subject { described_class.parse(cidr) }

    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must set #string" do
      expect(subject.string).to eq(cidr)
    end
  end

  describe ".each" do
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

      subject { described_class.new(cidr) }

      it "must iterate over every IP address within the IP range" do
        expect { |b|
          described_class.each(cidr,&b)
        }.to yield_successive_args(*addresses)
      end

      context "when no block is given" do
        it "must return an Enumerator" do
          expect(described_class.each(cidr).to_a).to eq(addresses)
        end
      end
    end
  end

  subject { described_class.new(cidr) }

  describe "#each" do
    context "when initialized with a class-D IP address" do
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

    context "when initialized with a class-C IP address range" do
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

  describe "#to_s" do
    it "must return the original string" do
      expect(subject.to_s).to eq(cidr)
    end
  end

  describe "#inspect" do
    it "must include the class name and original string" do
      expect(subject.inspect).to eq("<#{described_class}: #{cidr}>")
    end
  end
end
