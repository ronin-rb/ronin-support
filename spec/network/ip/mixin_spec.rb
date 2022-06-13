require 'spec_helper'
require 'ronin/support/network/ip/mixin'

describe Ronin::Support::Network::IP::Mixin do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe ".public_address" do
    context "integration", :network do
      it "must determine our public facing IP Address", :network do
        public_address = subject.public_address
        expect(public_address).to be_kind_of(String)

        public_address = Addrinfo.ip(public_address)
        expect(public_address.ipv4_private?).to be(false)
        expect(public_address.ipv4_loopback?).to be(false)
        expect(public_address.ipv6_linklocal?).to be(false)
        expect(public_address.ipv6_loopback?).to be(false)
      end
    end

    let(:public_address) { '1.2.3.4' }
    let(:response) do
      double('Net::HTTPOK', code: '200', body: public_address)
    end

    it "must make a HTTP request to https://ipinfo.io/ip" do
      expect(Net::HTTP).to receive(:get_response).with(Ronin::Support::Network::IP::IPINFO_URI).and_return(response)

      expect(subject.public_address).to eq(public_address)
    end

    context "when the HTTP response status is not 200" do
      let(:response) { double('Net::HTTPServerError', code: '500') }

      before do
        allow(Net::HTTP).to receive(:get_response).with(
          Ronin::Support::Network::IP::IPINFO_URI
        ).and_return(response)
      end

      it "must return nil" do
        expect(subject.public_address).to be(nil)
      end
    end

    context "when a network exception is raised" do
      before do
        allow(Net::HTTP).to receive(:get_response) do
          raise(SocketError,"ailed to open TCP connection to ipinfo.io:443 (getaddrinfo: Name or service not known)")
        end
      end

      it "must return nil" do
        expect(subject.public_address).to be(nil)
      end
    end
  end

  describe ".public_ip" do
    let(:public_address) { '1.2.3.4' }
    let(:response) do
      double('Net::HTTPOK', code: '200', body: public_address)
    end

    it "must call .public_address" do
      expect(Net::HTTP).to receive(:get_response).with(Ronin::Support::Network::IP::IPINFO_URI).and_return(response)

      public_ip = subject.public_ip

      expect(public_ip).to be_kind_of(Ronin::Support::Network::IP)
      expect(public_ip.address).to eq(public_address)
    end

    context "when https://ipinfo.io/ip does not return an IP" do
      before do
        expect(Ronin::Support::Network::IP).to receive(:public_address).and_return(nil)
      end

      it "must return nil" do
        expect(subject.public_ip).to be(nil)
      end
    end
  end

  describe ".local_addresses" do
    it "must return the local addresses as Strings" do
      addresses = subject.local_addresses

      expect(addresses).to all(be_kind_of(String))

      ips = addresses.map { |address| Addrinfo.ip(address) }

      expect(ips).to all(satisfy { |ip|
        ip.ipv4_private?   ||
        ip.ipv4_loopback?  ||
        ip.ipv6_linklocal? ||
        ip.ipv6_loopback?
      })
    end

    it "must remove any '%iface' suffixes from the IP addresses" do
      addresses = subject.local_addresses

      expect(addresses).to all(satisfy { |address|
        !(address =~ /%.+$/)
      })
    end
  end

  describe ".local_ips" do
    it "must return the local addresses as Ronin::Support::Network::IP objects" do
      ips = subject.local_ips

      expect(ips).to all(be_kind_of(Ronin::Support::Network::IP))
      expect(ips).to all(satisfy { |ip|
        ip.private?   ||
        ip.loopback?  ||
        ip.link_local?
      })
    end
  end

  describe ".local_address" do
    it "must return the first local address" do
      expect(subject.local_address).to eq(subject.local_addresses.first)
    end
  end

  describe ".local_ip" do
    it "must return the first local Ronin::Support::Network::IP" do
      expect(subject.local_ip).to eq(subject.local_ips.first)
    end
  end
end
