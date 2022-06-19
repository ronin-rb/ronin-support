require 'spec_helper'
require 'ronin/support/network/asn/dns_record'
require 'ronin/support/network/ip_range/cidr'

describe Ronin::Support::Network::ASN::DNSRecord do
  let(:number)       { 3356       }
  let(:range)        { Ronin::Support::Network::IPRange::CIDR.new('4.0.0.0/9') }
  let(:country_code) { 'US'       }
  let(:name)         { 'LEVEL3'   }

  subject { described_class.new(number,range,country_code) }

  describe "#initialize" do
    it "must set #number" do
      expect(subject.number).to eq(number)
    end

    it "must set #range" do
      expect(subject.range).to eq(range)
    end

    it "must set #country_code" do
      expect(subject.country_code).to eq(country_code)
    end
  end

  describe "#name", :network do
    it "must lazily query the assigned name for the AS number" do
      expect(subject.name).to eq(name)
    end
  end
end
