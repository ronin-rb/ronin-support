require 'spec_helper'
require 'ronin/network/http'

describe Network::HTTP do
  describe "proxy" do
    it "should be disabled by default" do
      expect(subject.proxy).not_to be_enabled
    end
  end

  describe "expand_url" do
    let(:url) { URI('http://example.com:443/path?q=1') }

    it "should accept URI objects" do
      options = subject.expand_url(url)

      expect(options[:host]).to eq(url.host)
    end

    it "should accept Hashes" do
      hash = {
        :host => url.host,
        :port => url.port,
      }
      options = subject.expand_url(hash)

      expect(options[:host]).to eq(url.host)
      expect(options[:port]).to eq(url.port)
    end

    it "should accept Strings" do
      options = subject.expand_url(url.to_s)

      expect(options[:host]).to eq(url.host)
      expect(options[:port]).to eq(url.port)
    end

    describe ":path" do
      it "should filter out empty URL paths" do
        options = subject.expand_url(URI('http://example.com'))

        expect(options[:path]).to be_nil
      end

      context "when the path is empty" do
        it "should not be set" do
          options = subject.expand_url(URI('http://example.com'))

          expect(options).not_to have_key(:path)
        end
      end
    end

    describe ":query" do
      it "should set :query to the query string" do
        options = subject.expand_url(url)

        expect(options[:query]).to eq(url.query)
      end

      context "when query is nil" do
        it "should not be set" do
          options = subject.expand_url(URI('http://example.com/path'))

          expect(options).not_to have_key(:query)
        end
      end

      context "when query is empty" do
        it "should be set" do
          options = subject.expand_url(URI('http://example.com/path?'))

          expect(options[:query]).to be_empty
        end
      end
    end

    it "should set :ssl if the URI scheme is 'https'" do
      options = subject.expand_url(URI('https://example.com'))

      expect(options[:ssl]).to eq({})
    end
  end

  describe "expand_options" do
    it "should expand the :ssl option into a Hash" do
      options = {:ssl => true}
      expanded_options = subject.expand_options(options)

      expect(expanded_options[:ssl]).to eq({})
    end

    it "should added a default port and path" do
      options = {:host => 'example.com'}
      expanded_options = subject.expand_options(options)

      expect(expanded_options[:port]).to eq(80)
      expect(expanded_options[:path]).to eq('/')
    end

    it "should add the default proxy settings" do
      options = {:host => 'example.com'}
      expanded_options = subject.expand_options(options)

      expect(expanded_options[:proxy]).to eq(subject.proxy)
    end

    it "should disable the proxy settings if :proxy is nil" do
      options = {:host => 'example.com', :proxy => nil}
      expanded_options = subject.expand_options(options)

      expect(expanded_options[:proxy][:host]).to be_nil
      expect(expanded_options[:proxy][:port]).to be_nil
    end

    it "should not modify :proxy if it is a HTTP::Proxy object" do
      proxy = Network::HTTP::Proxy.new(:host => 'proxy.com', :port => 8181)
      options = {:host => 'example.com', :proxy => proxy}
      expanded_options = subject.expand_options(options)

      expect(expanded_options[:proxy]).to eq(proxy)
    end

    it "should parse the :proxy option" do
      options = {:host => 'example.com', :proxy => 'http://proxy.com:8181'}
      expanded_options = subject.expand_options(options)

      expect(expanded_options[:proxy][:host]).to eq('proxy.com')
      expect(expanded_options[:proxy][:port]).to eq(8181)
    end

    it "should expand the :url option" do
      options = {:url => 'http://joe:secret@example.com:8080/bla?var'}
      expanded_options = subject.expand_options(options)

      expect(expanded_options[:url]).to be_nil
      expect(expanded_options[:host]).to eq('example.com')
      expect(expanded_options[:port]).to eq(8080)
      expect(expanded_options[:user]).to eq('joe')
      expect(expanded_options[:password]).to eq('secret')
      expect(expanded_options[:path]).to eq('/bla')
      expect(expanded_options[:query]).to eq('var')
    end
  end

  describe "headers" do
    it "should convert Symbol options to HTTP Headers" do
      options = {:user_agent => 'bla', :location => 'test'}

      expect(subject.headers(options)).to eq({
        'User-Agent' => 'bla',
        'Location'   => 'test'
      })
    end

    it "should convert String options to HTTP Headers" do
      options = {'user_agent' => 'bla', 'x-powered-by' => 'PHP'}

      expect(subject.headers(options)).to eq({
        'User-Agent'   => 'bla',
        'X-Powered-By' => 'PHP'
      })
    end

    it "should convert all values to Strings" do
      mtime = Time.now.to_i
      options = {:modified_by => mtime, :x_accept => :gzip}

      expect(subject.headers(options)).to eq({
        'Modified-By' => mtime.to_s,
        'X-Accept'    => 'gzip'
      })
    end
  end

  describe "request" do
    it "should handle Symbol names" do
      expect(subject.request(
        :method => :get, :path => '/'
      ).class).to eq(Net::HTTP::Get)
    end

    it "should handle String names" do
      expect(subject.request(
        :method => 'GET', :path => '/'
      ).class).to eq(Net::HTTP::Get)
    end

    context "with :path" do
      it "should use a default path" do
        expect {
          subject.request(:method => :get)
        }.not_to raise_error
      end

      it "should set the path" do
        req = subject.request(:method => :get, :path => '/foo')

        expect(req.path).to eq('/foo')
      end
    end

    context "with :query" do
      let(:path)  { '/foo' }
      let(:query) { 'q=1' }

      it "should append the query-string to the path" do
        req = subject.request(
          :method => :get,
          :path   => path,
          :query  => query
        )

        expect(req.path).to eq("#{path}?#{query}")
      end

      context "when path already contains a query string" do
        let(:additional_query) { 'x=2' }

        it "should append the query using a '&' character" do
          req = subject.request(
            :method => :get,
            :path   => "#{path}?#{query}",
            :query  => additional_query
          )

          expect(req.path).to eq("#{path}?#{query}&#{additional_query}")
        end

        context "when :query is empty" do
          it "should append an extra '&'" do
            req = subject.request(
              :method => :get,
              :path   => "#{path}?#{query}",
              :query  => ''
            )

            expect(req.path).to be_end_with('&')
          end
        end
      end

      context "when :query is empty" do
        it "should append an extra '?'" do
          req = subject.request(
            :method => :get,
            :path   => path,
            :query  => ''
          )

          expect(req.path).to be_end_with('?')
        end
      end
    end

    context "with :user and :password" do
      it "should accept the :user option for Basic-Auth" do
        req = subject.request(:method => :get, :user => 'joe')

        expect(req['authorization']).to eq("Basic am9lOg==")
      end

      it "should also accept the :password options for Basic-Auth" do
        req = subject.request(
          :method => :get,
          :user => 'joe',
          :password => 'secret'
        )

        expect(req['authorization']).to eq("Basic am9lOnNlY3JldA==")
      end
    end

    context "with :method" do
      it "should create HTTP Copy requests" do
        req = subject.request(:method => :copy)

        expect(req.class).to eq(Net::HTTP::Copy)
      end

      it "should create HTTP Delete requests" do
        req = subject.request(:method => :delete)

        expect(req.class).to eq(Net::HTTP::Delete)
      end

      it "should create HTTP Get requests" do
        req = subject.request(:method => :get)

        expect(req.class).to eq(Net::HTTP::Get)
      end

      it "should create HTTP Head requests" do
        req = subject.request(:method => :head)

        expect(req.class).to eq(Net::HTTP::Head)
      end

      it "should create HTTP Lock requests" do
        req = subject.request(:method => :lock)

        expect(req.class).to eq(Net::HTTP::Lock)
      end

      it "should create HTTP Mkcol requests" do
        req = subject.request(:method => :mkcol)

        expect(req.class).to eq(Net::HTTP::Mkcol)
      end

      it "should create HTTP Move requests" do
        req = subject.request(:method => :move)

        expect(req.class).to eq(Net::HTTP::Move)
      end

      it "should create HTTP Options requests" do
        req = subject.request(:method => :options)

        expect(req.class).to eq(Net::HTTP::Options)
      end

      it "should create HTTP Post requests" do
        req = subject.request(:method => :post)

        expect(req.class).to eq(Net::HTTP::Post)
      end

      it "should create HTTP Propfind requests" do
        req = subject.request(:method => :propfind)

        expect(req.class).to eq(Net::HTTP::Propfind)
      end

      it "should create HTTP Proppatch requests" do
        req = subject.request(:method => :proppatch)

        expect(req.class).to eq(Net::HTTP::Proppatch)
      end

      it "should create HTTP Trace requests" do
        req = subject.request(:method => :trace)

        expect(req.class).to eq(Net::HTTP::Trace)
      end

      it "should create HTTP Unlock requests" do
        req = subject.request(:method => :unlock)

        expect(req.class).to eq(Net::HTTP::Unlock)
      end

      it "should raise an UnknownRequest exception for invalid methods" do
        expect {
          subject.request(:method => :bla)
        }.to raise_error(subject::UnknownRequest)
      end
    end

    it "should raise an ArgumentError when :method is not specified" do
      expect {
        subject.request()
      }.to raise_error(ArgumentError)
    end
  end

  describe "helper methods", :network do
    let(:host) { 'www.google.com' }
    let(:port) { 80 }
    let(:path) { '/' }
    let(:uri)  { URI::HTTP.build(:host => host, :port => 80, :path => path) }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    describe "#http_connect" do
      it "should create a Net::HTTP session" do
        http = subject.http_connect(:host => host, :port => port)
        
        expect(http).to be_kind_of(Net::HTTP)
        expect(http).to be_started

        http.finish
      end

      it "should yield the new Net::HTTP session" do
        http = nil

        subject.http_connect(:url => uri) do |session|
          http = session
        end

        expect(http).to be_kind_of(Net::HTTP)
      end

      it "should allow yielding the expanded options" do
        expanded_options = nil

        subject.http_connect(:url => uri) do |session,options|
          expanded_options = options
        end

        expect(expanded_options[:host]).to eq(host)
        expect(expanded_options[:port]).to eq(port)
        expect(expanded_options[:path]).to eq(path)
      end
    end

    describe "#http_session" do
      it "should start and then finish a Net::HTTP session" do
        http = nil
        
        subject.http_session(:host => host, :port => port) do |session|
          http = session
        end
        
        expect(http).to be_kind_of(Net::HTTP)
        expect(http).not_to be_started
      end

      it "should allow yielding the Net::HTTP session" do
        http = nil

        subject.http_session(:url => uri) do |session|
          http = session
        end
        
        expect(http).to be_kind_of(Net::HTTP)
      end

      it "should allow yielding the expanded options" do
        expanded_options = nil

        subject.http_session(:url => uri) do |session,options|
          expanded_options = options
        end

        expect(expanded_options[:host]).to eq(host)
        expect(expanded_options[:port]).to eq(port)
        expect(expanded_options[:path]).to eq(path)
      end
    end

    describe "#http_request" do
      it "should send an arbitrary request and return the response" do
        response = subject.http_request(:url => uri, :method => :options)

        expect(response).to be_kind_of(Net::HTTPMethodNotAllowed)
      end

      it "should allow yielding the request" do
        request = nil

        subject.http_request(:url => uri, :method => :options) do |req|
          request = req
        end

        expect(request).to be_kind_of(Net::HTTP::Options)
      end

      it "should allow yielding the expanded options" do
        expanded_options = nil

        subject.http_request(:url => uri, :method => :options) do |req,options|
          expanded_options = options
        end
        
        expect(expanded_options[:host]).to eq(host)
        expect(expanded_options[:port]).to eq(port)
        expect(expanded_options[:path]).to eq(path)
      end
    end

    describe "#http_status" do
      it "should return an Integer" do
        expect(subject.http_status(:url => uri)).to be_kind_of(Integer)
      end

      it "should return the status-code of the Response" do
        expect(subject.http_status(:url => uri)).to eq(200)
      end
    end

    describe "#http_ok?" do
      it "should check if the Response has code 200" do
        expect(subject.http_ok?(:url => uri)).to be(true)
      end
    end

    describe "#http_server" do
      let(:url)     { "http://www.php.net/" }
      let(:headers) { subject.http_get_headers(:url => url) }

      it "should return the 'Server' header" do
        expect(subject.http_server(:url => url)).to eq(headers['Server'])
      end
    end

    describe "#http_powered_by" do
      let(:url)     { "http://www.php.net/" }
      let(:headers) { subject.http_get_headers(:url => url) }

      it "should return the 'X-Powered-By' header" do
        expect(subject.http_powered_by(:url => url)).to eq(headers['X-Powered-By'])
      end
    end

    describe "#http_get_headers" do
      let(:headers) { subject.http_get_headers(:url => uri) }

      it "should return HTTP Headers" do
        expect(headers).not_to be_empty
      end

      it "should format the HTTP Headers accordingly" do
        format = /^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/
        bad_headers = headers.keys.reject { |name| name =~ format }

        expect(bad_headers).to eq([])
      end
    end

    describe "#http_get_body" do
      it "should return the response body" do
        body = subject.http_get_body(:url => uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end

    describe "#http_post_headers" do
      let(:headers) { subject.http_post_headers(:url => uri) }

      it "should return HTTP Headers" do
        expect(headers).not_to be_empty
      end

      it "should format the HTTP Headers accordingly" do
        format = /^[A-Z][a-z0-9]*(-[A-Z][a-z0-9]*)*$/
        bad_headers = headers.keys.reject { |name| name =~ format }

        expect(bad_headers).to eq([])
      end
    end

    describe "#http_post_body" do
      it "should return the response body" do
        body = subject.http_post_body(:url => uri)

        expect(body).to be_kind_of(String)
        expect(body).not_to be_empty
      end
    end
  end
end
