require 'spec_helper'
require 'ronin/support/network/http/user_agents'

describe Ronin::Support::Network::HTTP::UserAgents do
  describe ".[]" do
    described_class::ALIASES.each do |name,string|
      context "when given #{name.inspect}" do
        it "must return the User-Agent #{string.inspect}" do
          expect(subject[name]).to eq(string)
        end
      end
    end

    describe "when given :random" do
      let(:user_agents) { described_class::ALIASES.values }

      it "must return a random User-Agent from #{described_class}::ALIASES" do
        expect(user_agents).to include(subject[:random])
      end
    end

    [:chrome, :firefox, :safari].each do |prefix|
      describe "when given #{prefix.inspect}" do
        let(:user_agents) do
          described_class::ALIASES.select { |k,v| k =~ /^#{prefix}_/ }.values
        end

        it "must return the a random :#{prefix}_* User-Agent String from #{described_class}::ALIASES" do
          expect(user_agents).to include(subject[prefix])
        end
      end
    end

    [:linux, :macos, :windows, :iphone, :ipad, :android].each do |suffix|
      describe "when given #{suffix.inspect}" do
        let(:user_agents) do
          described_class::ALIASES.select { |k,v| k =~ /_#{suffix}$/ }.values
        end

        it "must return the a random :*_#{suffix} User-Agent String from #{described_class}::ALIASES" do
          expect(user_agents).to include(subject[suffix])
        end
      end
    end
  end

  context "when given an known Symbol" do
    let(:id) { :foo }

    it do
      expect {
        subject[id]
      }.to raise_error(ArgumentError,"unknown user agent alias: #{id.inspect}")
    end
  end

  context "when given a non-Symbol value" do
    let(:id) { Object.new }

    it do
      expect {
        subject[id]
      }.to raise_error(ArgumentError,"User-Agent ID must be a Symbol")
    end
  end
end
