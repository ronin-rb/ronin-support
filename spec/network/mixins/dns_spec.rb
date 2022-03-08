require 'spec_helper'
require 'ronin/support/network/mixins/dns'

require 'ipaddr'

describe Ronin::Support::Network::Mixins::DNS do
  let(:nameservers)      { %w[8.8.8.8] }
  let(:hostname)         { 'example.com' }
  let(:bad_hostname)     { 'foo.bar' }
  let(:address)          { '93.184.216.34' }
  let(:bad_address)      { '0.0.0.0' }
  let(:reverse_address)  { '192.0.43.10' }
  let(:reverse_ipaddr)   { IPAddr.new(reverse_address) }
  let(:reverse_hostname) { '43-10.any.icann.org' }

  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#dns_get_address" do
    context "integration", :network do
      it "should lookup the address for a hostname" do
        expect(subject.dns_get_address(hostname)).to eq(address)
      end

      it "should accept non-String hostnames" do
        expect(subject.dns_get_address(hostname.to_sym)).to eq(address)
      end

      it "should accept an additional nameserver argument" do
        expect(subject.dns_get_address(hostname, nameservers: nameservers)).to eq(address)
      end

      context "when the host nmae has no IP addresses" do
        it "should return nil for unknown hostnames" do
          expect(subject.dns_get_address(bad_hostname)).to be(nil)
        end
      end
    end
  end

  describe "#dns_get_addresses" do
    context "integration", :network do
      it "should lookup all addresses for a hostname" do
        expect(subject.dns_get_addresses(hostname)).to include(address)
      end

      it "should accept non-String hostnames" do
        expect(subject.dns_get_addresses(hostname.to_sym)).to include(address)
      end

      it "should accept an additional nameserver argument" do
        expect(subject.dns_get_addresses(hostname, nameservers: nameservers)).to include(address)
      end

      context "when the host nmae has no IP addresses" do
        it "should return an empty Array for unknown hostnames" do
          expect(subject.dns_get_addresses(bad_hostname)).to eq([])
        end
      end
    end
  end

  describe "#dns_get_name" do
    context "integration", :network do
      it "should lookup the address for a hostname" do
        expect(subject.dns_get_name(reverse_address)).to eq(reverse_hostname)
      end

      it "should accept non-String addresses" do
        expect(subject.dns_get_name(reverse_ipaddr)).to eq(reverse_hostname)
      end

      it "should accept an additional nameserver argument" do
        expect(subject.dns_get_name(reverse_address, nameservers: nameservers)).to eq(reverse_hostname)
      end

      context "when the IP address has no host names associated with it" do
        it "should return nil for unknown hostnames" do
          expect(subject.dns_get_name(bad_address)).to be(nil)
        end
      end
    end
  end

  describe "#dns_get_names" do
    context "integration", :network do
      it "should lookup all addresses for a hostname" do
        expect(subject.dns_get_names(reverse_address)).to include(reverse_hostname)
      end

      it "should accept non-String addresses" do
        expect(subject.dns_get_names(reverse_ipaddr)).to include(reverse_hostname)
      end

      it "should accept an additional nameserver argument" do
        expect(subject.dns_get_names(reverse_address, nameservers: nameservers)).to include(reverse_hostname)
      end

      context "when the IP address has no host names associated with it" do
        it "should return an empty Array for unknown hostnames" do
          expect(subject.dns_get_names(bad_address)).to eq([])
        end
      end
    end
  end
end
