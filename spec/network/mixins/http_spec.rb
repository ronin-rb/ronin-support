require 'spec_helper'
require 'ronin/support/network/mixins/http'

describe Ronin::Support::Network::Mixins::HTTP do
  let(:host) { 'www.google.com' }
  let(:port) { 80 }
  let(:path) { '/' }
  let(:uri)  { URI::HTTP.build(host: host, port: 80, path: path) }

  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#http_connect" do
    context "integration", :network do
      it "should create a Net::HTTP session" do
        http = subject.http_connect(host: host, port: port)

        expect(http).to be_kind_of(Net::HTTP)
        expect(http).to be_started

        http.finish
      end

      it "should yield the new Net::HTTP session" do
        http = nil

        subject.http_connect(url: uri) do |session|
          http = session
        end

        expect(http).to be_kind_of(Net::HTTP)
      end

      it "should allow yielding the expanded options" do
        expanded_options = nil

        subject.http_connect(url: uri) do |session,options|
          expanded_options = options
        end

        expect(expanded_options[:host]).to eq(host)
        expect(expanded_options[:port]).to eq(port)
        expect(expanded_options[:path]).to eq(path)
      end
    end
  end

  describe "#http_session" do
    context "integration", :network do
      it "should start and then finish a Net::HTTP session" do
        http = nil

        subject.http_session(host: host, port: port) do |session|
          http = session
        end

        expect(http).to be_kind_of(Net::HTTP)
        expect(http).not_to be_started
      end

      it "should allow yielding the Net::HTTP session" do
        http = nil

        subject.http_session(url: uri) do |session|
          http = session
        end

        expect(http).to be_kind_of(Net::HTTP)
      end
    end
  end

  describe "#http_request" do
    context "integration", :network do
      it "should send an arbitrary request and return the response" do
        response = subject.http_request(url: uri, method: :options)

        expect(response).to be_kind_of(Net::HTTPMethodNotAllowed)
      end

      it "should allow yielding the request" do
        request = nil

        subject.http_request(url: uri, method: :options) do |req|
          request = req
        end

        expect(request).to be_kind_of(Net::HTTP::Options)
      end
    end
  end

  describe "#http_status" do
    context "integration", :network do
      it "should return an Integer" do
        expect(subject.http_status(url: uri)).to be_kind_of(Integer)
      end

      it "should return the status-code of the Response" do
        expect(subject.http_status(url: uri)).to eq(200)
      end
    end
  end

  describe "#http_ok?" do
    context "integration", :network do
      it "should check if the Response has code 200" do
        expect(subject.http_ok?(url: uri)).to be(true)
      end
    end
  end

  describe "#http_server" do
    context "integration", :network do
      let(:url)     { "http://www.php.net/" }
      let(:headers) { subject.http_get_headers(url: url) }

      it "should return the 'Server' header" do
        expect(subject.http_server(url: url)).to eq(headers['Server'])
      end
    end
  end

  describe "#http_powered_by" do
    context "integration", :network do
      let(:url)     { "http://www.php.net/" }
      let(:headers) { subject.http_get_headers(url: url) }

      it "should return the 'X-Powered-By' header" do
        expect(subject.http_powered_by(url: url)).to eq(headers['X-Powered-By'])
      end
    end
  end

  describe "#http_get_headers" do
    context "integration", :network do
      let(:headers) { subject.http_get_headers(url: uri) }

      it "should return HTTP Headers" do
        expect(headers).not_to be_empty
      end

      it "should format the HTTP Headers accordingly" do
        format = /^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/
        bad_headers = headers.keys.reject { |name| name =~ format }

        expect(bad_headers).to eq([])
      end
    end
  end

  describe "#http_get_body" do
    context "integration", :network do
      it "should return the response body" do
        body = subject.http_get_body(url: uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end
  end

  describe "#http_post_headers" do
    context "integration", :network do
      let(:headers) { subject.http_post_headers(url: uri) }

      it "should return HTTP Headers" do
        expect(headers).not_to be_empty
      end

      it "should format the HTTP Headers accordingly" do
        format = /^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/
        bad_headers = headers.keys.reject { |name| name =~ format }

        expect(bad_headers).to eq([])
      end
    end
  end

  describe "#http_post_body" do
    context "integration", :network do
      it "should return the response body" do
        body = subject.http_post_body(url: uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end
  end
end
