require 'spec_helper'
require 'ronin/support/network/wildcard'

describe Ronin::Support::Network::Wildcard do
  let(:wildcard) { '*.example.com' }

  subject { described_class.new(wildcard) }

  describe "#initialize" do
    it "must set #template" do
      expect(subject.template).to eq(wildcard)
    end
  end

  describe "#%" do
    let(:name) { 'www' }

    it "must replace the '*' in the wildcard template with the given value and return a new Ronin::Support::Network::Host object with" do
      host = subject % name

      expect(host).to be_kind_of(Ronin::Support::Network::Host)
      expect(host.name).to eq("www.example.com")
    end
  end

  describe "#to_s" do
    it "must return the wildcard String" do
      expect(subject.to_s).to eq(wildcard)
    end
  end
end
