require 'spec_helper'
require 'ronin/support/network/ip_range/range'

describe Ronin::Support::Network::IPRange::Range do
  let(:first_ipv4) { '127.0.0.127' }
  let(:last_ipv4)  { '127.0.1.127' }
  let(:first_ipv6) { '1234:abcd::7fff' }
  let(:last_ipv6)  { '1234:abcd::1:7fff' }

  let(:first) { first_ipv4 }
  let(:last)  { last_ipv4  }

  subject { described_class.new(first,last) }

  describe "#initialize" do
    it "must initialize #begin as a Ronin::Support::Network::IP" do
      expect(subject.begin).to be_kind_of(Ronin::Support::Network::IP)
      expect(subject.begin.address).to eq(first)
    end

    it "must initialize #end as a Ronin::Support::Network::IP" do
      expect(subject.end).to be_kind_of(Ronin::Support::Network::IP)
      expect(subject.end.address).to eq(last)
    end

    it "must calculate and set #prefix using self.class.prefix" do
      expect(subject.prefix).to eq(described_class.prefix(first,last))
    end
  end

  describe ".prefix" do
    subject { described_class }

    context "when the two IP addresses do have a common prefix" do
      let(:prefix) { '100.100.' }
      let(:first)  { "#{prefix}100.100" }
      let(:last)   { "#{prefix}255.255" }

      it "must return the common prefix String" do
        expect(subject.prefix(first,last)).to eq(prefix)
      end
    end

    context "when the two IP addresses are the same" do
      let(:first) { '1.2.3.4' }
      let(:last)  { first }

      it "must return the first IP address" do
        expect(subject.prefix(first,last)).to eq(first)
      end
    end

    context "when the two IP addresses do not share a common prefix" do
      let(:first) { '100.100.100.100' }
      let(:last)  { '255.255.255.255' }

      it "must return an empty String" do
        expect(subject.prefix(first,last)).to eq("")
      end
    end
  end

  describe "#ipv4?" do
    context "when both IP addresses are IPv4 addresses" do
      subject { described_class.new(first,last) }

      it "must return true" do
        expect(subject.ipv4?).to be(true)
      end
    end

    context "when both IP addresses are IPv6 addresses" do
      subject { described_class.new(first_ipv6,last_ipv6) }

      it "must return false" do
        expect(subject.ipv4?).to be(false)
      end
    end
  end

  describe "#ipv6?" do
    context "when both IP addresses are IPv4 addresses" do
      subject { described_class.new(first,last) }

      it "must return false" do
        expect(subject.ipv6?).to be(false)
      end
    end

    context "when both IP addresses are IPv6 addresses" do
      subject { described_class.new(first_ipv6,last_ipv6) }

      it "must return true" do
        expect(subject.ipv6?).to be(true)
      end
    end
  end

  describe "#include?" do
    context "when the two IP addresses are IPv4 addresses" do
      let(:first) { first_ipv4 }
      let(:last)  { last_ipv4 }

      context "when the given IP address matches the first IP address" do
        it "must return true" do
          expect(subject.include?(first)).to be(true)
        end
      end

      context "when the given IP address matches the last IP address" do
        it "must return true" do
          expect(subject.include?(last)).to be(true)
        end
      end

      context "when the given IP address is between the two IP addresses" do
        let(:ip) { '127.0.0.255' }

        it "must return true" do
          expect(subject.include?(ip)).to be(true)
        end
      end

      context "when the given IP address is less than the first IP address" do
        let(:ip) { '127.0.0.126' }

        it "must return false" do
          expect(subject.include?(ip)).to be(false)
        end
      end

      context "when the given IP address is greater than the last IP address" do
        let(:ip) { '127.0.1.128' }

        it "must return false" do
          expect(subject.include?(ip)).to be(false)
        end
      end
    end

    context "when the two IP addresses are IPv6 addresses" do
      let(:first) { first_ipv6 }
      let(:last)  { last_ipv6 }

      context "when the given IP address matches the first IP address" do
        it "must return true" do
          expect(subject.include?(first)).to be(true)
        end
      end

      context "when the given IP address matches the last IP address" do
        it "must return true" do
          expect(subject.include?(last)).to be(true)
        end
      end

      context "when the given IP address is between the two IP addresses" do
        let(:ip) { '1234:abcd::ffff' }

        it "must return true" do
          expect(subject.include?(ip)).to be(true)
        end
      end

      context "when the given IP address is less than the first IP address" do
        let(:ip) { '1234:abcd::7ffe' }

        it "must return false" do
          expect(subject.include?(ip)).to be(false)
        end
      end

      context "when the given IP address is greater than the last IP address" do
        let(:ip) { '1234:abcd::1:8000' }

        it "must return false" do
          expect(subject.include?(ip)).to be(false)
        end
      end
    end
  end

  describe "#each" do
    context "when the two IP addresses are IPv4 addresses" do
      let(:first) { '1.2.3.4'  }
      let(:last)  { '1.2.3.10' }

      context "when given a block" do
        it "must yield every IPv4 address between the two IP addresses" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(
            '1.2.3.4',
            '1.2.3.5',
            '1.2.3.6',
            '1.2.3.7',
            '1.2.3.8',
            '1.2.3.9',
            '1.2.3.10'
          )
        end
      end

      context "when no block is given" do
        it "must return an Enumerator for the #each method" do
          expect(subject.each.to_a).to eq(
            [
              '1.2.3.4',
              '1.2.3.5',
              '1.2.3.6',
              '1.2.3.7',
              '1.2.3.8',
              '1.2.3.9',
              '1.2.3.10'
            ]
          )
        end
      end
    end

    context "when the two IP addresses are IPv6 addresses" do
      let(:first) { 'abcd::1234' }
      let(:last)  { 'abcd::123a' }

      context "when given a block" do
        it "must yield every IPv6 address between the two IP addresses" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(
            'abcd::1234',
            'abcd::1235',
            'abcd::1236',
            'abcd::1237',
            'abcd::1238',
            'abcd::1239',
            'abcd::123a'
          )
        end
      end

      context "when no block is given" do
        it "must return an Enumerator for the #each method" do
          expect(subject.each.to_a).to eq(
            [
              'abcd::1234',
              'abcd::1235',
              'abcd::1236',
              'abcd::1237',
              'abcd::1238',
              'abcd::1239',
              'abcd::123a'
            ]
          )
        end
      end
    end
  end

  describe "#==" do
    context "when given another #{described_class} object" do
      let(:first) { '1.0.0.0' }
      let(:last)  { '1.0.0.255' }

      context "and when both #begin and #end attributes are the same" do
        let(:other_first) { first }
        let(:other_last)  { last  }
        let(:other)       { described_class.new(other_first,other_last) }

        it "must return true" do
          expect(subject == other).to be(true)
        end
      end

      context "but the #begin attribute is different" do
        let(:other_first) { '1.0.0.1' }
        let(:other_last)  { last }
        let(:other)       { described_class.new(other_first,other_last) }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end

      context "but the #end attribute is different" do
        let(:other_first) { first }
        let(:other_last)  { '1.0.1.255' }
        let(:other)       { described_class.new(other_first,other_last) }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end
    end

    context "when given an Object" do
      let(:other) { Object.new }

      it "must return false" do
        expect(subject == other).to eq(false)
      end
    end
  end

  describe "#size" do
    it "must return the number of IPs in the IP range" do
      expect(subject.size).to eq(257)
    end
  end

  describe "#to_s" do
    it "must return the two IP addresses" do
      expect(subject.to_s).to eq("#{first} - #{last}")
    end
  end

  describe "#inspect" do
    it "must return the class name and the two IP addresses" do
      expect(subject.inspect).to eq("#<#{described_class}: #{first} - #{last}>")
    end
  end
end
