require 'spec_helper'
require 'ronin/support/network/http/core_ext/uri/http'

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
      it "must request the HTTP stauts for the URI" do
        expect(subject.status).to eq(200)
      end
    end
  end

  describe "#ok?", :network do
    context "integration", :network do
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
