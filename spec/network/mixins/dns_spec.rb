require 'spec_helper'
require 'ronin/support/network/mixins/dns'

require 'ipaddr'

describe Ronin::Support::Network::Mixins::DNS do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#dns_resolver" do
    context "when given no arguments" do
      it "must return a Ronin::Support::Network::DNS::Resolver" do
        expect(subject.dns_resolver).to be_kind_of(
          Ronin::Support::Network::DNS::Resolver
        )
      end

      it "must set the resolver's #nameservers to Network::DNS.nameservers" do
        expect(subject.dns_resolver.nameservers).to eq(
          Ronin::Support::Network::DNS.nameservers
        )
      end

      context "but when #dns_nameservers has been set" do
        let(:nameservers) { ['1.1.1.1', '4.2.2.1'] }

        before do
          subject.dns_nameservers = nameservers
        end

        it "must set the resolver's #nameservers to #dns_nameservers" do
          expect(subject.dns_resolver.nameservers).to eq(nameservers)
        end
      end
    end

    context "when given the nameservers: keyword argument" do
      let(:nameservers) { ['1.1.1.1', '4.2.2.1'] }

      subject { super().dns_resolver(nameservers: nameservers) }

      it "must return a Ronin::Support::Network::DNS::Resolver" do
        expect(subject).to be_kind_of(
          Ronin::Support::Network::DNS::Resolver
        )
      end

      it "must set the resolver's #nameservers to the custom nameservers" do
        expect(subject.nameservers).to eq(nameservers)
      end
    end

    context "when given the nameserver: keyword argument" do
      let(:nameserver) { '1.1.1.1' }

      subject { super().dns_resolver(nameserver: nameserver) }

      it "must return a Ronin::Support::Network::DNS::Resolver" do
        expect(subject).to be_kind_of(
          Ronin::Support::Network::DNS::Resolver
        )
      end

      it "must set the resolver's #nameservers to the custom nameserver" do
        expect(subject.nameservers).to eq([nameserver])
      end
    end
  end

  describe ".dns_nameservers=" do
    let(:new_nameservers) { ['1.1.1.1', '42.42.42.42'] }

    before do
      subject.dns_nameservers = new_nameservers
    end

    it "must override the system's default nameservers to the new nameserver" do
      expect(subject.dns_nameservers).to eq(new_nameservers)
    end

    it "must set the default resolver's #nameservers" do
      expect(subject.dns_resolver.nameservers).to eq(new_nameservers)
    end
  end

  describe ".nameserver=" do
    let(:new_nameserver) { '42.42.42.42' }

    before do
      subject.dns_nameserver = new_nameserver
    end

    it "must override the system's default nameservers to the new nameserver" do
      expect(subject.dns_nameservers).to eq([new_nameserver])
    end

    it "must set the default resolver's #nameservers" do
      expect(subject.dns_resolver.nameservers).to eq([new_nameserver])
    end
  end

  let(:nameservers)      { ['8.8.8.8', '1.1.1.1'] }
  let(:nameserver)       { '8.8.8.8' }
  let(:hostname)         { 'example.com' }
  let(:bad_hostname)     { 'foo.bar' }
  let(:address)          { '93.184.216.34' }
  let(:bad_address)      { '0.0.0.0' }
  let(:reverse_address)  { '192.0.43.10' }
  let(:reverse_ipaddr)   { IPAddr.new(reverse_address) }
  let(:reverse_hostname) { '43-10.any.icann.org' }

  describe "#dns_get_address" do
    context "integration", :network do
      it "should lookup the address for a hostname" do
        expect(subject.dns_get_address(hostname)).to eq(address)
      end

      context "when given a non-String hostname" do
        it "should query the non-String hostname" do
          expect(subject.dns_get_address(hostname.to_sym)).to eq(address)
        end
      end

      context "when given the nameservers: keyword argument" do
        it "should query the nameservers" do
          expect(subject.dns_get_address(hostname, nameservers: nameservers)).to eq(address)
        end
      end

      context "when given the nameserver: keyword argument" do
        it "should query the nameserver" do
          expect(subject.dns_get_address(hostname, nameserver: nameserver)).to eq(address)
        end
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

      context "when given a non-String hostname" do
        it "should query the non-String hostname" do
          expect(subject.dns_get_addresses(hostname.to_sym)).to include(address)
        end
      end

      context "when given the nameservers: keyword argument" do
        it "should query the nameservers" do
          expect(subject.dns_get_addresses(hostname, nameservers: nameservers)).to include(address)
        end
      end

      context "when given the nameserver: keyword argument" do
        it "should query the nameserver" do
          expect(subject.dns_get_addresses(hostname, nameserver: nameserver)).to include(address)
        end
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

      context "when given a non-String hostname" do
        it "should query the non-String hostname" do
          expect(subject.dns_get_name(reverse_ipaddr)).to eq(reverse_hostname)
        end
      end

      context "when given the nameservers: keyword argument" do
        it "should query the nameservers" do
          expect(subject.dns_get_name(reverse_address, nameservers: nameservers)).to eq(reverse_hostname)
        end
      end

      context "when given the nameserver: keyword argument" do
        it "should query the nameserver" do
          expect(subject.dns_get_name(reverse_address, nameserver: nameserver)).to eq(reverse_hostname)
        end
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

      context "when given a non-String hostname" do
        it "should query the non-String hostname" do
          expect(subject.dns_get_names(reverse_ipaddr)).to include(reverse_hostname)
        end
      end

      context "when given the nameservers: keyword argument" do
        it "should query the nameservers" do
          expect(subject.dns_get_names(reverse_address, nameservers: nameservers)).to include(reverse_hostname)
        end
      end

      context "when given the nameserver: keyword argument" do
        it "should query the nameserver" do
          expect(subject.dns_get_names(reverse_address, nameserver: nameserver)).to include(reverse_hostname)
        end
      end

      context "when the IP address has no host names associated with it" do
        it "should return an empty Array for unknown hostnames" do
          expect(subject.dns_get_names(bad_address)).to eq([])
        end
      end
    end
  end
end
