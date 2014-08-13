require 'spec_helper'
require 'ronin/network/dns'

require 'ipaddr'

describe Network::DNS do
  let(:server) { '4.2.2.1' }

  describe "nameserver" do
    it "should be nil by default" do
      subject.nameserver.should be_nil
    end
  end

  describe "nameserver=" do
    it "should accept Strings" do
      subject.nameserver = server

      subject.nameserver.should == server
    end

    it "should accept nil" do
      subject.nameserver = server
      subject.nameserver = nil

      subject.nameserver.should be_nil
    end

    it "should convert non-nil values to Strings" do
      subject.nameserver = IPAddr.new(server)

      subject.nameserver.should == server
    end

    after { subject.nameserver = [] }
  end

  describe "resolver" do
    it "should return Resolv::DNS" do
      subject.resolver(server).should be_kind_of(Resolv::DNS)
    end

    context "when no arguments are given" do
      before { subject.nameserver = server }

      it "should default to using DNS.nameserver" do
        Resolv::DNS.should_receive(:new).with(nameserver: subject.nameserver)

        subject.resolver
      end

      after { subject.nameserver = nil }
    end

    context "when an argument is given" do
      it "should pass the nameserver: option to Resolv::DNS.new" do
        Resolv::DNS.should_receive(:new).with(nameserver: server)

        subject.resolver(server)
      end
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
        subject.dns_lookup(hostname).should == address
      end

      it "should return nil for unknown hostnames" do
        subject.dns_lookup(bad_hostname).should be_nil
      end

      it "should accept non-String hostnames" do
        subject.dns_lookup(hostname.to_sym).should == address
      end

      it "should accept an additional nameserver argument" do
        subject.dns_lookup(hostname,server).should == address
      end

      context "when given a block" do
        it "should yield the resolved address" do
          resolved_address = nil

          subject.dns_lookup(hostname) do |address|
            resolved_address = address
          end

          resolved_address.should == address
        end

        it "should not yield unresolved addresses" do
          resolved_address = nil

          subject.dns_lookup(bad_hostname) do |address|
            resolved_address = address
          end

          resolved_address.should be_nil
        end
      end
    end

    describe "#dns_lookup_all" do
      it "should lookup all addresses for a hostname" do
        subject.dns_lookup_all(hostname).should include(address)
      end

      it "should return an empty Array for unknown hostnames" do
        subject.dns_lookup_all(bad_hostname).should == []
      end

      it "should accept non-String hostnames" do
        subject.dns_lookup_all(hostname.to_sym).should include(address)
      end

      it "should accept an additional nameserver argument" do
        subject.dns_lookup_all(hostname,server).should include(address)
      end

      context "when given a block" do
        it "should yield the resolved address" do
          subject.enum_for(:dns_lookup,hostname).to_a.should == [address]
        end

        it "should not yield unresolved addresses" do
          subject.enum_for(:dns_lookup,bad_hostname).to_a.should == []
        end
      end
    end

    describe "#dns_reverse_lookup" do
      it "should lookup the address for a hostname" do
        subject.dns_reverse_lookup(address).should == reverse_hostname
      end

      it "should return nil for unknown hostnames" do
        subject.dns_reverse_lookup(bad_address).should be_nil
      end

      it "should accept non-String addresses" do
        subject.dns_reverse_lookup(IPAddr.new(address)).should == reverse_hostname
      end

      it "should accept an additional nameserver argument" do
        subject.dns_reverse_lookup(address,server).should == reverse_hostname
      end

      context "when given a block" do
        it "should yield the resolved hostname" do
          resolved_hostname = nil

          subject.dns_reverse_lookup(address) do |hostname|
            resolved_hostname = hostname
          end

          resolved_hostname.should == reverse_hostname
        end

        it "should not yield unresolved hostnames" do
          resolved_hostname = nil

          subject.dns_reverse_lookup(bad_address) do |hostname|
            resolved_hostname = hostname
          end

          resolved_hostname.should be_nil
        end
      end
    end

    describe "#dns_reverse_lookup_all" do
      it "should lookup all addresses for a hostname" do
        subject.dns_reverse_lookup_all(address).should include(reverse_hostname)
      end

      it "should return an empty Array for unknown hostnames" do
        subject.dns_reverse_lookup_all(bad_address).should == []
      end

      it "should accept non-String addresses" do
        subject.dns_reverse_lookup_all(IPAddr.new(address)).should include(reverse_hostname)
      end

      it "should accept an additional nameserver argument" do
        subject.dns_reverse_lookup_all(address,server).should include(reverse_hostname)
      end

      context "when given a block" do
        it "should yield the resolved hostnames" do
          subject.enum_for(:dns_reverse_lookup_all,address).to_a.should == [reverse_hostname]
        end

        it "should not yield unresolved hostnames" do
          subject.enum_for(:dns_reverse_lookup_all,bad_address).to_a.should == []
        end
      end
    end
  end
end
