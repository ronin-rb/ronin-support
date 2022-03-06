require 'spec_helper'
require 'ronin/support/network/dns'

require 'ipaddr'

describe Ronin::Support::Network::DNS do
  describe ".nameservers" do
    it "must default to the system's resolv.conf nameserver(s)" do
      expect(subject.nameservers).to eq(
        described_class::Resolver.default_nameservers
      )
    end
  end

  describe ".nameservers=" do
    let(:original_nameservers) { subject.nameservers }

    let(:new_nameservers) { %w[42.42.42.42] }

    it "must override the system's default nameservers" do
      subject.nameservers = new_nameservers

      expect(subject.nameservers).to eq(new_nameservers)
    end

    after { subject.nameservers = original_nameservers }
  end

  describe ".resolver" do
    it "should return #{described_class::Resolver}" do
      expect(subject.resolver).to be_kind_of(described_class::Resolver)
    end

    context "when no arguments are given" do
      it "should default to using DNS.nameserver" do
        resolver = subject.resolver

        expect(resolver.nameservers).to eq(subject.nameservers)
      end
    end

    context "when an argument is given" do
      let(:nameservers) { %w[42.42.42.42] }

      it "must return a #{described_class::Resolver} object with the given nameservers" do
        resolver = subject.resolver(nameservers)

        expect(resolver).to be_kind_of(described_class::Resolver)
        expect(resolver.nameservers).to eq(nameservers)
      end
    end
  end

  describe "helper methods", :network do
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

      context "when given a block" do
        it "must yield the resolved address" do
          expect { |b|
            subject.dns_get_address(hostname,&b)
          }.to yield_successive_args(address)
        end

        it "must not yield unresolved addresses" do
          expect { |b|
            subject.dns_get_address(bad_hostname,&b)
          }.to_not yield_control
        end
      end
    end

    describe "#dns_get_addresses" do
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

      context "when given a block" do
        it "should yield the resolved address" do
          expect { |b|
            subject.dns_get_addresses(hostname,&b)
          }.to yield_successive_args(address)
        end

        it "should not yield unresolved addresses" do
          expect { |b|
            subject.dns_get_addresses(bad_hostname,&b)
          }.to_not yield_control
        end
      end
    end

    describe "#dns_get_name" do
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

      context "when given a block" do
        it "should yield the resolved hostname" do
          expect { |b|
            subject.dns_get_name(reverse_address,&b)
          }.to yield_successive_args(reverse_hostname)
        end

        it "should not yield unresolved hostnames" do
          resolved_hostname = nil

          expect { |b|
            subject.dns_get_name(bad_address,&b)
          }.to_not yield_control
        end
      end
    end

    describe "#dns_get_names" do
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

      context "when given a block" do
        it "should yield the resolved hostnames" do
          expect { |b|
            subject.dns_get_names(reverse_address,&b)
          }.to yield_successive_args(reverse_hostname)
        end

        it "should not yield unresolved hostnames" do
          expect { |b|
            subject.dns_get_names(bad_address,&b)
          }.to_not yield_control
        end
      end
    end
  end
end
