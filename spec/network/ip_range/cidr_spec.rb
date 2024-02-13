require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/network/ip_range/cidr'
require 'ronin/support/network/ip_range/glob'

describe Ronin::Support::Network::IPRange::CIDR do
  let(:prefix) { '10.1.1.2' }
  let(:suffix) { 24 }
  let(:cidr)   { "#{prefix}/#{suffix}" }

  it "must inherit IPAddr" do
    expect(described_class).to be < IPAddr
  end

  describe "IPV4_REGEX" do
    subject { described_class::IPV4_REGEX }

    it "must match the full string" do
      expect(' 1.2.3.4/24 ').to_not match(subject)
    end

    it "must match non-CIDR IPv4 addresses" do
      expect('1.2.3.4').to fully_match(subject)
    end

    it "must match '0.0.0.0'" do
      expect('0.0.0.0').to fully_match(subject)
    end

    it "must match '255.255.255.255'" do
      expect('255.255.255.255').to fully_match(subject)
    end

    it "must not match octets greater than 255" do
      expect('256.255.255.255').to_not match(subject)
      expect('255.256.255.255').to_not match(subject)
      expect('255.255.256.255').to_not match(subject)
      expect('255.255.256.256').to_not match(subject)
    end

    it "must match CIDR IPv4 addresses" do
      expect('1.2.3.4/24').to fully_match(subject)
    end

    it "must not match bit lengths greater than 32" do
      expect('1.2.3.4/33').to_not match(subject)
    end
  end

  describe "IPV6_REGEX" do
    subject { described_class::IPV6_REGEX }

    it "must match the full string" do
      expect(' 1111:2222:3333:4444:5555:6666:7777:8888/128 ').to_not match(subject)
    end

    it "must match non-CIDR IPv6 addresses" do
      expect('1111:2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
    end

    it "must match '0:0:0:0:0:0:0:0'" do
      expect('0:0:0:0:0:0:0:0').to fully_match(subject)
    end

    it "must match 'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'" do
      expect('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').to fully_match(subject)
    end

    it "must match 'FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF'" do
      expect('FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF').to fully_match(subject)
    end

    it "must not match octets longer than four hex digits" do
      expect('fffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').to_not match(subject)
      expect('ffff:fffff:ffff:ffff:ffff:ffff:ffff:ffff').to_not match(subject)
      expect('ffff:ffff:fffff:ffff:ffff:ffff:ffff:ffff').to_not match(subject)
      expect('ffff:ffff:ffff:fffff:ffff:ffff:ffff:ffff').to_not match(subject)
      expect('ffff:ffff:ffff:ffff:fffff:ffff:ffff:ffff').to_not match(subject)
      expect('ffff:ffff:ffff:ffff:ffff:fffff:ffff:ffff').to_not match(subject)
      expect('ffff:ffff:ffff:ffff:ffff:ffff:fffff:ffff').to_not match(subject)
      expect('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffff').to_not match(subject)
    end

    it "must match non-CIDR truncated IPv6 addresses" do
      expect('::').to fully_match(subject)
      expect('::2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111::3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222::4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333::5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444::6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555::7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666::8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777::').to fully_match(subject)
    end

    it "must match non-CIDR IPv4-mapped IPv6 addresses" do
      expect('::ffff:1.2.3.4').to fully_match(subject)
    end

    it "must match CIDR IPv6 addresses" do
      expect('1111:2222:3333:4444:5555:6666:7777:8888/128').to fully_match(subject)
    end

    it "must match CIDR truncated IPv6 addresses" do
      expect('::/128').to fully_match(subject)
      expect('::2222:3333:4444:5555:6666:7777:8888/128').to fully_match(subject)
      expect('1111::3333:4444:5555:6666:7777:8888/128').to fully_match(subject)
      expect('1111:2222::4444:5555:6666:7777:8888/128').to fully_match(subject)
      expect('1111:2222:3333::5555:6666:7777:8888/128').to fully_match(subject)
      expect('1111:2222:3333:4444::6666:7777:8888/128').to fully_match(subject)
      expect('1111:2222:3333:4444:5555::7777:8888/128').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666::8888/128').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777::/128').to fully_match(subject)
    end

    it "must match CIDR IPv4-mapped IPv6 addresses" do
      expect('::ffff:1.2.3.4/128').to fully_match(subject)
    end

    it "must not match bit lengths greater than 128" do
      expect('1111:2222:3333:4444:5555:6666:7777:8888/129').to_not match(subject)
    end
  end

  describe "REGEX" do
    subject { described_class::REGEX }

    it "must match IPv4 CIDR ranges" do
      expect('1.2.3.4/24').to fully_match(subject)
    end

    it "must match IPv6 CIDR ranges" do
      expect('1111:2222::8888/120').to fully_match(subject)
    end

    it "must match IPv4-mapped IPv6 CIDR ranges" do
      expect('::ffff:1.2.3.4/120').to fully_match(subject)
    end
  end

  describe "#initialize" do
    subject { described_class.new(cidr) }

    it "must set #string" do
      expect(subject.string).to eq(cidr)
    end

    context "when given an invalid IPv4 CIDR string" do
      let(:cidr) { '256.256.256.256/32' }

      it do
        expect {
          described_class.new(cidr)
        }.to raise_error(ArgumentError,"invalid CIDR range: #{cidr.inspect}")
      end
    end

    context "when given an invalid IPv6 CIDR string" do
      let(:cidr) { '11:11:11:11:11:11/128' }

      it do
        expect {
          described_class.new(cidr)
        }.to raise_error(ArgumentError,"invalid CIDR range: #{cidr.inspect}")
      end
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
        expect(subject.range(first,last)).to eq(subject.new("1.1.1.1/16"))
      end

      context "when there is no difference between the two addresses" do
        let(:first) { IPAddr.new('1.1.1.1') }
        let(:last)  { IPAddr.new('1.1.1.1') }

        it "must return the IPv4 address" do
          expect(subject.range(first,last)).to eq(subject.new(first.to_s))
        end
      end
    end

    context "when given two IPv6 addresses" do
      let(:first) { IPAddr.new('2607:f8b0:4005:80c::200e') }
      let(:last)  { IPAddr.new('2607:f8b0:4005:80c::ffff') }

      it "must calculate the CIDR range between them" do
        expect(subject.range(first,last)).to eq(subject.new("2607:f8b0:4005:80c::200e/112"))
      end

      context "when there is no difference between the two addresses" do
        let(:first) { IPAddr.new('2607:f8b0:4005:80c::200e') }
        let(:last)  { IPAddr.new('2607:f8b0:4005:80c::200e') }

        it "must return the IPv6 address" do
          expect(subject.range(first,last)).to eq(subject.new(first.to_s))
        end
      end
    end

    context "when the first argument is a String" do
      let(:first) { '1.1.1.1' }
      let(:last)  { IPAddr.new('1.1.255.255') }

      it "must convert the first argument into an IPAddr" do
        expect(subject.range(first,last)).to eq(subject.new("1.1.1.1/16"))
      end
    end

    context "when the second argument is a String" do
      let(:first) { IPAddr.new('1.1.1.1') }
      let(:last)  { '1.1.255.255' }

      it "must convert the second argument into an IPAddr" do
        expect(subject.range(first,last)).to eq(subject.new("1.1.1.1/16"))
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
        }.to yield_with_args(cidr)
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

  describe "#prefix_address" do
    it "must return the CIDR prefix address with the least significant bits zeroed out" do
      expect(subject.prefix_address).to eq('10.1.1.0')
    end

    context "when initialized with a non-CIDR IP address" do
      let(:address) { '10.1.1.1' }

      subject { described_class.new(address) }

      it "must return the IP address" do
        expect(subject.prefix_address).to eq(address)
      end
    end
  end

  describe "#include?" do
    let(:in_range_ip)     { '10.1.1.2' }
    let(:not_in_range_ip) { '1.1.1.2' }

    context "when given a String" do
      it "must determine if the given String exists within the IP CIDR range" do
        expect(subject.include?(in_range_ip)).to be(true)
        expect(subject.include?(not_in_range_ip)).to be(false)
      end
    end

    context "when given an IPAddr object" do
      let(:in_range_ip)     { IPAddr.new(super()) }
      let(:not_in_range_ip) { IPAddr.new(super()) }

      it "must convert the IPAddr object into a String" do
        expect(subject.include?(in_range_ip)).to be(true)
        expect(subject.include?(not_in_range_ip)).to be(false)
      end
    end
  end

  describe "#==" do
    let(:cidr) { '10.1.1.1/16' }

    subject { described_class.new(cidr) }

    context "when the other IP range is a CIDR range" do
      context "and it has the same range as the CIDR range" do
        let(:other) { described_class.new(cidr) }

        it "must return true" do
          expect(subject == other).to be(true)
        end
      end

      context "but it has a different range compared to the CIDR range" do
        let(:other_cidr) { '1.1.1.1/24' }
        let(:other)      { described_class.new(other_cidr) }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end

      context "but the address family is different in the other CIDR range" do
        let(:other_cidr) { '::ffff:1.1.1.1/24' }
        let(:other)      { described_class.new(other_cidr) }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end
    end

    context "when the other IP range is another kind of object" do
      let(:other) { Object.new }

      it "must return false" do
        expect(subject == other).to be(false)
      end
    end
  end

  describe "#===" do
    let(:cidr) { '10.1.1.1/24' }

    context "when given Ronin::Support::Network::IPRange::CIDR" do
      context "and the other CIDR range is equal to the CIDR range" do
        let(:other) { described_class.new(cidr) }

        it "must return true" do
          expect(subject === other).to be(true)
        end

        context "but one of the CIDR range strings are different, but technically equivalent" do
          let(:other_cidr) { '10.1.1.0/24' }
          let(:other)      { described_class.new(other_cidr) }

          it "must return true" do
            expect(subject === other).to be(true)
          end
        end
      end

      context "and the other CIDR range overlaps with the CIDR range" do
        let(:other_cidr) { '10.1.1.1/25' }
        let(:other)      { described_class.new(other_cidr) }

        it "must return true" do
          expect(subject === other).to be(true)
        end
      end

      context "and the other CIDR range does not overlap with the CIDR range" do
        let(:other_cidr) { '1.1.1.1/24' }
        let(:other)      { described_class.new(other_cidr) }

        it "must return false" do
          expect(subject === other).to be(false)
        end
      end
    end

    context "when given Ronin::Support::Network::IPRange::Glob" do
      context "and the other IP glob range overlaps with the CIDR range" do
        let(:other_glob) { '10.1.1.1-254' }
        let(:other)      { Ronin::Support::Network::IPRange::Glob.new(other_glob) }

        it "must return true" do
          expect(subject === other).to be(true)
        end
      end

      context "and the other IP glob range does not overlap with the CIDR range" do
        let(:other_glob) { '1.1.1.1-254' }
        let(:other)      { Ronin::Support::Network::IPRange::Glob.new(other_glob) }

        it "must return false" do
          expect(subject === other).to be(false)
        end
      end
    end

    context "when given an Enumerable object" do
      let(:other) do
        (0..255).map { |i| "10.1.1.%d" % i }
      end

      context "and when every IP in the Enumerable object is included in the CIDR range" do
        it "must return true" do
          expect(subject === other).to be(true)
        end
      end

      context "but one of the IPs in the Enumerable object is not included in the CIDR range" do
        let(:other) do
          super() + ['10.1.2.1']
        end

        it "must return false" do
          expect(subject === other).to be(false)
        end
      end
    end
  end

  describe "#each" do
    context "when initialized with a class-D IP address" do
      let(:cidr) { '10.1.1.2' }
      subject { described_class.new(cidr) }

      it "must only iterate over one IP address for an address" do
        expect { |b|
          subject.each(&b)
        }.to yield_with_args(cidr)
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
        yielded_addresses = []

        subject.each do |address|
          yielded_addresses << address
        end

        expect(yielded_addresses).to eq(addresses)
      end

      context "when no block is given" do
        it "must return an Enumerator" do
          expect(subject.each.to_a).to eq(addresses)
        end
      end
    end
  end

  describe "#first" do
    let(:cidr) { '10.1.1.0/24' }

    it "must first the first IP address of the CIDR range" do
      expect(subject.first).to eq('10.1.1.0')
    end
  end

  describe "#last" do
    let(:cidr) { '10.1.1.0/24' }

    it "must first the first IP address of the CIDR range" do
      expect(subject.last).to eq('10.1.1.255')
    end
  end

  describe "#size" do
    let(:cidr) { '10.1.1.0/24' }

    it "must return the number of IPs in the CIDR range" do
      expect(subject.size).to eq(256)
    end

    context "when initialized with a non-CIDR IP address" do
      let(:address) { '10.1.1.1' }

      subject { described_class.new(address) }

      it "must return 1" do
        expect(subject.size).to eq(1)
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
