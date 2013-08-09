require 'spec_helper'
require 'ronin/network/http'

describe Network::HTTP do
  describe "proxy" do
    it "should be disabled by default" do
      subject.proxy.should_not be_enabled
    end
  end

  describe "options_from" do
    let(:url) { URI('http://example.com:443/path?q=1') }

    it "should accept URI objects" do
      options = subject.options_from(url)

      options[:host].should == url.host
    end

    it "should accept Hashes" do
      hash = {
        host: url.host,
        port: url.port,
      }
      options = subject.options_from(hash)

      options[:host].should == url.host
      options[:port].should == url.port
    end

    it "should accept Strings" do
      options = subject.options_from(url.to_s)

      options[:host].should == url.host
      options[:port].should == url.port
    end

    describe ":path" do
      it "should filter out empty URL paths" do
        options = subject.options_from(URI('http://example.com'))

        options[:path].should be_nil
      end

      context "when the path is empty" do
        it "should not be set" do
          options = subject.options_from(URI('http://example.com'))

          options.should_not have_key(:path)
        end
      end
    end

    describe ":query" do
      it "should set :query to the query string" do
        options = subject.options_from(url)

        options[:query].should == url.query
      end

      context "when query is nil" do
        it "should not be set" do
          options = subject.options_from(URI('http://example.com/path'))

          options.should_not have_key(:query)
        end
      end

      context "when query is empty" do
        it "should be set" do
          options = subject.options_from(URI('http://example.com/path?'))

          options[:query].should be_empty
        end
      end
    end

    it "should set :ssl if the URI scheme is 'https'" do
      options = subject.options_from(URI('https://example.com'))

      options[:ssl].should == {}
    end
  end

  describe "normalize_options" do
    it "should expand the :ssl option into a Hash" do
      options = {ssl: true}
      expanded_options = subject.normalize_options(options)

      expanded_options[:ssl].should == {}
    end

    it "should added a default port and path" do
      options = {host: 'example.com'}
      expanded_options = subject.normalize_options(options)

      expanded_options[:port].should == 80
      expanded_options[:path].should == '/'
    end

    it "should add the default proxy settings" do
      options = {host: 'example.com'}
      expanded_options = subject.normalize_options(options)

      expanded_options[:proxy].should == subject.proxy
    end

    it "should disable the proxy settings if :proxy is nil" do
      options = {host: 'example.com', proxy: nil}
      expanded_options = subject.normalize_options(options)

      expanded_options[:proxy][:host].should be_nil
      expanded_options[:proxy][:port].should be_nil
    end

    it "should not modify :proxy if it is a HTTP::Proxy object" do
      proxy = Network::HTTP::Proxy.new(host: 'proxy.com', port: 8181)
      options = {host: 'example.com', proxy: proxy}
      expanded_options = subject.normalize_options(options)

      expanded_options[:proxy].should == proxy
    end

    it "should parse the :proxy option" do
      options = {host: 'example.com', proxy: 'http://proxy.com:8181'}
      expanded_options = subject.normalize_options(options)

      expanded_options[:proxy][:host].should == 'proxy.com'
      expanded_options[:proxy][:port].should == 8181
    end

    it "should expand the :url option" do
      options = {url: 'http://joe:secret@example.com:8080/bla?var'}
      expanded_options = subject.normalize_options(options)

      expanded_options[:url].should be_nil
      expanded_options[:host].should == 'example.com'
      expanded_options[:port].should == 8080
      expanded_options[:user].should == 'joe'
      expanded_options[:password].should == 'secret'
      expanded_options[:path].should == '/bla'
      expanded_options[:query].should == 'var'
    end
  end

  describe "headers" do
    it "should convert Symbol options to HTTP Headers" do
      options = {user_agent: 'bla', location: 'test'}

      subject.headers(options).should == {
        'User-Agent' => 'bla',
        'Location'   => 'test'
      }
    end

    it "should convert String options to HTTP Headers" do
      options = {'user_agent' => 'bla', 'x-powered-by' => 'PHP'}

      subject.headers(options).should == {
        'User-Agent'   => 'bla',
        'X-Powered-By' => 'PHP'
      }
    end

    it "should convert all values to Strings" do
      mtime = Time.now.to_i
      options = {modified_by: mtime, x_accept: :gzip}

      subject.headers(options).should == {
        'Modified-By' => mtime.to_s,
        'X-Accept'    => 'gzip'
      }
    end
  end

  describe "request" do
    it "should handle Symbol names" do
      subject.request(
        method: :get, path: '/'
      ).class.should == Net::HTTP::Get
    end

    it "should handle String names" do
      subject.request(
        method: 'GET', path: '/'
      ).class.should == Net::HTTP::Get
    end

    context "with :path" do
      it "should use a default path" do
        lambda {
          subject.request(method: :get)
        }.should_not raise_error
      end

      it "should set the path" do
        req = subject.request(method: :get, path: '/foo')

        req.path.should == '/foo'
      end
    end

    context "with :query" do
      let(:path)  { '/foo' }
      let(:query) { 'q=1' }

      it "should append the query-string to the path" do
        req = subject.request(
          method: :get,
          path:   path,
          query:  query
        )

        req.path.should == "#{path}?#{query}"
      end

      context "when path already contains a query string" do
        let(:additional_query) { 'x=2' }

        it "should append the query using a '&' character" do
          req = subject.request(
            method: :get,
            path:   "#{path}?#{query}",
            query:  additional_query
          )

          req.path.should == "#{path}?#{query}&#{additional_query}"
        end

        context "when :query is empty" do
          it "should append an extra '&'" do
            req = subject.request(
              method: :get,
              path:   "#{path}?#{query}",
              query:  ''
            )

            req.path.should be_end_with('&')
          end
        end
      end

      context "when :query is empty" do
        it "should append an extra '?'" do
          req = subject.request(
            method: :get,
            path:   path,
            query:  ''
          )

          req.path.should be_end_with('?')
        end
      end
    end

    context "with :user and :password" do
      it "should accept the :user option for Basic-Auth" do
        req = subject.request(method: :get, user: 'joe')

        req['authorization'].should == "Basic am9lOg=="
      end

      it "should also accept the :password options for Basic-Auth" do
        req = subject.request(
          method:   :get,
          user:     'joe',
          password: 'secret'
        )

        req['authorization'].should == "Basic am9lOnNlY3JldA=="
      end
    end

    context "with :method" do
      it "should create HTTP Copy requests" do
        req = subject.request(method: :copy)

        req.class.should == Net::HTTP::Copy
      end

      it "should create HTTP Delete requests" do
        req = subject.request(method: :delete)

        req.class.should == Net::HTTP::Delete
      end

      it "should create HTTP Get requests" do
        req = subject.request(method: :get)

        req.class.should == Net::HTTP::Get
      end

      it "should create HTTP Head requests" do
        req = subject.request(method: :head)

        req.class.should == Net::HTTP::Head
      end

      it "should create HTTP Lock requests" do
        req = subject.request(method: :lock)

        req.class.should == Net::HTTP::Lock
      end

      it "should create HTTP Mkcol requests" do
        req = subject.request(method: :mkcol)

        req.class.should == Net::HTTP::Mkcol
      end

      it "should create HTTP Move requests" do
        req = subject.request(method: :move)

        req.class.should == Net::HTTP::Move
      end

      it "should create HTTP Options requests" do
        req = subject.request(method: :options)

        req.class.should == Net::HTTP::Options
      end

      it "should create HTTP Post requests" do
        req = subject.request(method: :post)

        req.class.should == Net::HTTP::Post
      end

      it "should create HTTP Propfind requests" do
        req = subject.request(method: :propfind)

        req.class.should == Net::HTTP::Propfind
      end

      it "should create HTTP Proppatch requests" do
        req = subject.request(method: :proppatch)

        req.class.should == Net::HTTP::Proppatch
      end

      it "should create HTTP Trace requests" do
        req = subject.request(method: :trace)

        req.class.should == Net::HTTP::Trace
      end

      it "should create HTTP Unlock requests" do
        req = subject.request(method: :unlock)

        req.class.should == Net::HTTP::Unlock
      end

      it "should raise an UnknownRequest exception for invalid methods" do
        lambda {
          subject.request(method: :bla)
        }.should raise_error(subject::UnknownRequest)
      end
    end

    it "should raise an ArgumentError when :method is not specified" do
      lambda {
        subject.request()
      }.should raise_error(ArgumentError)
    end
  end

  describe "helper methods", :network do
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
      it "should create a Net::HTTP session" do
        http = subject.http_connect(host: host, port: port)
        
        http.should be_kind_of(Net::HTTP)
        http.should be_started

        http.finish
      end

      it "should yield the new Net::HTTP session" do
        http = nil

        subject.http_connect(url: uri) do |session|
          http = session
        end

        http.should be_kind_of(Net::HTTP)
      end

      it "should allow yielding the expanded options" do
        expanded_options = nil

        subject.http_connect(url: uri) do |session,options|
          expanded_options = options
        end

        expanded_options[:host].should == host
        expanded_options[:port].should == port
        expanded_options[:path].should == path
      end
    end

    describe "#http_session" do
      it "should start and then finish a Net::HTTP session" do
        http = nil
        
        subject.http_session(host: host, port: port) do |session|
          http = session
        end
        
        http.should be_kind_of(Net::HTTP)
        http.should_not be_started
      end

      it "should allow yielding the Net::HTTP session" do
        http = nil

        subject.http_session(url: uri) do |session|
          http = session
        end
        
        http.should be_kind_of(Net::HTTP)
      end

      it "should allow yielding the expanded options" do
        expanded_options = nil

        subject.http_session(url: uri) do |session,options|
          expanded_options = options
        end

        expanded_options[:host].should == host
        expanded_options[:port].should == port
        expanded_options[:path].should == path
      end
    end

    describe "#http_request" do
      it "should send an arbitrary request and return the response" do
        response = subject.http_request(url: uri, method: :options)

        response.should be_kind_of(Net::HTTPMethodNotAllowed)
      end

      it "should allow yielding the request" do
        request = nil

        subject.http_request(url: uri, method: :options) do |req|
          request = req
        end

        request.should be_kind_of(Net::HTTP::Options)
      end

      it "should allow yielding the expanded options" do
        expanded_options = nil

        subject.http_request(url: uri, method: :options) do |req,options|
          expanded_options = options
        end
        
        expanded_options[:host].should == host
        expanded_options[:port].should == port
        expanded_options[:path].should == path
      end
    end

    describe "#http_status" do
      it "should return an Integer" do
        subject.http_status(url: uri).should be_kind_of(Integer)
      end

      it "should return the status-code of the Response" do
        subject.http_status(url: uri).should == 200
      end
    end

    describe "#http_ok?" do
      it "should check if the Response has code 200" do
        subject.http_ok?(url: uri).should == true
      end
    end

    describe "#http_server" do
      let(:url)     { "http://www.php.net/" }
      let(:headers) { subject.http_get_headers(url: url) }

      it "should return the 'Server' header" do
        subject.http_server(url: url).should == headers['Server']
      end
    end

    describe "#http_powered_by" do
      let(:url)     { "http://www.php.net/" }
      let(:headers) { subject.http_get_headers(url: url) }

      it "should return the 'X-Powered-By' header" do
        subject.http_powered_by(url: url).should == headers['X-Powered-By']
      end
    end

    describe "#http_get_headers" do
      let(:headers) { subject.http_get_headers(url: uri) }

      it "should return HTTP Headers" do
        headers.should_not be_empty
      end

      it "should format the HTTP Headers accordingly" do
        format = /^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/
        bad_headers = headers.keys.reject { |name| name =~ format }

        bad_headers.should == []
      end
    end

    describe "#http_get_body" do
      it "should return the response body" do
        body = subject.http_get_body(url: uri)

        body.should be_kind_of(String)
        body.should_not be_empty
      end
    end

    describe "#http_post_headers" do
      let(:headers) { subject.http_post_headers(url: uri) }

      it "should return HTTP Headers" do
        headers.should_not be_empty
      end

      it "should format the HTTP Headers accordingly" do
        format = /^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/
        bad_headers = headers.keys.reject { |name| name =~ format }

        bad_headers.should == []
      end
    end

    describe "#http_post_body" do
      it "should return the response body" do
        body = subject.http_post_body(url: uri)

        body.should be_kind_of(String)
        body.should_not be_empty
      end
    end
  end
end
