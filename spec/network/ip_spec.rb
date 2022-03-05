require 'spec_helper'
require 'ronin/support/network/ip'

describe Network::IP do
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

    describe "#external_ip" do
      it "should determine our public facing IP Address" do
        expect(subject.external_ip).to_not be(nil)
      end
    end

    describe "#internal_ip" do
      it "should determine our internal IP Address" do
        expect(subject.internal_ip).to_not be(nil)
      end
    end
  end
end
