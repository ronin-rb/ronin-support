require 'spec_helper'
require 'ronin/support/network/http/core_ext/uri/http'

require 'webmock/rspec'

describe URI::HTTP do
  subject { URI('https://example.com/') }

  it "must define a #status method" do
    expect(subject.respond_to?(:status)).to be(true)
  end

  it "must define a #ok? method" do
    expect(subject.respond_to?(:ok?)).to be(true)
  end

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
        subject { URI('https://example.com/foo') }

        it "must return false" do
          expect(subject.ok?).to be(false)
        end
      end
    end
  end
end
