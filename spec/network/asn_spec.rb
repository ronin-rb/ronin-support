require 'spec_helper'
require 'ronin/support/network/asn'

describe Ronin::Support::Network::ASN do
  describe ".query", :network do
    let(:ip) { '4.4.4.4' }

    it "must query the ASN information for the IP and return an ASN record" do
      record = subject.query(ip)

      expect(record).to be_kind_of(described_class::Record)
      expect(record.number).to eq(3356)
      expect(record.range).to be_kind_of(Ronin::Support::Network::IPRange::CIDR)
      expect(record.range.string).to eq('4.0.0.0/9')
      expect(record.country_code).to eq('US')
      expect(record.name).to eq('LEVEL3')
    end

    context "when the IP address is not routed" do
      let(:ip) { '0.0.0.0' }

      it "must return nil" do
        expect(subject.query(ip)).to be(nil)
      end
    end

    context "when given an IPv6 address" do
      let(:ip) { '2606:2800:220:1:248:1893:25c8:1946' }

      it "must query the ASN information for the IPv6 address" do
        record = subject.query(ip)

        expect(record).to be_kind_of(described_class::Record)
        expect(record.number).to eq(15133)
        expect(record.range).to be_kind_of(Ronin::Support::Network::IPRange::CIDR)
        expect(record.range.string).to eq('2606:2800:220::/48')
        expect(record.country_code).to eq('US')
        expect(record.name).to eq('EDGECAST')
      end
    end

    context "when given an IPAddr object instead" do
      let(:ip) { IPAddr.new(super()) }

      it "must still query the IP address" do
        record = subject.query(ip)

        expect(record).to be_kind_of(described_class::Record)
        expect(record.number).to eq(3356)
        expect(record.range).to be_kind_of(Ronin::Support::Network::IPRange::CIDR)
        expect(record.range.string).to eq('4.0.0.0/9')
        expect(record.country_code).to eq('US')
        expect(record.name).to eq('LEVEL3')
      end
    end
  end
end
