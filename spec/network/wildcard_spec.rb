require 'spec_helper'
require 'ronin/support/network/wildcard'

describe Ronin::Support::Network::Wildcard do
  let(:wildcard) { '*.example.com' }

  subject { described_class.new(wildcard) }

  describe "#initialize" do
    it "must set #template" do
      expect(subject.template).to eq(wildcard)
    end

    context "when the wildcard template starts with a '*' character" do
      let(:wildcard) { '*.example.com' }

      it "must initialize #regex to a Regexp that matches the suffix of the wildcard template" do
        expect(subject.regex).to eq(/\A(.*?)\.example\.com\z/)
      end
    end

    context "when the wildcard template includes a '*' character" do
      let(:wildcard) { 'www.*.example.com' }

      it "must initialize #regex to a Regexp that matches both the prefix and suffix of the wildcard template" do
        expect(subject.regex).to eq(/\Awww\.(.*?)\.example\.com\z/)
      end
    end

    context "when the wildcard template ends with a '*' character" do
      let(:wildcard) { 'www.example.*' }

      it "must initialize #regex to a Regexp that matches the prefix of the wildcard template" do
        expect(subject.regex).to eq(/\Awww\.example\.(.*?)\z/)
      end
    end

    context "when the wildcard template does not include a '*' character" do
      let(:wildcard) { 'www.example.com' }

      it "must initialize #regex to a Regexp that matches the whole wildcard template string" do
        expect(subject.regex).to eq(/\Awww\.example\.com\z/)
      end
    end
  end

  describe "#subdomain" do
    let(:name) { 'www' }

    it "must replace the '*' in the wildcard template with the given value and return a new Ronin::Support::Network::Host object with" do
      host = subject.subdomain(name)

      expect(host).to be_kind_of(Ronin::Support::Network::Host)
      expect(host.name).to eq("www.example.com")
    end
  end

  describe "#===" do
    context "when the wildcard template starts with a '*' character" do
      let(:wildcard) { '*.example.com' }

      context "and when the given hostname ends with the wildcard template string" do
        let(:host) { 'www.example.com' }

        it "must return true" do
          expect(subject === host).to be(true)
        end
      end

      context "but the given hostname does not end with the wildcard template string" do
        let(:host) { 'www.example.co.uk' }

        it "must return false" do
          expect(subject === host).to be(false)
        end
      end
    end

    context "when the wildcard template includes a '*' character" do
      let(:wildcard) { 'www.*.example.com' }

      context "and when the given hostname starts with and ends with the wildcard template prefix and suffix" do
        let(:host) { 'www.foo.example.com' }

        it "must return true" do
          expect(subject === host).to be(true)
        end
      end

      context "and when the given hostname does not start with the wildcard template prefix" do
        let(:host) { 'foo.bar.example.com' }

        it "must return false" do
          expect(subject === host).to be(false)
        end
      end

      context "and when the given hostname does not end with the wildcard template suffix" do
        let(:host) { 'www.foo.example.co.uk' }

        it "must return false" do
          expect(subject === host).to be(false)
        end
      end
    end

    context "when the wildcard template ends with a '*' character" do
      let(:wildcard) { 'www.example.*' }

      context "and when the given hostname does start with the wildcard template prefix" do
        let(:host) { 'www.example.co.uk' }

        it "must return true" do
          expect(subject === host).to be(true)
        end
      end

      context "but when the given hostname does not start with the wildcard template prefix" do
        let(:host) { 'foo.example.com' }

        it "must return false" do
          expect(subject === host).to be(false)
        end
      end
    end

    context "when the wildcard template does not include a '*' character" do
      let(:wildcard) { 'www.example.com' }

      context "and when the given hostname matches the whole wildcard template string" do
        let(:host) { wildcard }

        it "must return true" do
          expect(subject === host).to be(true)
        end
      end

      context "but when the given hostname does not match the whole wildcard template string" do
        let(:host) { "foo.example.com" }

        it "must return false" do
          expect(subject === host).to be(false)
        end
      end
    end
  end

  describe "#to_s" do
    it "must return the wildcard String" do
      expect(subject.to_s).to eq(wildcard)
    end
  end
end
