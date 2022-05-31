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

  describe ".range" do
    subject { described_class }

    context "when given two IPv4 addresses" do
      let(:first) { IPAddr.new('1.1.1.1')     }
      let(:last)  { IPAddr.new('1.1.255.255') }

      it "must calculate the CIDR range between them" do
        expect(subject.range(first,last)).to eq(subject.new("1.1.0.0/16"))
      end
    end

    context "when given two IPv6 addresses" do
      let(:first) { IPAddr.new('2607:f8b0:4005:80c::200e') }
      let(:last)  { IPAddr.new('2607:f8b0:4005:80c::ffff') }

      it "must calculate the CIDR range between them" do
        expect(subject.range(first,last)).to eq(subject.new("2607:f8b0:4005:80c::0000/16"))
      end
    end

    context "when the first argument is a String" do
      let(:first) { '1.1.1.1' }
      let(:last)  { IPAddr.new('1.1.255.255') }

      it "must convert the first argument into an IPAddr" do
        expect(subject.range(first,last)).to eq(subject.new("1.1.0.0/16"))
      end
    end

    context "when the second argument is a String" do
      let(:first) { IPAddr.new('1.1.1.1') }
      let(:last)  { '1.1.255.255' }

      it "must convert the second argument into an IPAddr" do
        expect(subject.range(first,last)).to eq(subject.new("1.1.0.0/16"))
      end
    end

    context "when given an IPv4 and an IPv6 address" do
      let(:first) { IPAddr.new('1.1.1.1') }
      let(:last)  { IPAddr.new('2607:f8b0:4005:80c::ffff') }

      it do
        expect {
          subject.range(first,last)
        }.to raise_error(ArgumentError,"must specify two IPv4 or IPv6 addresses: #{first.inspect} #{last.inspect}")
      end
    end

    context "when given an IPv6 and an IPv4 address" do
      let(:first) { IPAddr.new('2607:f8b0:4005:80c::200e') }
      let(:last)  { IPAddr.new('1.1.255.255') }

      it do
        expect {
          subject.range(first,last)
        }.to raise_error(ArgumentError,"must specify two IPv4 or IPv6 addresses: #{first.inspect} #{last.inspect}")
      end
    end
  end

  describe ".each" do
    subject { described_class }

    context "when initialized with a class-D IP address" do
      let(:cidr) { '10.1.1.2' }

      it "must only iterate over one IP address for an address" do
        expect { |b|
          subject.each(cidr,&b)
        }.to yield_successive_args(cidr)
      end

      context "but no block is given" do
        it "must return an Enumerator" do
          expect(subject.each(cidr).to_a).to eq([cidr])
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
          expect(subject.each(cidr).to_a).to eq(addresses)
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
      expect(subject.inspect).to eq("#<#{described_class}: #{cidr}>")
    end
  end
end
