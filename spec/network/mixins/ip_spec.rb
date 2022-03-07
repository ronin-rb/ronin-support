require 'spec_helper'
require 'ronin/support/network/mixins/ip'

describe Ronin::Support::Network::Mixins::IP do
  describe "IPINFO_URI" do
    subject { described_class::IPINFO_URI }

    it "must return a URI for 'https://ipinfo.io/ip'" do
      expect(subject).to be_kind_of(URI::HTTPS)
      expect(subject.to_s).to eq('https://ipinfo.io/ip')
    end
  end

  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#public_ip" do
    context "integration", :network do
      it "must determine our public facing IP Address", :network do
        public_ip = subject.public_ip
        expect(public_ip).to be_kind_of(String)

        public_address = Addrinfo.ip(public_ip)
        expect(public_address.ipv4_private?).to be(false)
        expect(public_address.ipv4_loopback?).to be(false)
        expect(public_address.ipv6_linklocal?).to be(false)
        expect(public_address.ipv6_loopback?).to be(false)
      end
    end

    let(:public_ip) { '1.2.3.4' }
    let(:response) do
      double('Net::HTTPOK', code: '200', body: public_ip)
    end

    it "must make a HTTP request to https://ipinfo.io/ip" do
      expect(Net::HTTP).to receive(:get_response).with(described_class::IPINFO_URI).and_return(response)

      expect(subject.public_ip).to eq(public_ip)
    end

    context "when the HTTP response status is not 200" do
      let(:response) { double('Net::HTTPServerError', code: '500') }

      before do
        allow(Net::HTTP).to receive(:get_response).with(
          described_class::IPINFO_URI
        ).and_return(response)
      end

      it "must return nil" do
        expect(subject.public_ip).to be(nil)
      end
    end

    context "when a network exception is raised" do
      before do
        allow(Net::HTTP).to receive(:get_response) do
          raise(SocketError,"ailed to open TCP connection to ipinfo.io:443 (getaddrinfo: Name or service not known)")
        end
      end

      it "must return nil" do
        expect(subject.public_ip).to be(nil)
      end
    end
  end

  describe "#local_ip" do
    it "should determine our internal IP address" do
      local_ip = subject.local_ip

      expect(local_ip).to be_kind_of(String)

      local_address = Addrinfo.ip(local_ip)
      expect(local_address).to be_ipv4_private.or(
        be_ipv4_loopback
      ).or(
        be_ipv6_linklocal
      ).or(
        be_ipv6_loopback
      )
    end

    context "when the host has an IPv4 private address" do
      let(:ipv4_private_address)  { '192.168.1.42' }
      let(:ipv4_loopback_address) { '127.0.0.1'    }
      let(:addresses) do
        [
          Addrinfo.ip(ipv4_loopback_address),
          Addrinfo.ip(ipv4_private_address)
        ]
      end

      before do
        allow(Socket).to receive(:ip_address_list).and_return(addresses)
      end

      it "must return the IPv4 private address instead of the loopback" do
        expect(subject.local_ip).to eq(ipv4_private_address)
      end
    end

    context "when the host has no IPv4 private address" do
      context "but has a IPv6 link-local address" do
        let(:ipv6_private_address)  { 'fe80::1111:2222:3333' }
        let(:ipv6_loopback_address) { '::1' }
        let(:addresses) do
          [
            Addrinfo.ip(ipv6_loopback_address),
            Addrinfo.ip(ipv6_private_address)
          ]
        end

        before do
          allow(Socket).to receive(:ip_address_list).and_return(addresses)
        end

        it "must return the IPv6 link-local address" do
          expect(subject.local_ip).to eq(ipv6_private_address)
        end
      end

      context "but has no IPv6 link-local address" do
        let(:ipv6_loopback_address) { '::1' }
        let(:addresses) do
          [Addrinfo.ip(ipv6_loopback_address)]
        end

        before do
          allow(Socket).to receive(:ip_address_list).and_return(addresses)
        end

        it "must return the IPv6 loopback address instead" do
          expect(subject.local_ip).to eq(ipv6_loopback_address)
        end
      end

      context "but has no IPv6 addresses" do
        let(:ipv4_loopback_address) { '127.0.0.1' }
        let(:addresses) do
          [Addrinfo.ip(ipv4_loopback_address)]
        end

        before do
          allow(Socket).to receive(:ip_address_list).and_return(addresses)
        end

        it "must return the IPv4 loopback address instead" do
          expect(subject.local_ip).to eq(ipv4_loopback_address)
        end
      end
    end
  end

  describe "#current_ip" do
    context "integration", :network do
      it "must return either #public_ip or #local_ip" do
        expect(subject.current_ip).to eq(subject.public_ip).or(
          eq(subject.local_ip)
        )
      end
    end

    context "when #public_ip returns a String" do
      let(:public_ip) { double('public_ip') }

      before do
        allow(subject).to receive(:public_ip).and_return(public_ip)
      end

      it "must return #public_ip" do
        expect(subject.current_ip).to eq(public_ip)
      end
    end

    context "when #public_ip returns nil" do
      let(:local_ip) { double('local_ip') }

      before do
        allow(subject).to receive(:public_ip).and_return(nil)
        allow(subject).to receive(:local_ip).and_return(local_ip)
      end

      it "must fallback to #local_ip" do
        expect(subject.current_ip).to eq(local_ip)
      end
    end
  end
end
