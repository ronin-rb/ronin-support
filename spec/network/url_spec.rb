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

  let(:url) { 'https://example.com/' }

  subject { described_class.parse(url) }

  describe "REGEX" do
    subject { described_class::REGEX }

    it "must match a http:// URL" do
      expect(subject =~ 'http://example.com/').to be_truthy
    end

    it "must match a https:// URL" do
      expect(subject =~ 'https://example.com/').to be_truthy
    end

    it "must match a http(s):// URL with an IP address for a host name" do
      expect(subject =~ 'http://[192.168.1.1]/').to be_truthy
      expect(subject =~ 'https://[192.168.1.1]/').to be_truthy
    end

    it "must match a http(s):// URL with a path" do
      expect(subject =~ 'http://example.com/foo/index.html').to be_truthy
      expect(subject =~ 'https://example.com/foo/index.html').to be_truthy
    end

    it "must match a http(s):// URL with a query string" do
      expect(subject =~ 'http://example.com/?q=1').to be_truthy
      expect(subject =~ 'https://example.com/?q=1').to be_truthy
    end

    it "must match a http(s):// URL with a fragment" do
      expect(subject =~ 'http://example.com/#foo').to be_truthy
      expect(subject =~ 'https://example.com/#foo').to be_truthy
    end

    it "must match a URI with an arbitrary scheme" do
      expect(subject =~ 'foo:').to be_truthy
    end
  end

  describe "#defang" do
    let(:url)      { 'http://www.example.com/foo?q=1' }
    let(:defanged) { 'hxxp[://]www[.]example[.]com/foo?q=1' }

    it "must return the defanged URL" do
      expect(subject.defang).to eq(defanged)
    end
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
        subject { described_class.parse('https://example.com/foo') }

        it "must return false" do
          expect(subject.ok?).to be(false)
        end
      end
    end
  end
end
