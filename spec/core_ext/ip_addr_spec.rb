require 'spec_helper'
require 'ronin/support/core_ext/ip_addr'

describe IPAddr do
  describe "extract" do
    context "IPv4" do
      it "should extract a single IPv4 address" do
        addr = '127.0.0.1'

        expect(IPAddr.extract(addr,:ipv4)).to eq([addr])
      end

      it "should extract multiple IPv4 addresses" do
        addrs = %w[127.0.0.1 192.168.0.1]
        text = "#{addrs[0]} #{addrs[1]}"

        expect(IPAddr.extract(text,:ipv4)).to eq(addrs)
      end

      it "should extract IPv4 addresses from text" do
        addr = '127.0.0.1'
        text = "ip (#{addr})"

        expect(IPAddr.extract(text,:ipv4)).to eq([addr])
      end

      it "should ignore leading periods" do
        addr = '127.0.0.1'
        text = ".#{addr}"

        expect(IPAddr.extract(text,:ipv4)).to eq([addr])
      end

      it "should ignore tailing periods" do
        addr = '127.0.0.1'
        text = "#{addr}."

        expect(IPAddr.extract(text,:ipv4)).to eq([addr])
      end

      it "should ignore less than 3 octet IPv4 addresses" do
        text = '127.0.0. 1'

        expect(IPAddr.extract(text,:ipv4)).to be_empty
      end

      it "should ignore IPv4 addresses with more than 3 diget octets" do
        text = '127.1111.0.1'

        expect(IPAddr.extract(text,:ipv4)).to be_empty
      end
    end

    context "IPv6" do
      it "should extract a single IPv6 address" do
        addr = 'fe80:0000:0000:0000:0204:61ff:fe9d:f156'

        expect(IPAddr.extract(addr,:ipv6)).to eq([addr])
      end

      it "should extract multiple IPv6 addresses" do
        addrs = %w[::1 fe80:0000:0000:0000:0204:61ff:fe9d:f156]
        text = "#{addrs[0]} #{addrs[1]}"

        expect(IPAddr.extract(text,:ipv6)).to eq(addrs)
      end

      it "should extract collapsed IPv6 addresses" do
        addr = 'fe80::0204:61ff:fe9d:f156'
        text = "ipv6: #{addr}"

        expect(IPAddr.extract(text,:ipv6)).to eq([addr])
      end

      it "should extract IPv6 addresses from text" do
        addr = 'fe80:0000:0000:0000:0204:61ff:fe9d:f156'
        text = "hello #{addr} world"

        expect(IPAddr.extract(text,:ipv6)).to eq([addr])
      end

      it "should extract trailing IPv4 suffixes" do
        addr = '::ffff:192.0.2.128'
        text = "#{addr} 1.1.1.1"

        expect(IPAddr.extract(text,:ipv6)).to eq([addr])
      end

      it "should extract short-hand IPv6 addresses" do
        addr = '::f0:0d'
        text = "ipv6: #{addr}"

        expect(IPAddr.extract(text,:ipv6)).to eq([addr])
      end
    end

    it "should extract both IPv4 and IPv6 addresses" do
      ipv4 = '127.0.0.1'
      ipv6 = '::1'
      text = "ipv4: #{ipv4}, ipv6: #{ipv6}"

      expect(IPAddr.extract(text)).to eq([ipv4, ipv6])
    end

    it "should ignore non-IP addresses" do
      text = 'one: two.three.'

      expect(IPAddr.extract(text)).to be_empty
    end
  end

  describe "each" do
    context "CIDR addresses" do
      let(:fixed_addr) { IPAddr.new('10.1.1.2') }
      let(:class_c) { IPAddr.new('10.1.1.2/24') }

      it "should only iterate over one IP address for an address" do
        addresses = fixed_addr.map { |ip| IPAddr.new(ip) }

        expect(addresses.length).to eq(1)
        expect(fixed_addr).to include(addresses.first)
      end

      it "should iterate over all IP addresses contained within the IP range" do
        class_c.each do |ip|
          expect(class_c).to include(IPAddr.new(ip))
        end
      end

      it "should return an Enumerator when no block is given" do
        expect(class_c.each.all? { |ip|
          class_c.include?(IPAddr.new(ip))
        }).to be(true)
      end
    end

    context "globbed addresses" do
      let(:ipv4_range) { '10.1.1-5.1' }
      let(:ipv6_range) { '::ff::02-0a::c3' }

      it "should expand '*' ranges" do
        octets = IPAddr.each("10.1.1.*").map { |ip| ip.split('.',4).last }

        expect(octets).to eq(('1'..'254').to_a)
      end

      it "should expend 'i-j' ranges" do
        octets = IPAddr.each("10.1.1.10-20").map { |ip| ip.split('.',4).last }

        expect(octets).to eq(('10'..'20').to_a)
      end

      it "should expand 'i,j,k' ranges" do
        octets = IPAddr.each("10.1.1.1,2,3").map { |ip| ip.split('.',4).last }

        expect(octets).to eq(['1', '2', '3'])
      end

      it "should expand combination 'i,j-k' ranges" do
        octets = IPAddr.each("10.1.1.1,3-4").map { |ip| ip.split('.',4).last }

        expect(octets).to eq(['1', '3', '4'])
      end

      it "should iterate over all IP addresses in an IPv4 range" do
        IPAddr.each(ipv4_range) do |ip|
          expect(ip).to match(/^10\.1\.[1-5]\.1$/)
        end
      end

      it "should iterate over all IP addresses in an IPv6 range" do
        IPAddr.each(ipv6_range) do |ip|
          expect(ip).to match(/^::ff::0[2-9a]::c3$/)
        end
      end

      it "should return an Enumerator when no block is given" do
        ips = IPAddr.each(ipv4_range)

        expect(ips.all? { |ip| ip =~ /^10\.1\.[1-5]\.1$/ }).to be(true)
      end
    end
  end

  let(:ip) { IPAddr.new('127.0.0.1') }
  let(:bad_ip) { IPAddr.new('0.0.0.0') }

  describe "#lookup" do
    context "integration", :network do
      let(:nameserver) { '4.2.2.1' }

      it "should lookup the host-name for an IP" do
        expect(ip.lookup).to include('localhost')
      end

      it "may lookup host-names via other nameservers" do
        expect(ip.lookup(nameserver)).to be_empty
      end

      it "should return an empty Array for unknown IP addresses" do
        expect(bad_ip.lookup).to be_empty
      end
    end
  end
end
