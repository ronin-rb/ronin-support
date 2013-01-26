require 'spec_helper'
require 'ronin/network/mixins/dns'

require 'ipaddr'

describe Network::Mixins::DNS do
  describe "#dns_resolver" do
    let(:server) { '4.2.2.1' }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    context "when no argument is given" do
      context "when self.nameserver is not set" do
        it "should return Resolv" do
          subject.dns_resolver.should == Resolv
        end
      end

      context "when self.nameserver is set" do
        before { subject.nameserver = server }

        it "should return Resolv::DNS" do
          subject.dns_resolver(server).should be_kind_of(Resolv::DNS)
        end
      end
    end

    context "when nil is given" do
      it "should return Resolv" do
        subject.dns_resolver(nil).should == Resolv
      end
    end

    context "when an argument is given" do
      it "should return Resolv::DNS" do
        subject.dns_resolver(server).should be_kind_of(Resolv::DNS)
      end
    end
  end
end
