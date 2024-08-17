require 'spec_helper'
require 'ronin/support/network/url'

require 'webmock/rspec'

describe Ronin::Support::Network::URL do
  it "must inherit from Addressable::URI" do
    expect(described_class).to be < Addressable::URI
  end

  it "must include URI::QueryParams::Mixin" do
    expect(described_class).to include(URI::QueryParams::Mixin)
  end

  subject { described_class.parse('https://example.com/') }

  describe "#status" do
    context "integration", :network do
      before(:all) { WebMock.allow_net_connect! }

      it "must request the HTTP status for the URI" do
        expect(subject.status).to eq(200)
      end
    end
  end

  describe "#ok?" do
    context "integration", :network do
      before(:all) { WebMock.allow_net_connect! }

      context "when the URI returns has a HTTP 200 response" do
        it "must return true" do
          expect(subject.ok?).to be(true)
        end
      end

      context "when the URI does not return a HTTP 200 response" do
        subject { described_class.parse('https://example.com/foo') }

        it "must return false" do
          expect(subject.ok?).to be(false)
        end
      end
    end
  end
end
