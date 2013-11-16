require 'spec_helper'
require 'ronin/network/ip'

describe Network::IP do
  describe "helper methods", :network do
    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    describe "#external_ip" do
      it "should determine our public facing IP Address" do
        subject.external_ip.should_not be_nil
      end
    end

    describe "#internal_ip" do
      it "should determine our internal IP Address" do
        subject.internal_ip.should_not be_nil
      end
    end
  end
end
