require 'spec_helper'
require 'ronin/support/network/host'

describe Ronin::Support::Network::Host do
  let(:name) { 'example.com' }

  subject { described_class.new(name) }

  describe "#initialize" do
    it "must set #name" do
      expect(subject.name).to eq(name)
    end
  end

  describe "#to_s" do
    it "must return the host name String" do
      expect(subject.to_s).to eq(name)
    end
  end

  describe "#to_str" do
    it "must return the host name String" do
      expect(subject.to_str).to eq(name)
    end
  end
end
