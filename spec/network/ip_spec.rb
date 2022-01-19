require 'spec_helper'
require 'ronin/support/network/ip'

describe Network::IP do
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
