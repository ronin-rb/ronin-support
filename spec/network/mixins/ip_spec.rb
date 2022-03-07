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
    end

    describe "#local_ip" do
      it "should determine our internal IP Address" do
        expect(subject.local_ip).to_not be(nil)
      end
    end

    describe "#ip" do
      it "must return either #public_ip or #local_ip" do
        expect(subject.ip).to eq(subject.public_ip).or(eq(subject.local_ip))
      end

      context "when #public_ip raises an exception" do
        before do
          allow(subject).to receive(:public_ip) do
            raise("network error!")
          end
        end

        it "must fallback to #local_ip" do
          expect(subject.ip.to_s).to eq(subject.local_ip.to_s)
        end
      end
    end
  end
end
