require 'spec_helper'
require 'ronin/support/network/dns'

require 'ipaddr'

describe Ronin::Support::Network::DNS::Resolver do
  describe ".default_nameservers" do
    subject { described_class }

    it "must parse the nameservers configured in /etc/resolv.conf" do
      expect(subject.default_nameservers).to eq(
        Resolv::DNS::Config.default_config_hash[:nameserver]
      )
    end
  end

  describe "#initialize" do
    context "when initialized with no arguments" do
      subject { described_class.new }

      it "must set #nameservers to .default_nameservers" do
        expect(subject.nameservers).to eq(described_class.default_nameservers)
      end
    end

    context "when initialized with custom nameservers" do
      let(:nameservers) { %w[42.42.42.42] }

      subject { described_class.new(nameservers) }

      it "must set #nameservers" do
        expect(subject.nameservers).to eq(nameservers)
      end

      it "must initialize Resolv::DNS with the nameservers" do
        expect(Resolv::DNS).to receive(:new).with(nameserver: nameservers)

        described_class.new(nameservers)
      end

      context "but the nameservers are empty" do
        it "must initialize Resolv::DNS without arguments" do
          expect(Resolv::DNS).to receive(:new).with(no_args)

          described_class.new([])
        end
      end
    end
  end

  let(:nameservers)      { %w[8.8.8.8] }
  let(:hostname)         { 'example.com' }
  let(:bad_hostname)     { 'foo.bar' }
  let(:address)          { '93.184.216.34' }
  let(:bad_address)      { '0.0.0.0' }
  let(:reverse_address)  { '142.251.33.110' }
  let(:reverse_hostname) { 'sea30s10-in-f14.1e100.net' }

  subject { described_class.new(nameservers) }

  describe "#get_address", :network do
    it "must lookup the address for a hostname" do
      expect(subject.get_address(hostname)).to eq(address)
    end

    context "when the host nmae has no IP addresses" do
      it "must return nil for unknown hostnames" do
        expect(subject.get_address(bad_hostname)).to be(nil)
      end
    end
  end

  describe "#get_addresses", :network  do
    it "must lookup all addresses for a hostname" do
      expect(subject.get_addresses(hostname)).to include(address)
    end

    context "when the host nmae has no IP addresses" do
      it "must return an empty Array" do
        expect(subject.get_addresses(bad_hostname)).to eq([])
      end
    end
  end

  describe "#get_name", :network  do
    it "should lookup the address for a hostname" do
      expect(subject.get_name(reverse_address)).to eq(reverse_hostname)
    end

    context "when the IP address has no host names associated with it" do
      it "must return nil" do
        expect(subject.get_name(bad_address)).to be(nil)
      end
    end
  end

  describe "#get_names", :network  do
    it "should lookup all addresses for a hostname" do
      expect(subject.get_names(reverse_address)).to include(reverse_hostname)
    end

    context "when the IP address has no host names associated with it" do
      it "should return an empty Array" do
        expect(subject.get_names(bad_address)).to eq([])
      end
    end
  end

  describe "#get_record", :network do
    let(:record_type) { Resolv::DNS::Resource::IN::TXT }

    it "must return a DNS record of the matching type for the host name" do
      record = subject.get_record(hostname,record_type)

      expect(record).to be_kind_of(record_type)
      expect(record.strings).to eq(["v=spf1 -all"])
    end

    context "when the host name does not exist" do
      it "must return nil" do
        expect(subject.get_record(bad_hostname,record_type)).to be(nil)
      end
    end

    context "when the host name has no matching records" do
    let(:record_type) { Resolv::DNS::Resource::IN::CNAME }

      it "must return nil" do
        expect(subject.get_record(hostname,record_type)).to be(nil)
      end
    end
  end

  describe "#get_records", :network do
    let(:record_type) { Resolv::DNS::Resource::IN::TXT }

    it "must return a DNS record of the matching type for the host name" do
      records = subject.get_records(hostname,record_type)

      expect(records).to_not be_empty
      expect(records).to all(be_kind_of(record_type))
      expect(records.first.strings).to eq(["v=spf1 -all"])
    end

    context "when the host name does not exist" do
      it "must return an empty Array" do
        expect(subject.get_records(bad_hostname,record_type)).to eq([])
      end
    end

    context "when the host name has no matching records" do
    let(:record_type) { Resolv::DNS::Resource::IN::CNAME }

      it "must return an empty Array" do
        expect(subject.get_records(hostname,record_type)).to eq([])
      end
    end
  end
end
