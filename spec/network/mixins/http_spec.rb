require 'spec_helper'
require 'ronin/network/mixins/http'

describe Network::Mixins::HTTP do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#disable_http_proxy" do
    let(:proxy) { 'www.example.com:8080' }

    before { subject.http_proxy = proxy }

    it "should set http_proxy to nil" do
      subject.disable_http_proxy

      expect(subject.http_proxy).to be(nil)
    end
  end

  describe "helper methods", :network do
    let(:host) { 'www.google.com' }
    let(:port) { 80 }
    let(:path) { '/' }

    before do
      subject.host = host
      subject.port = port
    end

    describe "#http_connect" do
      it "should create a Net::HTTP session" do
        http = subject.http_connect
        
        http.should be_kind_of(Net::HTTP)
        http.should be_started

        http.finish
      end

      it "should yield the new Net::HTTP session" do
        http = nil

        subject.http_connect do |session|
          http = session
        end

        http.should be_kind_of(Net::HTTP)
      end

      it "should allow yielding the expanded options" do
        options = nil

        subject.http_connect do |session,yielded_options|
          options = yielded_options
        end

        expect(options[:host]).to eq(host)
        expect(options[:port]).to eq(port)
      end
    end

    describe "#http_session" do
      it "should start and then finish a Net::HTTP session" do
        http = nil
        
        subject.http_session do |session|
          http = session
        end
        
        http.should be_kind_of(Net::HTTP)
        http.should_not be_started
      end

      it "should allow yielding the Net::HTTP session" do
        http = nil

        subject.http_session do |session|
          http = session
        end
        
        http.should be_kind_of(Net::HTTP)
      end

      it "should allow yielding the expanded options" do
        options = nil

        subject.http_session do |session,yielded_options|
          options = yielded_options
        end

        expect(options[:host]).to eq(host)
        expect(options[:port]).to eq(port)
      end
    end

    describe "#http_request" do
      it "should send an arbitrary request and return the response" do
        response = subject.http_request(method: :options)

        response.should be_kind_of(Net::HTTPMethodNotAllowed)
      end

      it "should allow yielding the request" do
        request = nil

        subject.http_request(method: :options) do |req|
          request = req
        end

        request.should be_kind_of(Net::HTTP::Options)
      end

      it "should allow yielding the expanded options" do
        options = nil

        subject.http_request(method: :options) do |req,yielded_options|
          options = yielded_options
        end
        
        expect(options[:host]).to eq(host)
        expect(options[:port]).to eq(port)
      end
    end

    describe "#http_status" do
      it "should return an Integer" do
        subject.http_status(path: path).should be_kind_of(Integer)
      end

      it "should return the status-code of the Response" do
        expect(subject.http_status(path: path)).to eq(200)
      end
    end

    describe "#http_ok?" do
      it "should check if the Response has code 200" do
        expect(subject.http_ok?(path: path)).to be(true)
      end
    end

    describe "#http_server" do
      let(:host)    { 'www.php.net' }
      let(:path)    { '/' }
      let(:headers) { subject.http_get_headers(path: path) }

      it "should return the 'Server' header" do
        expect(subject.http_server(path: path)).to eq(headers['Server'])
      end
    end

    describe "#http_powered_by" do
      let(:host)    { 'www.php.net' }
      let(:path)    { '/' }
      let(:headers) { subject.http_get_headers(path: path) }

      it "should return the 'X-Powered-By' header" do
        expect(subject.http_powered_by(path: path)).to eq(headers['X-Powered-By'])
      end
    end

    describe "#http_get_headers" do
      let(:headers) { subject.http_get_headers(path: path) }

      it "should return HTTP Headers" do
        headers.should_not be_empty
      end

      it "should format the HTTP Headers accordingly" do
        format = /^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/
        bad_headers = headers.keys.reject { |name| name =~ format }

        expect(bad_headers).to eq([])
      end
    end

    describe "#http_get_body" do
      it "should return the response body" do
        body = subject.http_get_body(path: path)

        body.should be_kind_of(String)
        body.should_not be_empty
      end
    end

    describe "#http_post_headers" do
      let(:headers) { subject.http_post_headers(path: path) }

      it "should return HTTP Headers" do
        headers.should_not be_empty
      end

      it "should format the HTTP Headers accordingly" do
        format = /^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/
        bad_headers = headers.keys.reject { |name| name =~ format }

        expect(bad_headers).to eq([])
      end
    end

    describe "#http_post_body" do
      it "should return the response body" do
        body = subject.http_post_body(path: path)

        expect(body).to be_kind_of(String)
        expect(body).to_not be_empty
      end
    end
  end
end
