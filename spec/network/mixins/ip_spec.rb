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

  describe "helper methods", :network do
    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    describe "#public_ip" do
      it "should determine our public facing IP Address" do
        expect(subject.public_ip).to_not be(nil)
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
        expect(subject.local_ip).to be_kind_of(String)
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

    describe "#ip" do
      it "must return either #public_ip or #local_ip" do
        expect(subject.ip).to eq(subject.public_ip).or(eq(subject.local_ip))
      end

      context "when #public_ip raises an exception" do
        before do
          allow(Net::HTTP).to receive(:get_response) do
            raise(SocketError,"ailed to open TCP connection to ipinfo.io:443 (getaddrinfo: Name or service not known)")
          end
        end

        it "must fallback to #local_ip" do
          expect(subject.ip).to eq(subject.local_ip)
        end
      end
    end
  end
end
