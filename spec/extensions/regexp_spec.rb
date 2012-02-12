require 'spec_helper'
require 'ronin/extensions/regexp'

describe Regexp do
  describe "IPv4" do
    subject { Regexp::IPv4 }

    it "should match valid addresses" do
      ip = '127.0.0.1'

      subject.match(ip)[0].should == ip
    end

    it "should match the Any address" do
      ip = '0.0.0.0'

      subject.match(ip)[0].should == ip
    end

    it "should match the broadcast address" do
      ip = '255.255.255.255'

      subject.match(ip)[0].should == ip
    end

    it "should not match addresses with octets > 255" do
      ip = '10.1.256.1'

      subject.match(ip).should be_nil
    end

    it "should not match addresses with more than three digits per octet" do
      ip = '10.1111.1.1'

      subject.match(ip).should be_nil
    end
  end
end
