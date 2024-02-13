require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/network/ip_range/glob'
require 'ronin/support/network/ip_range/cidr'

describe Ronin::Support::Network::IPRange::Glob do
  let(:glob) { "10.1.1.*" }

  describe "IPV4_REGEX" do
    subject { described_class::IPV4_REGEX }

    it "must match the full string" do
      expect(' 1.2.3.4 ').to_not match(subject)
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

    it "must match a range of octets within the IPv4 address" do
      expect('1-255.1.1.1').to fully_match(subject)
      expect('1.1-255.1.1').to fully_match(subject)
      expect('1.1.1-255.1').to fully_match(subject)
      expect('1.1.1.1-255').to fully_match(subject)
    end

    it "must match a list of octets within the IPv4 address" do
      expect('1,10,255.1.1.1').to fully_match(subject)
      expect('1.1,10,255.1.1').to fully_match(subject)
      expect('1.1.1,10,255.1').to fully_match(subject)
      expect('1.1.1.1,10,255').to fully_match(subject)
    end

    it "must match a list of octets and octet ranges within the IPv4 address" do
      expect('1,10-20,255.1.1.1').to fully_match(subject)
      expect('1.1,10-20,255.1.1').to fully_match(subject)
      expect('1.1.1,10-20,255.1').to fully_match(subject)
      expect('1.1.1.1,10-20,255').to fully_match(subject)
    end

    it "must match a wildcard '*' octet within the IPv4 address" do
      expect('*.1.1.1').to fully_match(subject)
      expect('1.*.1.1').to fully_match(subject)
      expect('1.1.*.1').to fully_match(subject)
      expect('1.1.1.*').to fully_match(subject)
    end

    it "must not allow a wildcard '*' in octet ranges" do
      expect('1-*.1.1.1').to_not match(subject)
      expect('1.1-*.1.1').to_not match(subject)
      expect('1.1.1-*.1').to_not match(subject)
      expect('1.1.1.1-*').to_not match(subject)
      expect('*-2.1.1.1').to_not match(subject)
      expect('1.*-2.1.1').to_not match(subject)
      expect('1.1.*-2.1').to_not match(subject)
      expect('1.1.1.*-2').to_not match(subject)
    end

    it "must not allow a wildcard '*' in octet lists" do
      expect('1,*,3.1.1.1').to_not match(subject)
      expect('1.1,*,3.1.1').to_not match(subject)
      expect('1.1.1,*,3.1').to_not match(subject)
      expect('1.1.1.1,*,3').to_not match(subject)
    end
  end

  describe "IPV6_REGEX" do
    subject { described_class::IPV6_REGEX }

    it "must match the full string" do
      expect(' 1111:2222:3333:4444:5555:6666:7777:8888 ').to_not match(subject)
    end

    it "must match a fully qualified IPv6 address" do
      expect('1111:2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
    end

    it "must match lowercase hex IPv6 octets" do
      expect('1111:2222:aaaa:bbbb:cccc:dddd:eeee:ffff').to fully_match(subject)
    end

    it "must match uppercase hex IPv6 octets" do
      expect('1111:2222:AAAA:BBBB:CCCC:DDDD:EEEE:FFFF').to fully_match(subject)
    end

    it "must not match octects longer than four characters" do
      expect('11111:2222:3333:4444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:22222:3333:4444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:33333:4444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:44444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:55555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5555:66666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:77777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:88888').to_not match(subject)
    end

    it "must match truncated IPv6 octets" do
      expect('1:2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:8').to fully_match(subject)

      expect('11:2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:22:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:33:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:44:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:55:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:66:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:77:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:88').to fully_match(subject)

      expect('111:2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:888').to fully_match(subject)
    end

    it "must match truncated IPv6 address containing '::'" do
      expect('::1111').to fully_match(subject)
      expect('::1111:2222').to fully_match(subject)
      expect('::1111:2222:3333').to fully_match(subject)
      expect('::1111:2222:3333:4444').to fully_match(subject)
      expect('::1111:2222:3333:4444:5555').to fully_match(subject)
      expect('::1111:2222:3333:4444:5555:6666').to fully_match(subject)
      expect('::1111:2222:3333:4444:5555:6666:7777').to fully_match(subject)
      expect('1111::').to fully_match(subject)
      expect('1111:2222::').to fully_match(subject)
      expect('1111:2222:3333::').to fully_match(subject)
      expect('1111:2222:3333:4444::').to fully_match(subject)
      expect('1111:2222:3333:4444:5555::').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666::').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777::').to fully_match(subject)
      expect('1111::8888').to fully_match(subject)
      expect('1111:2222::8888').to fully_match(subject)
      expect('1111:2222:3333::8888').to fully_match(subject)
      expect('1111:2222:3333:4444::8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555::8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666::8888').to fully_match(subject)
      expect('1111::7777:8888').to fully_match(subject)
      expect('1111::6666:7777:8888').to fully_match(subject)
      expect('1111::5555:6666:7777:8888').to fully_match(subject)
      expect('1111::4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111::3333:4444:5555:6666:7777:8888').to fully_match(subject)
    end

    it "must match a range of octets within the IPv6 address" do
      expect('1-1000:2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2-2000:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3-3000:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4-4000:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5-5000:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6-6000:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7-7000:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:8-8000').to fully_match(subject)
    end

    it "must match a list of octets within the IPv6 address" do
      expect('1,10,100,1000:2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2,20,200,2000:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3,30,300,3000:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4,40,400,4000:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5,50,500,5000:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6,60,600,6000:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7,70,700,7000:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:8,80,800,8000').to fully_match(subject)
    end

    it "must match a list of octets and octet ranges within the IPv6 address" do
      expect('1,10-100,1000:2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2,20-200,2000:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3,30-300,3000:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4,40-400,4000:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5,50-500,5000:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6,60-600,6000:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7,70-700,7000:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:8,80-800,8000').to fully_match(subject)
    end

    it "must match a wildcard '*' octet within the IPv6 address" do
      expect('*:2222:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:*:3333:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:*:4444:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:*:5555:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:*:6666:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:*:7777:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:*:8888').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:*').to fully_match(subject)
    end

    it "must not allow a wildcard '*' in octet ranges" do
      expect('*-10:2222:3333:4444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:*-20:3333:4444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:*-30:4444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:*-40:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:*-50:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5555:*-60:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:*-70:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:*-80').to_not match(subject)
    end

    it "must not allow a wildcard '*' in octet lists" do
      expect('1,*,10:2222:3333:4444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2,*,20:3333:4444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3,*,30:4444:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4,*,40:5555:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5,*,50:6666:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6,*,60:7777:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:7,*,70:8888').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:7777:8,*,80').to_not match(subject)
    end

    it "must match IPv4 mapped IPv6 addresses" do
      expect('::1.2.3.4').to fully_match(subject)
      expect('::1111:1.2.3.4').to fully_match(subject)
      expect('::1111:2222:1.2.3.4').to fully_match(subject)
      expect('::1111:2222:3333:1.2.3.4').to fully_match(subject)
      expect('::1111:2222:3333:4444:1.2.3.4').to fully_match(subject)
      expect('::1111:2222:3333:4444:5555:1.2.3.4').to fully_match(subject)
      expect('1111::1.2.3.4').to fully_match(subject)
      expect('1111:2222::1.2.3.4').to fully_match(subject)
      expect('1111:2222:3333::1.2.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444::1.2.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555::1.2.3.4').to fully_match(subject)
      expect('1111::6666:1.2.3.4').to fully_match(subject)
      expect('1111:2222::6666:1.2.3.4').to fully_match(subject)
      expect('1111:2222:3333::6666:1.2.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444::6666:1.2.3.4').to fully_match(subject)
      expect('1111::5555:6666:1.2.3.4').to fully_match(subject)
      expect('1111::4444:5555:6666:1.2.3.4').to fully_match(subject)
      expect('1111::3333:4444:5555:6666:1.2.3.4').to fully_match(subject)
    end

    it "must match a range of octets within the IPv4 mapped IPv6 address" do
      expect('1111:2222:3333:4444:5555:6666:1-10.2.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2-20.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3-30.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3.4-40').to fully_match(subject)
    end

    it "must match a list of octets within the IPv6 address" do
      expect('1111:2222:3333:4444:5555:6666:1,2,3.2.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2,3,4.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3,4,5.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3.4,5,6').to fully_match(subject)
    end

    it "must match a list of octets and octet ranges within the IPv4 mapped IPv6 address" do
      expect('1111:2222:3333:4444:5555:6666:1,2-20,3.2.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2,3-30,4.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3,4-40,5.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3.4,5-50,6').to fully_match(subject)
    end

    it "must match a wildcard '*' octet within the IPv4 mapped IPv6 address" do
      expect('1111:2222:3333:4444:5555:6666:*.2.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.*.3.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.*.4').to fully_match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3.*').to fully_match(subject)
    end

    it "must not allow a wildcard '*' in octet ranges of IPv4 mapped IPv6 addresses" do
      expect('1111:2222:3333:4444:5555:6666:1-*.2.3.4').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2-*.3.4').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3-*.4').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3.4-*').to_not match(subject)
    end

    it "must not allow a wildcard '*' in octet lists of IPv4 mapped IPv6 addresses" do
      expect('1111:2222:3333:4444:5555:6666:1,*,3.2.3.4').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2,*,3.3.4').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3,*,4.4').to_not match(subject)
      expect('1111:2222:3333:4444:5555:6666:1.2.3.4,*,5').to_not match(subject)
    end
  end

  describe "REGEX" do
    subject { described_class::REGEX }

    it "must match IPv4 glob ranges" do
      expect('1.1-10.2,4,8.*').to fully_match(subject)
    end

    it "must match IPv6 glob ranges" do
      expect('1111:1-ff:2,4,8::*').to fully_match(subject)
    end

    it "must match IPv4-mapped IPv6 glob ranges" do
      expect('::ffff:1.1-10.2,4,8.*').to fully_match(subject)
    end
  end

  describe "#initialize" do
    subject { described_class.new(glob) }

    it "must set #string" do
      expect(subject.string).to eq(glob)
    end

    context "when given an invalid IPv4 glob string" do
      let(:glob) { '1.2.3.4/24' }

      it do
        expect {
          described_class.new(glob)
        }.to raise_error(ArgumentError,"invalid IP-glob range: #{glob.inspect}")
      end
    end

    context "when given an invalid IPv6 glob string" do
      let(:glob) { '::1/64' }

      it do
        expect {
          described_class.new(glob)
        }.to raise_error(ArgumentError,"invalid IP-glob range: #{glob.inspect}")
      end
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
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          (0..0xffff).map { |d| "fe80::abc:%x" % d }
        end

        it "must expand '*' globs to 01-fe" do
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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

  describe "#include?" do
    let(:in_range_ip)     { '10.1.1.2' }
    let(:not_in_range_ip) { '1.1.1.2' }

    context "when given a String" do
      it "must determine if the given String exists within the IP glob range" do
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
    let(:glob) { '10.1.1.*' }

    subject { described_class.new(glob) }

    context "when the other IP range is an IP glob range" do
      context "and it has the same range as the IP glob range" do
        let(:other) { described_class.new(glob) }

        it "must return true" do
          expect(subject == other).to be(true)
        end
      end

      context "but it has a different range from the CIDR range" do
        let(:other_glob) { '1.1.1.*' }
        let(:other)      { described_class.new(other_glob) }

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
    let(:glob) { '10.1.1.*' }

    context "when given #{described_class}" do
      context "and the other IP glob range is equal to the IP glob range" do
        let(:other) { described_class.new(glob) }

        it "must return true" do
          expect(subject === other).to be(true)
        end
      end

      context "and the other IP glob range overlaps with the IP glob range" do
        let(:other_glob) { '10.1.1.1-254' }
        let(:other)      { described_class.new(other_glob) }

        it "must return true" do
          expect(subject === other).to be(true)
        end
      end

      context "and the other IP glob range does not overlap with the IP glob range" do
        let(:other_glob) { '1.1.1.1-254' }
        let(:other)      { described_class.new(other_glob) }

        it "must return false" do
          expect(subject === other).to be(false)
        end
      end
    end

    context "when given Ronin::Support::Network::IPRange::CIDR" do
      context "and the other CIDR range is equal to the IP glob range" do
        let(:other_cidr) { '10.1.1.1/24' }
        let(:other)      { Ronin::Support::Network::IPRange::CIDR.new(other_cidr) }

        it "must return true" do
          expect(subject === other).to be(true)
        end
      end

      context "and the other CIDR range overlaps with the IP glob range" do
        let(:other_cidr) { '10.1.1.1/25' }
        let(:other)      { Ronin::Support::Network::IPRange::CIDR.new(other_cidr) }

        it "must return true" do
          expect(subject === other).to be(true)
        end
      end

      context "and the other CIDR range does not overlap with the IP glob range" do
        let(:other_cidr) { '1.1.1.1/24' }
        let(:other)      { Ronin::Support::Network::IPRange::CIDR.new(other_cidr) }

        it "must return false" do
          expect(subject === other).to be(false)
        end
      end
    end

    context "when given an Enumerable object" do
      let(:other) do
        (0..255).map { |i| "10.1.1.%d" % i }
      end

      context "and when every IP in the Enumerable object is included in the IP glob range" do
        it "must return true" do
          expect(subject === other).to be(true)
        end
      end

      context "but one of the IPs in the Enumerable object is not included in the IP range" do
        let(:other) do
          super() + ['10.1.2.1']
        end

        it "must return false" do
          expect(subject === other).to be(false)
        end
      end
    end

    context "when given another kind of Object" do
      let(:other) { Object.new }

      it "must return false" do
        expect(subject === other).to be(false)
      end
    end
  end

  describe "#each" do
    context "and when the IP address range contains '*'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.*" }
        let(:addresses) do
          (0..255).map { |d| "10.1.1.#{d}" }
        end

        it "must expand '*' globs to 1-254" do
          yielded_addresses = []

          subject.each do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          (0..0xffff).map { |d| "fe80::abc:%x" % d }
        end

        it "must expand '*' globs to 01-fe" do
          yielded_addresses = []

          subject.each do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
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
          yielded_addresses = []

          subject.each do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end
    end
  end

  describe "#first" do
    let(:glob) { '1.1-10,20-40.2,4,8.*' }

    it "must first the first address in the IP glob range" do
      expect(subject.first).to eq('1.1.2.0')
    end
  end

  describe "#last" do
    let(:glob) { '1.1-10,20-40.2,4,8.*' }

    it "must first the first address in the IP glob range" do
      expect(subject.last).to eq('1.40.8.255')
    end
  end

  describe "#size" do
    let(:glob) { '1.1-10,20-40.2,4,8.*' }

    it "must return the number of IPs in the IP glob range" do
      expect(subject.size).to eq((10 + 21) * 3 * 256)
    end

    context "when initialized with a non-globbed IP address" do
      let(:address) { '10.1.1.1' }

      subject { described_class.new(address) }

      it "must return 1" do
        expect(subject.size).to eq(1)
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
