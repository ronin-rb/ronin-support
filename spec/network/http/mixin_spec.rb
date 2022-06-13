require 'spec_helper'
require 'ronin/support/network/http/mixin'

require 'webmock/rspec'

describe Ronin::Support::Network::HTTP::Mixin do
  let(:host) { 'www.example.com' }
  let(:port) { 80 }
  let(:path) { '/index.html' }
  let(:uri)  { URI::HTTP.build(host: host, port: port, path: path) }

  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#http_connect" do
    it "must create a Ronin::Support::Network::HTTP instance with the host nad port" do
      http = subject.http_connect(host,port)

      expect(http).to be_kind_of(Ronin::Support::Network::HTTP)
      expect(http.host).to eq(host)
      expect(http.port).to eq(port)
    end

    context "when a block is given" do
      it "must yield the Ronin::Support::Network::HTTP object" do
        expect { |b|
          subject.http_connect(host,port,&b)
        }.to yield_with_args(Ronin::Support::Network::HTTP)
      end
    end
  end

  describe "#http_session" do
    it "must yield a Ronin::Support::Network::HTTP instance with the host and port" do
      yielded_http = nil

      subject.http_session(host,port) do |http|
        yielded_http = http
      end

      expect(yielded_http).to be_kind_of(Ronin::Support::Network::HTTP)
      expect(yielded_http.host).to eq(host)
      expect(yielded_http.port).to eq(port)
    end
  end

  describe "#http_request" do
    let(:method) { :get }

    it "must send a request with the given method and path to the host and return an Net::HTTPResponse object" do
      stub_request(method,uri)

      expect(subject.http_request(method,uri)).to be_kind_of(Net::HTTPResponse)

      expect(WebMock).to have_requested(method,uri)
    end
  end

  describe "#http_response_status" do
    let(:status) { 200 }

    it "must send a HTTP HEAD request and return the response status code as an Integer" do
      stub_request(:head,uri).to_return(status: status)

      expect(subject.http_response_status(uri)).to eq(status)
    end

    context "when also given a method argument" do
      let(:method) { :get }

      it "must send the HTTP request method and return the response status code as an Integer" do
        stub_request(method,uri).to_return(status: status)

        expect(subject.http_response_status(method,uri)).to eq(status)
      end
    end
  end

  describe "#http_ok?" do
    context "when the HTTP response status is 200" do
      it "must send a HTTP HEAD request and return true" do
        stub_request(:head,uri).to_return(status: 200)

        expect(subject.http_ok?(uri)).to be(true)
      end

      context "when also given a method argument" do
        let(:method) { :get }

        it "must send the given HTTP request method and return true" do
          stub_request(method,uri).to_return(status: 200)

          expect(subject.http_ok?(method,uri)).to be(true)
        end
      end
    end

    context "when the HTTP response status is not 200" do
      it "must send a HTTP HEAD request and return false" do
        stub_request(:head,uri).to_return(status: 404)

        expect(subject.http_ok?(uri)).to be(false)
      end

      context "when also given a method argument" do
        let(:method) { :get }

        it "must send the given HTTP request method and return false" do
          stub_request(method,uri).to_return(status: 404)

          expect(subject.http_ok?(method,uri)).to be(false)
        end
      end
    end
  end

  describe "#http_response_headers" do
    let(:headers) do
      {'X-Test' => 'foo' }
    end

    it "send send a HTTP HEAD request and return the capitalized response headers" do
      stub_request(:head,uri).to_return(headers: headers)

      expect(subject.http_response_headers(uri)).to eq(headers)
    end

    context "when also given a method argument" do
      let(:method) { :get }

      it "send send the HTTP request method and return the capitalized response headers" do
        stub_request(method,uri).to_return(headers: headers)

        expect(subject.http_response_headers(method,uri)).to eq(headers)
      end
    end
  end

  describe "#http_server_header" do
    let(:server_header) { 'Apache' }

    it "must send a HTTP HEAD request and return the 'Server' header" do
      stub_request(:head,uri).to_return(
        headers: {'Server' => server_header}
      )

      expect(subject.http_server_header(uri)).to eq(server_header)
    end

    context "when also given a method argument" do
      let(:method) { :get }

      it "must send the HTTP request method and return the 'Server' header" do
        stub_request(method,uri).to_return(
          headers: {'Server' => server_header}
        )

        expect(subject.http_server_header(uri, method: method)).to eq(server_header)
      end
    end
  end

  describe "#http_powered_by_header" do
    let(:x_powered_by_header) { 'PHP/1.2.3' }

    it "must send a HTTP HEAD request and return the 'X-Powered-By' header" do
      stub_request(:head,uri).to_return(
        headers: {'X-Powered-By' => x_powered_by_header}
      )

      expect(subject.http_powered_by_header(uri)).to eq(x_powered_by_header)
    end

    context "when also given a method: keyword argument" do
      let(:method) { :get }

      it "must send the HTTP request method and return the 'X-Powered-By' header" do
        stub_request(method,uri).to_return(
          headers: {'X-Powered-By' => x_powered_by_header}
        )

        expect(subject.http_powered_by_header(uri, method: method)).to eq(x_powered_by_header)
      end
    end
  end

  describe "#http_response_body" do
    let(:body) { 'Test body' }

    it "must send a HTTP GET request and return the response body" do
      stub_request(:get,uri).to_return(body: body)

      expect(subject.http_response_body(uri)).to eq(body)
    end

    context "when also given a method argument" do
      let(:method) { :post }

      it "must send the HTTP request method and return the response body" do
        stub_request(method,uri).to_return(body: body)

        expect(subject.http_response_body(method,uri)).to be(body)
      end
    end
  end

  [:copy, :delete, :get, :lock, :mkcol, :move, :options, :patch, :post, :propfind, :proppatch, :put, :trace, :unlock].each do |method|
    describe "#http_#{method}" do
      let(:method) { method }

      it "must send a HTTP #{method.upcase} request and return a Net::HTTP response object" do
        stub_request(method,uri)

        expect(subject.send(:"http_#{method}",uri)).to be_kind_of(Net::HTTPResponse)
      end
    end
  end

  describe "#http_get_headers" do
     let(:headers) do
      {'X-Test' => 'foo'}
    end

    it "must send a HTTP GET request and return the capitalized response headers" do
      stub_request(:get,uri).to_return(headers: headers)

      expect(subject.http_get_headers(uri)).to eq(headers)
    end
 end

  describe "#http_get_body" do
    let(:body) { 'Test body' }

    it "must send a HTTP GET request and return the body" do
      stub_request(:get,uri).to_return(body: body)

      expect(subject.http_get_body(uri)).to eq(body)
    end
  end

  describe "#http_post_headers" do
    let(:headers) do
      {'X-Test' => 'foo'}
    end

    it "must send a HTTP POST request and return the capitalized response headers" do
      stub_request(:post,uri).to_return(headers: headers)

      expect(subject.http_post_headers(uri)).to eq(headers)
    end
  end

  describe "#http_post_body" do
    let(:body) { 'Test body' }

    it "must send a HTTP POST request and return the body" do
      stub_request(:post,uri).to_return(body: body)

      expect(subject.http_post_body(uri)).to eq(body)
    end
  end

  describe "integration", :network do
    let(:host) { 'www.example.com' }
    let(:port) { 443 }
    let(:path) { '/index.html' }
    let(:uri)  { URI::HTTPS.build(host: host, port: port, path: path) }

    before(:all) { WebMock.allow_net_connect! }

    describe "#http_request" do
      it "must return an appropriate Net::HTTP response object" do
        expect(subject.http_request(:get,uri)).to be_kind_of(Net::HTTPOK)
      end
    end

    describe "#http_response_status" do
      it "must return the response status code as an Integer" do
        expect(subject.http_response_status(:get,uri)).to eq(200)
      end
    end

    describe "#http_ok?" do
      context "when the HTTP response status is 200" do
        let(:uri) { URI::HTTPS.build(host: host, port: port) }

        it "must return true" do
          expect(subject.http_ok?(uri)).to be(true)
        end
      end

      context "when the HTTP response status is not 200" do
        let(:uri) { URI::HTTPS.build(host: host, port: port, path: '/foo') }

        it "must return false" do
          expect(subject.http_ok?(uri)).to be(false)
        end
      end
    end

    describe "#http_response_headers" do
      let(:headers) { subject.http_response_headers(:get,uri) }

      it "must return HTTP Headers as a Hash" do
        expect(headers).to be_kind_of(Hash)
        expect(headers).not_to be_empty
      end

      it "must capitalize the HTTP Header names" do
        expect(headers.keys).to all(match(/^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/))
      end
    end

    describe "#http_response_body" do
      it "must return the response body as a String" do
        body = subject.http_response_body(:get,uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end

    describe "#http_get" do
      it "must send an HTTP GET request and return an appropriate Net::HTTP response object" do
        expect(subject.http_get(uri)).to be_kind_of(Net::HTTPOK)
      end
    end

    describe "#http_get_headers" do
      let(:headers) { subject.http_get_headers(uri) }

      it "must return HTTP Headers as a Hash" do
        expect(headers).to be_kind_of(Hash)
        expect(headers).not_to be_empty
      end

      it "must capitalize the HTTP Header names" do
        expect(headers.keys).to all(match(/^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/))
      end
    end

    describe "#http_get_body" do
      it "must return the response body as a String" do
        body = subject.http_get_body(uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end

    describe "#http_head" do
      it "must send an HTTP HEAD request and return an appropriate Net::HTTP response object" do
        expect(subject.http_head(uri)).to be_kind_of(Net::HTTPOK)
      end
    end

    describe "#http_post_headers" do
      let(:headers) { subject.http_post_headers(uri) }

      it "must return HTTP Headers" do
        expect(headers).to be_kind_of(Hash)
        expect(headers).not_to be_empty
      end

      it "must format the HTTP Headers accordingly" do
        expect(headers.keys).to all(match(/^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/))
      end
    end

    describe "#http_post_body" do
      it "must return the response body" do
        body = subject.http_post_body(uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end
  end
end
