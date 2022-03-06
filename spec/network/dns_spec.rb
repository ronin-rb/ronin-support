require 'spec_helper'
require 'ronin/support/network/dns'

describe Ronin::Support::Network::DNS do
  describe ".nameservers" do
    it "must default to the system's resolv.conf nameserver(s)" do
      expect(subject.nameservers).to eq(
        described_class::Resolver.default_nameservers
      )
    end
  end

  describe ".nameservers=" do
    let(:original_nameservers) { subject.nameservers }

    let(:new_nameservers) { %w[42.42.42.42] }

    it "must override the system's default nameservers" do
      subject.nameservers = new_nameservers

      expect(subject.nameservers).to eq(new_nameservers)
    end

    after { subject.nameservers = original_nameservers }
  end

  describe ".resolver" do
    it "should return #{described_class::Resolver}" do
      expect(subject.resolver).to be_kind_of(described_class::Resolver)
    end

    context "when no arguments are given" do
      it "should default to using DNS.nameserver" do
        resolver = subject.resolver

        expect(resolver.nameservers).to eq(subject.nameservers)
      end
    end

    context "when an argument is given" do
      let(:nameservers) { %w[42.42.42.42] }

      it "must return a #{described_class::Resolver} object with the given nameservers" do
        resolver = subject.resolver(nameservers)

        expect(resolver).to be_kind_of(described_class::Resolver)
        expect(resolver.nameservers).to eq(nameservers)
      end
    end
  end
end
