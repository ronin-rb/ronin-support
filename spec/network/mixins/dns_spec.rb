require 'spec_helper'
require 'ronin/network/mixins/dns'

require 'ipaddr'

describe Network::Mixins::DNS do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#dns_dns_resolver" do
    let(:server) { '4.2.2.1' }

    it "should return Resolv::DNS" do
      subject.dns_resolver(server).should be_kind_of(Resolv::DNS)
    end

    context "when no arguments are given" do
      before { subject.nameserver = server }

      it "should default to using DNS.nameserver" do
        Resolv::DNS.should_receive(:new).with(nameserver: subject.nameserver)

        subject.dns_resolver
      end

      after { subject.nameserver = nil }
    end

    context "when an argument is given" do
      it "should pass the nameserver: option to Resolv::DNS.new" do
        Resolv::DNS.should_receive(:new).with(nameserver: server)

        subject.dns_resolver(server)
      end
    end
  end
end
