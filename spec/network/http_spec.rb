require 'spec_helper'
require 'ronin/support/network/http'

require 'webmock/rspec'

describe Network::HTTP do
  describe ".proxy" do
    subject { described_class }

    it "must return nil by default" do
      expect(subject.proxy).to be(nil)
    end

    context "when the RONIN_HTTP_PROXY environment variable was set" do
      before { ENV['RONIN_HTTP_PROXY'] = 'http://example.com:8080' }

      it "must parse the RONIN_HTTP_PROXY environment variable" do
        expect(subject.proxy).to eq(URI(ENV['RONIN_HTTP_PROXY']))
      end

      after do
        subject.proxy = nil
        ENV.delete('RONIN_HTTP_PROXY')
      end
    end

    context "when the HTTP_PROXY environment variable was set" do
      before { ENV['HTTP_PROXY'] = 'http://example.com:8080' }

      it "must parse the HTTP_PROXY environment variable" do
        expect(subject.proxy).to eq(URI(ENV['HTTP_PROXY']))
      end

      after do
        subject.proxy = nil
        ENV.delete('HTTP_PROXY')
      end
    end
  end

  describe ".proxy=" do
    subject { described_class }

    context "when given a URI::HTTP object" do
      let(:uri) { URI('https://user:password@example.com/') }

      before do
        subject.proxy = uri
      end

      it "must set .proxy to the URI::HTTP object" do
        expect(subject.proxy).to be(uri)
      end
    end

    context "when given a String" do
      let(:string) { 'https://user:password@example.com/' }
      let(:uri)    { URI(string) }

      before do
        subject.proxy = string
      end

      it "must set .proxy to the parsed URI::HTTP of the String" do
        expect(subject.proxy).to eq(uri)
      end
    end

    context "when given nil" do
      before do
        subject.proxy = URI('https://example.com/')
        subject.proxy = nil
      end

      it "must set .proxy to nil" do
        expect(subject.proxy).to be(nil)
      end
    end

    after { subject.proxy = nil }
  end

  describe ".user_agent" do
    subject { described_class }

    it "must return nil by default" do
      expect(subject.user_agent).to be(nil)
    end
  end

  shared_examples_for "user_agents=" do
    let(:user_agent) { 'Mozilla/5.0 Foo Bar' }

    context "when given a String" do
      before { subject.user_agent = user_agent }

      it "must set the user agent" do
        expect(subject.user_agent).to be(user_agent)
      end
    end

    described_class::USER_AGENTS.each do |name,string|
      context "when given #{name.inspect}" do
        before { subject.user_agent = name }

        it "must set the user agent to #{string.inspect}" do
          expect(subject.user_agent).to eq(string)
        end
      end
    end

    describe "when given :random" do
      it "must set the user agent to a random value from #{described_class}::USER_AGENTS" do
        subject.user_agent = :random

        expect(described_class::USER_AGENTS.values).to include(subject.user_agent)
      end
    end

    context "when given nil" do
      before do
        subject.user_agent = user_agent
        subject.user_agent = nil
      end

      it "must set .user_agent to nil" do
        expect(subject.user_agent).to be(nil)
      end
    end
  end

  describe ".user_agent=" do
    subject { described_class }

    include_context "user_agents="

    after { subject.user_agent = nil }
  end

  let(:host) { 'www.example.com' }
  let(:port) { 80 }
  let(:path) { "/index.html" }
  let(:uri)  { URI::HTTP.build(host: host, port: port, path: path) }

  let(:ssl_port) { 443 }

  subject { described_class.new(host,port) }

  describe "#initialize" do
    it "must set #host" do
      expect(subject.host).to eq(host)
    end

    it "must set #post" do
      expect(subject.port).to eq(port)
    end

    it "must default #headers to {}" do
      expect(subject.headers).to eq({})
    end

    context "when initialized with the headers: keyword argument" do
      let(:headers) do
        {'X-Foo' => 'foo', 'X-Bar' => 'bar'}
      end

      subject { described_class.new(host,port, headers: headers) }

      it "must set #headers" do
        expect(subject.headers).to eq(headers)
      end
    end

    context "when initialized with the user_agent: keyword argument" do
      let(:user_agent) { 'Mozilla/5.0 Foo Bar' }

      context "when given a String" do
        subject { described_class.new(host,port, user_agent: user_agent) }

        it "must set the user agent" do
          expect(subject.user_agent).to eq(user_agent)
        end
      end

      described_class::USER_AGENTS.each do |name,string|
        context "when given #{name.inspect}" do
          subject { described_class.new(host,port, user_agent: name) }

          it "must set the user agent to #{string.inspect}" do
            expect(subject.user_agent).to eq(string)
          end
        end
      end

      describe "when given :random" do
        subject { described_class.new(host,port, user_agent: :random) }

        it "must set the user agent to a random value from #{described_class}::USER_AGENTS" do
          expect(described_class::USER_AGENTS.values).to include(subject.user_agent)
        end
      end
    end

    context "when given a block" do
      it "must yield the new #{described_class} object" do
        expect { |b|
          described_class.new(host,port,&b)
        }.to yield_with_args(described_class)
      end
    end
  end

  describe ".connect" do
    subject { described_class.connect(host,port) }

    it "must return a new #{described_class} object" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must set #host" do
      expect(subject.host).to eq(host)
    end

    it "must set #post" do
      expect(subject.port).to eq(port)
    end

    context "when initialized with the headers: keyword argument" do
      let(:headers) do
        {'X-Foo' => 'foo', 'X-Bar' => 'bar'}
      end

      subject { described_class.connect(host,port, headers: headers) }

      it "must set #headers" do
        expect(subject.headers).to eq(headers)
      end
    end

    context "when given a block" do
      it "must yield the new #{described_class} object" do
        expect { |b|
          described_class.connect(host,port,&b)
        }.to yield_with_args(described_class)
      end
    end
  end

  describe ".connect_uri" do
    let(:uri) { URI::HTTP.build(host: host, port: port) }

    subject { described_class.connect_uri(uri) }

    it "must set #host to the URI's host" do
      expect(subject.host).to eq(uri.host)
    end

    it "must set #host to the URI's port" do
      expect(subject.port).to eq(uri.port)
    end

    context "when the URI's scheme is http://" do
      it "must not enable SSL" do
        expect(subject.ssl?).to be(false)
      end
    end

    context "when the URI's scheme is https://" do
      let(:uri) { URI::HTTPS.build(host: host, port: port) }

      it "must enable SSL" do
        expect(subject.ssl?).to be(true)
      end
    end

    context "when ssl: true is given" do
      subject { described_class.connect_uri(uri, ssl: true) }

      it "must enable SSL" do
        expect(subject.ssl?).to be(true)
      end
    end

    context "when ssl: {...} is given" do
      subject { described_class.connect_uri(uri, ssl: {}) }

      it "must enable SSL" do
        expect(subject.ssl?).to be(true)
      end
    end

    context "when given a block" do
      it "must yield the new #{described_class} object" do
        expect { |b|
          described_class.connect(host,port,&b)
        }.to yield_with_args(described_class)
      end
    end
  end

  describe "#ssl?" do
    context "when initialized with the ssl: keyword argument is given" do
      subject { described_class.new(host,port, ssl: true) }

      it "must return true" do
        expect(subject.ssl?).to be(true)
      end
    end

    context "when not initialized with the `ssl: keyword argument" do
      context "but the port number is 443" do
        let(:port) { 443 }

        it "must return true" do
          expect(subject.ssl?).to be(true)
        end
      end

      context "but the port is not 443" do
        it "must return false" do
          expect(subject.ssl?).to be(false)
        end
      end
    end
  end

  describe "#user_agent" do
    context "when #headers contains the 'User-Agent' header" do
      let(:user_agent) { 'Mozilla/5.0 Foo Bar' }
      let(:headers) do
        {'User-Agent' => user_agent}
      end

      subject { described_class.new(host,port, headers: headers) }

      it "must return the 'User-Agent' header value" do
        expect(subject.user_agent).to eq(user_agent)
      end
    end

    context "when #headers does not contain a 'User-Agent' header" do
      it "must return nil" do
        expect(subject.user_agent).to be(nil)
      end
    end
  end

  describe "#user_agent=" do
    include_context "user_agents="
  end

  describe "#request" do
    let(:method) { :get }

    it "must send a request with the given method and path to the host and return an Net::HTTPResponse object" do
      stub_request(method,uri)

      expect(subject.request(method,path)).to be_kind_of(Net::HTTPResponse)

      expect(WebMock).to have_requested(method,uri)
    end
  end

  describe "#response_status" do
    let(:status) { 200 }

    it "must send a HTTP HEAD request and return the response status code as an Integer" do
      stub_request(:head,uri).to_return(status: status)

      expect(subject.response_status(path)).to eq(status)
    end

    context "when also given a method argument" do
      let(:method) { :get }

      it "must send the HTTP request method and return the response status code as an Integer" do
        stub_request(method,uri).to_return(status: status)

        expect(subject.response_status(method,path)).to eq(status)
      end
    end
  end

  describe "#ok?" do
    context "when the HTTP response status is 200" do
      it "must send a HTTP HEAD request and return true" do
        stub_request(:head,uri).to_return(status: 200)

        expect(subject.ok?(path)).to be(true)
      end

      context "when also given a method argument" do
        let(:method) { :get }

        it "must send the given HTTP request method and return true" do
          stub_request(method,uri).to_return(status: 200)

          expect(subject.ok?(method,path)).to be(true)
        end
      end
    end

    context "when the HTTP response status is not 200" do
      it "must send a HTTP HEAD request and return false" do
        stub_request(:head,uri).to_return(status: 404)

        expect(subject.ok?(path)).to be(false)
      end

      context "when also given a method argument" do
        let(:method) { :get }

        it "must send the given HTTP request method and return false" do
          stub_request(method,uri).to_return(status: 404)

          expect(subject.ok?(method,path)).to be(false)
        end
      end
    end
  end

  describe "#response_headers" do
    let(:headers) do
      {'X-Test' => 'foo' }
    end

    it "send send a HTTP HEAD request and return the capitalized response headers" do
      stub_request(:head,uri).to_return(headers: headers)

      expect(subject.response_headers(path)).to eq(headers)
    end

    context "when also given a method argument" do
      let(:method) { :get }

      it "send send the HTTP request method and return the capitalized response headers" do
        stub_request(method,uri).to_return(headers: headers)

        expect(subject.response_headers(method,path)).to eq(headers)
      end
    end
  end

  describe "#server_header" do
    let(:uri) { URI::HTTP.build(host: host, port: port) }

    let(:server_header) { 'Apache' }

    it "must send a HTTP HEAD request to '/' and return the 'Server' header" do
      stub_request(:head,uri).to_return(
        headers: {'Server' => server_header}
      )

      expect(subject.server_header).to eq(server_header)
    end

    context "when also given a method: keyword argument" do
      let(:method) { :get }

      it "must send the HTTP request method to '/' and return the 'Server' header" do
        stub_request(method,uri).to_return(
          headers: {'Server' => server_header}
        )

        expect(subject.server_header(method: method)).to eq(server_header)
      end
    end

    context "when also given a path: keyword argument" do
      let(:path) { '/foo/bar' }
      let(:uri)  { URI::HTTP.build(host: host, port: port, path: path) }

      it "must send a HTTP HEAD request to the path and return the 'Server' header" do
        stub_request(:head,uri).to_return(
          headers: {'Server' => server_header}
        )

        expect(subject.server_header(path: path)).to eq(server_header)
      end

      context "when also given a method: keyword argument" do
        let(:method) { :get }

        it "must send the HTTP request method to the path and return the 'Server' header" do
          stub_request(method,uri).to_return(
            headers: {'Server' => server_header}
          )

          expect(subject.server_header(method: method, path: path)).to eq(server_header)
        end
      end
    end
  end

  describe "#powered_by_header" do
    let(:uri) { URI::HTTP.build(host: host, port: port) }

    let(:x_powered_by_header) { 'PHP/1.2.3' }

    it "must send a HTTP HEAD request to '/' and return the 'X-Powered-By' header" do
      stub_request(:head,uri).to_return(
        headers: {'X-Powered-By' => x_powered_by_header}
      )

      expect(subject.powered_by_header).to eq(x_powered_by_header)
    end

    context "when also given a method: keyword argument" do
      let(:method) { :get }

      it "must send the HTTP request method to '/' and return the 'X-Server-By' header" do
        stub_request(method,uri).to_return(
          headers: {'X-Powered-By' => x_powered_by_header}
        )

        expect(subject.powered_by_header(method: method)).to eq(x_powered_by_header)
      end
    end

    context "when also given a path: keyword argument" do
      let(:path) { '/foo/bar' }
      let(:uri)  { URI::HTTP.build(host: host, port: port, path: path) }

      it "must send a HTTP HEAD request to '/' and return the 'X-Powered-By' header" do
        stub_request(:head,uri).to_return(
          headers: {'X-Powered-By' => x_powered_by_header}
        )

        expect(subject.powered_by_header(path: path)).to eq(x_powered_by_header)
      end

      context "when also given a method: keyword argument" do
        let(:method) { :get }

        it "must send the HTTP request method to '/' and return the 'X-Server-By' header" do
          stub_request(method,uri).to_return(
            headers: {'X-Powered-By' => x_powered_by_header}
          )

          expect(subject.powered_by_header(method: method, path: path)).to eq(x_powered_by_header)
        end
      end
    end
  end

  describe "#response_body" do
    let(:body) { 'Test body' }

    it "must send a HTTP GET request and return the response body" do
      stub_request(:get,uri).to_return(body: body)

      expect(subject.response_body(path)).to eq(body)
    end

    context "when also given a method argument" do
      let(:method) { :post }

      it "must send the HTTP request method and return the response body" do
        stub_request(method,uri).to_return(body: body)

        expect(subject.response_body(method,path)).to be(body)
      end
    end
  end

  [:copy, :delete, :get, :head, :lock, :mkcol, :move, :options, :patch, :post, :propfind, :proppatch, :put, :trace, :unlock].each do |method|
    describe "##{method}" do
      let(:method) { method }

      it "must send a HTTP #{method.upcase} request and return a Net::HTTP response object" do
        stub_request(method,uri)

        expect(subject.send(method,path)).to be_kind_of(Net::HTTPResponse)
      end
    end
  end

  describe "#get_headers" do
    let(:headers) do
      {'X-Test' => 'foo'}
    end

    it "must send a HTTP GET request for the path and return the response headers" do
      stub_request(:get,uri).to_return(headers: headers)

      expect(subject.get_headers(path)).to eq(headers)
    end
  end

  describe "#get_body" do
    let(:body) { 'Test body' }

    it "must send a HTTP GET request for the path and return the response body" do
      stub_request(:get,uri).to_return(body: body)

      subject.get_body(path)
    end
  end

  describe "#post_headers" do
    let(:headers) do
      {'X-Test' => 'foo'}
    end

    it "must send a HTTP POST request for the path and return the response headers" do
      stub_request(:post,uri).to_return(headers: headers)

      expect(subject.post_headers(path)).to eq(headers)
    end
  end

  describe "#post_body" do
    let(:body) { 'Test body' }

    it "must send a HTTP POST request for the path and return the response body" do
      stub_request(:post,uri).to_return(body: body)

      expect(subject.post_body(path)).to eq(body)
    end
  end

  describe ".request" do
    subject { described_class }

    let(:method) { :get }

    it "must send a request with the given method and path to the host and return an Net::HTTPResponse object" do
      stub_request(method,uri)

      expect(subject.request(method,uri)).to be_kind_of(Net::HTTPResponse)

      expect(WebMock).to have_requested(method,uri)
    end
  end

  describe ".response_status" do
    subject { described_class }

    let(:status) { 200 }

    it "must send a HTTP HEAD request and return the response status code as an Integer" do
      stub_request(:head,uri).to_return(status: status)

      expect(subject.response_status(uri)).to eq(status)
    end

    context "when also given a method argument" do
      let(:method) { :get }

      it "must send the HTTP request method and return the response status code as an Integer" do
        stub_request(method,uri).to_return(status: status)

        expect(subject.response_status(method,uri)).to eq(status)
      end
    end
  end

  describe ".ok?" do
    subject { described_class }

    context "when the HTTP response status is 200" do
      it "must send a HTTP HEAD request and return true" do
        stub_request(:head,uri).to_return(status: 200)

        expect(subject.ok?(uri)).to be(true)
      end

      context "when also given a method argument" do
        let(:method) { :get }

        it "must send the given HTTP request method and return true" do
          stub_request(method,uri).to_return(status: 200)

          expect(subject.ok?(method,uri)).to be(true)
        end
      end
    end

    context "when the HTTP response status is not 200" do
      it "must send a HTTP HEAD request and return false" do
        stub_request(:head,uri).to_return(status: 404)

        expect(subject.ok?(uri)).to be(false)
      end

      context "when also given a method argument" do
        let(:method) { :get }

        it "must send the given HTTP request method and return false" do
          stub_request(method,uri).to_return(status: 404)

          expect(subject.ok?(method,uri)).to be(false)
        end
      end
    end
  end

  describe ".response_headers" do
    subject { described_class }

    let(:headers) do
      {'X-Test' => 'foo' }
    end

    it "send send a HTTP HEAD request and return the capitalized response headers" do
      stub_request(:head,uri).to_return(headers: headers)

      expect(subject.response_headers(uri)).to eq(headers)
    end

    context "when also given a method argument" do
      let(:method) { :get }

      it "send send the HTTP request method and return the capitalized response headers" do
        stub_request(method,uri).to_return(headers: headers)

        expect(subject.response_headers(method,uri)).to eq(headers)
      end
    end
  end

  describe ".server_header" do
    subject { described_class }

    let(:server_header) { 'Apache' }

    it "must send a HTTP HEAD request and return the 'Server' header" do
      stub_request(:head,uri).to_return(
        headers: {'Server' => server_header}
      )

      expect(subject.server_header(uri)).to eq(server_header)
    end

    context "when also given a method argument" do
      let(:method) { :get }

      it "must send the HTTP request method and return the 'Server' header" do
        stub_request(method,uri).to_return(
          headers: {'Server' => server_header}
        )

        expect(subject.server_header(uri, method: method)).to eq(server_header)
      end
    end
  end

  describe ".powered_by_header" do
    subject { described_class }

    let(:x_powered_by_header) { 'PHP/1.2.3' }

    it "must send a HTTP HEAD request and return the 'X-Powered-By' header" do
      stub_request(:head,uri).to_return(
        headers: {'X-Powered-By' => x_powered_by_header}
      )

      expect(subject.powered_by_header(uri)).to eq(x_powered_by_header)
    end

    context "when also given a method: keyword argument" do
      let(:method) { :get }

      it "must send the HTTP request method and return the 'X-Powered-By' header" do
        stub_request(method,uri).to_return(
          headers: {'X-Powered-By' => x_powered_by_header}
        )

        expect(subject.powered_by_header(uri, method: method)).to eq(x_powered_by_header)
      end
    end
  end

  describe ".response_body" do
    subject { described_class }

    let(:body) { 'Test body' }

    it "must send a HTTP GET request and return the response body" do
      stub_request(:get,uri).to_return(body: body)

      expect(subject.response_body(uri)).to eq(body)
    end

    context "when also given a method argument" do
      let(:method) { :post }

      it "must send the HTTP request method and return the response body" do
        stub_request(method,uri).to_return(body: body)

        expect(subject.response_body(method,uri)).to be(body)
      end
    end
  end

  [:copy, :delete, :get, :lock, :mkcol, :move, :options, :patch, :post, :propfind, :proppatch, :put, :trace, :unlock].each do |method|
    describe ".#{method}" do
      subject { described_class }

      let(:method) { method }

      it "must send a HTTP #{method.upcase} request and return a Net::HTTP response object" do
        stub_request(method,uri)

        expect(subject.send(method,uri)).to be_kind_of(Net::HTTPResponse)
      end
    end
  end

  describe ".get_headers" do
    subject { described_class }

    let(:headers) do
      {'X-Test' => 'foo'}
    end

    it "must send a HTTP GET request and return the capitalized response headers" do
      stub_request(:get,uri).to_return(headers: headers)

      expect(subject.get_headers(uri)).to eq(headers)
    end
  end

  describe ".get_body" do
    subject { described_class }

    let(:body) { 'Test body' }

    it "must send a HTTP GET request and return the body" do
      stub_request(:get,uri).to_return(body: body)

      expect(subject.get_body(uri)).to eq(body)
    end
  end

  describe ".post_headers" do
    subject { described_class }

    let(:headers) do
      {'X-Test' => 'foo'}
    end

    it "must send a HTTP POST request and return the capitalized response headers" do
      stub_request(:post,uri).to_return(headers: headers)

      expect(subject.post_headers(uri)).to eq(headers)
    end
  end

  describe ".post_body" do
    subject { described_class }

    let(:body) { 'Test body' }

    it "must send a HTTP POST request and return the body" do
      stub_request(:post,uri).to_return(body: body)

      expect(subject.post_body(uri)).to eq(body)
    end
  end

  describe "integration", :network do
    let(:host) { 'www.example.com' }
    let(:port) { 443 }
    let(:path) { '/index.html' }
    let(:uri)  { URI::HTTPS.build(host: host, port: port, path: path) }

    before(:all) { WebMock.allow_net_connect! }

    describe "#request" do
      it "must return an appropriate Net::HTTP response object" do
        expect(subject.request(:get,path)).to be_kind_of(Net::HTTPOK)
      end
    end

    describe "#response_status" do
      it "must return the response status code as an Integer" do
        expect(subject.response_status(:get,path)).to eq(200)
      end
    end

    describe "#ok?" do
      context "when the HTTP response status is 200" do
        it "must return true" do
          expect(subject.ok?(path)).to be(true)
        end
      end

      context "when the HTTP response status is not 200" do
        let(:path) { '/foo' }

        it "must return false" do
          expect(subject.ok?(path)).to be(false)
        end
      end
    end

    describe "#response_headers" do
      let(:headers) { subject.response_headers(:get,path) }

      it "must return HTTP Headers as a Hash" do
        expect(headers).to be_kind_of(Hash)
        expect(headers).not_to be_empty
      end

      it "must capitalize the HTTP Header names" do
        expect(headers.keys).to all(match(/^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/))
      end
    end

    describe "#response_body" do
      it "must return the response body as a String" do
        body = subject.response_body(:get,path)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end

    describe "#get" do
      it "must send an HTTP GET request and return an appropriate Net::HTTP response object" do
        expect(subject.get(path)).to be_kind_of(Net::HTTPOK)
      end
    end

    describe "#get_headers" do
      let(:headers) { subject.get_headers(path) }

      it "must return HTTP Headers as a Hash" do
        expect(headers).to be_kind_of(Hash)
        expect(headers).not_to be_empty
      end

      it "must capitalize the HTTP Header names" do
        expect(headers.keys).to all(match(/^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/))
      end
    end

    describe "#get_body" do
      it "must return the response body as a String" do
        body = subject.get_body(path)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end

    describe "#head" do
      it "must send an HTTP HEAD request and return an appropriate Net::HTTP response object" do
        expect(subject.head(path)).to be_kind_of(Net::HTTPOK)
      end
    end

    describe "#post_headers" do
      let(:headers) { subject.post_headers(path) }

      it "must return HTTP Headers" do
        expect(headers).to be_kind_of(Hash)
        expect(headers).not_to be_empty
      end

      it "must format the HTTP Headers accordingly" do
        expect(headers.keys).to all(match(/^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/))
      end
    end

    describe "#post_body" do
      it "must return the response body" do
        body = subject.post_body(path)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end

    describe ".request" do
      subject { described_class }

      it "must return an appropriate Net::HTTP response object" do
        expect(subject.request(:get,uri)).to be_kind_of(Net::HTTPOK)
      end
    end

    describe ".response_status" do
      subject { described_class }

      it "must return the response status code as an Integer" do
        expect(subject.response_status(:get,uri)).to eq(200)
      end
    end

    describe ".ok?" do
      context "when the HTTP response status is 200" do
        let(:uri) { URI::HTTPS.build(host: host, port: port) }

        it "must return true" do
          expect(subject.ok?(uri)).to be(true)
        end
      end

      context "when the HTTP response status is not 200" do
        let(:uri) { URI::HTTPS.build(host: host, port: port, path: '/foo') }

        it "must return false" do
          expect(subject.ok?(uri)).to be(false)
        end
      end
    end

    describe ".response_headers" do
      subject { described_class }

      let(:headers) { subject.response_headers(:get,uri) }

      it "must return HTTP Headers as a Hash" do
        expect(headers).to be_kind_of(Hash)
        expect(headers).not_to be_empty
      end

      it "must capitalize the HTTP Header names" do
        expect(headers.keys).to all(match(/^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/))
      end
    end

    describe ".response_body" do
      subject { described_class }

      it "must return the response body as a String" do
        body = subject.response_body(:get,uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end

    describe ".get" do
      subject { described_class }

      it "must send an HTTP GET request and return an appropriate Net::HTTP response object" do
        expect(subject.get(uri)).to be_kind_of(Net::HTTPOK)
      end
    end

    describe ".get_headers" do
      subject { described_class }

      let(:headers) { subject.get_headers(uri) }

      it "must return HTTP Headers as a Hash" do
        expect(headers).to be_kind_of(Hash)
        expect(headers).not_to be_empty
      end

      it "must capitalize the HTTP Header names" do
        expect(headers.keys).to all(match(/^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/))
      end
    end

    describe ".get_body" do
      subject { described_class }

      it "must return the response body as a String" do
        body = subject.get_body(uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end

    describe ".head" do
      subject { described_class }

      it "must send an HTTP HEAD request and return an appropriate Net::HTTP response object" do
        expect(subject.head(uri)).to be_kind_of(Net::HTTPOK)
      end
    end

    describe ".post_headers" do
      subject { described_class }

      let(:headers) { subject.post_headers(uri) }

      it "must return HTTP Headers" do
        expect(headers).to be_kind_of(Hash)
        expect(headers).not_to be_empty
      end

      it "must format the HTTP Headers accordingly" do
        expect(headers.keys).to all(match(/^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/))
      end
    end

    describe ".post_body" do
      subject { described_class }

      it "must return the response body" do
        body = subject.post_body(uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end
  end
end
