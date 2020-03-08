require 'spec_helper'
require 'ronin/network/dns'

require 'ipaddr'

describe Network::DNS do
  let(:server) { '4.2.2.1' }

  describe "nameserver" do
    it "should be nil by default" do
      expect(subject.nameserver).to be_nil
    end
  end

  describe "nameserver=" do
    it "should accept Strings" do
      subject.nameserver = server

      expect(subject.nameserver).to eq(server)
    end

    it "should accept nil" do
      subject.nameserver = server
      subject.nameserver = nil

      expect(subject.nameserver).to be_nil
    end

    it "should convert non-nil values to Strings" do
      subject.nameserver = IPAddr.new(server)

      expect(subject.nameserver).to eq(server)
    end
  end

  describe "#dns_resolver" do
    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    it "should return Resolv when passed no nameserver" do
      expect(subject.dns_resolver(nil)).to eq(Resolv)
    end

    it "should return Resolv::DNS when passed a nameserver" do
      expect(subject.dns_resolver(server)).to be_kind_of(Resolv::DNS)
    end
  end

  describe "helper methods", :network do
    let(:hostname)         { 'example.com' }
    let(:bad_hostname)     { 'foo.bar' }
    let(:address)          { '192.0.43.10' }
    let(:bad_address)      { '0.0.0.0' }
    let(:reverse_hostname) { '43-10.any.icann.org' }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    describe "#dns_lookup" do
      it "should lookup the address for a hostname" do
        expect(subject.dns_lookup(hostname)).to eq(address)
      end

      it "should return nil for unknown hostnames" do
        expect(subject.dns_lookup(bad_hostname)).to be_nil
      end

      it "should accept non-String hostnames" do
        expect(subject.dns_lookup(hostname.to_sym)).to eq(address)
      end

      it "should accept an additional nameserver argument" do
        expect(subject.dns_lookup(hostname,server)).to eq(address)
      end

      context "when given a block" do
        it "should yield the resolved address" do
          resolved_address = nil

          subject.dns_lookup(hostname) do |address|
            resolved_address = address
          end

          expect(resolved_address).to eq(address)
        end

        it "should not yield unresolved addresses" do
          resolved_address = nil

          subject.dns_lookup(bad_hostname) do |address|
            resolved_address = address
          end

          expect(resolved_address).to be_nil
        end
      end
    end

    describe "#dns_lookup_all" do
      it "should lookup all addresses for a hostname" do
        expect(subject.dns_lookup_all(hostname)).to include(address)
      end

      it "should return an empty Array for unknown hostnames" do
        expect(subject.dns_lookup_all(bad_hostname)).to eq([])
      end

      it "should accept non-String hostnames" do
        expect(subject.dns_lookup_all(hostname.to_sym)).to include(address)
      end

      it "should accept an additional nameserver argument" do
        expect(subject.dns_lookup_all(hostname,server)).to include(address)
      end

      context "when given a block" do
        it "should yield the resolved address" do
          expect(subject.enum_for(:dns_lookup,hostname).to_a).to eq([address])
        end

        it "should not yield unresolved addresses" do
          expect(subject.enum_for(:dns_lookup,bad_hostname).to_a).to eq([])
        end
      end
    end

    describe "#dns_reverse_lookup" do
      it "should lookup the address for a hostname" do
        expect(subject.dns_reverse_lookup(address)).to eq(reverse_hostname)
      end

      it "should return nil for unknown hostnames" do
        expect(subject.dns_reverse_lookup(bad_address)).to be_nil
      end

      it "should accept non-String addresses" do
        expect(subject.dns_reverse_lookup(IPAddr.new(address))).to eq(reverse_hostname)
      end

      it "should accept an additional nameserver argument" do
        expect(subject.dns_reverse_lookup(address,server)).to eq(reverse_hostname)
      end

      context "when given a block" do
        it "should yield the resolved hostname" do
          resolved_hostname = nil

          subject.dns_reverse_lookup(address) do |hostname|
            resolved_hostname = hostname
          end

          expect(resolved_hostname).to eq(reverse_hostname)
        end

        it "should not yield unresolved hostnames" do
          resolved_hostname = nil

          subject.dns_reverse_lookup(bad_address) do |hostname|
            resolved_hostname = hostname
          end

          expect(resolved_hostname).to be_nil
        end
      end
    end

    describe "#dns_reverse_lookup_all" do
      it "should lookup all addresses for a hostname" do
        expect(subject.dns_reverse_lookup_all(address)).to include(reverse_hostname)
      end

      it "should return an empty Array for unknown hostnames" do
        expect(subject.dns_reverse_lookup_all(bad_address)).to eq([])
      end

      it "should accept non-String addresses" do
        expect(subject.dns_reverse_lookup_all(IPAddr.new(address))).to include(reverse_hostname)
      end

      it "should accept an additional nameserver argument" do
        expect(subject.dns_reverse_lookup_all(address,server)).to include(reverse_hostname)
      end

      context "when given a block" do
        it "should yield the resolved hostnames" do
          expect(subject.enum_for(:dns_reverse_lookup_all,address).to_a).to eq([reverse_hostname])
        end

        it "should not yield unresolved hostnames" do
          expect(subject.enum_for(:dns_reverse_lookup_all,bad_address).to_a).to eq([])
        end
      end
    end
  end
end
