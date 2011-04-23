require 'spec_helper'
require 'ronin/network/http'

describe Network::HTTP do
  describe "proxy" do
    it "should be disabled by default" do
      subject.proxy.should_not be_enabled
    end
  end

  describe "expand_url" do
    let(:url) { URI('http://example.com:443/path?q=1') }

    it "should accept URI objects" do
      options = subject.expand_url(url)

      options[:host].should == url.host
    end

    it "should accept Hashes" do
      hash = {
        :host => url.host,
        :port => url.port,
      }
      options = subject.expand_url(hash)

      options[:host].should == url.host
      options[:port].should == url.port
    end

    it "should accept Strings" do
      options = subject.expand_url(url.to_s)

      options[:host].should == url.host
      options[:port].should == url.port
    end

    it "should default :path to '/'" do
      options = subject.expand_url(URI('http://example.com'))

      options[:path].should == '/'
    end

    it "should append the query-string to the :path options" do
      options = subject.expand_url(url)

      options[:path].should == "#{url.path}?#{url.query}"
    end

    it "should set :ssl if the URI scheme is 'https'" do
      options = subject.expand_url(URI('https://example.com'))

      options[:ssl].should == {}
    end
  end

  describe "expand_options" do
    it "should expand the :ssl option into a Hash" do
      options = {:ssl => true}
      expanded_options = subject.expand_options(options)

      expanded_options[:ssl].should == {}
    end

    it "should added a default port and path" do
      options = {:host => 'example.com'}
      expanded_options = subject.expand_options(options)

      expanded_options[:port].should == 80
      expanded_options[:path].should == '/'
    end

    it "should add the default proxy settings" do
      options = {:host => 'example.com'}
      expanded_options = subject.expand_options(options)

      expanded_options[:proxy].should == subject.proxy
    end

    it "should disable the proxy settings if :proxy is nil" do
      options = {:host => 'example.com', :proxy => nil}
      expanded_options = subject.expand_options(options)

      expanded_options[:proxy][:host].should be_nil
      expanded_options[:proxy][:port].should be_nil
    end

    it "should not modify :proxy if it is a HTTP::Proxy object" do
      proxy = Network::HTTP::Proxy.new(:host => 'proxy.com', :port => 8181)
      options = {:host => 'example.com', :proxy => proxy}
      expanded_options = subject.expand_options(options)

      expanded_options[:proxy].should == proxy
    end

    it "should parse the :proxy option" do
      options = {:host => 'example.com', :proxy => 'http://proxy.com:8181'}
      expanded_options = subject.expand_options(options)

      expanded_options[:proxy][:host].should == 'proxy.com'
      expanded_options[:proxy][:port].should == 8181
    end

    it "should expand the :url option" do
      options = {:url => 'http://joe:secret@example.com:8080/bla?var'}
      expanded_options = subject.expand_options(options)

      expanded_options[:url].should be_nil
      expanded_options[:host].should == 'example.com'
      expanded_options[:port].should == 8080
      expanded_options[:user].should == 'joe'
      expanded_options[:password].should == 'secret'
      expanded_options[:path].should == '/bla?var'
    end

  end

  describe "headers" do
    it "should convert Symbol options to HTTP Headers" do
      options = {:user_agent => 'bla', :location => 'test'}

      subject.headers(options).should == {
        'User-Agent' => 'bla',
        'Location' => 'test'
      }
    end

    it "should convert String options to HTTP Headers" do
      options = {'user_agent' => 'bla', 'x-powered-by' => 'PHP'}

      subject.headers(options).should == {
        'User-Agent' => 'bla',
        'X-Powered-By' => 'PHP'
      }
    end

    it "should convert all values to Strings" do
      mtime = Time.now.to_i
      options = {:modified_by => mtime, :x_accept => :gzip}

      subject.headers(options).should == {
        'Modified-By' => mtime.to_s,
        'X-Accept' => 'gzip'
      }
    end
  end

  describe "request" do
    it "should handle Symbol names" do
      subject.request(
        :method => :get, :path => '/'
      ).class.should == Net::HTTP::Get
    end

    it "should handle String names" do
      subject.request(
        :method => 'GET', :path => '/'
      ).class.should == Net::HTTP::Get
    end

    it "should raise an UnknownRequest exception for invalid names" do
      lambda {
        subject.request(:method => :bla)
      }.should raise_error(subject::UnknownRequest)
    end

    it "should use a default path" do
      lambda {
        subject.request(:method => :get)
      }.should_not raise_error(ArgumentError)
    end

    it "should accept the :user option for Basic-Auth" do
      req = subject.request(:method => :get, :user => 'joe')

      req['authorization'].should == "Basic am9lOg=="
    end

    it "should accept the :user and :password options for Basic-Auth" do
      req = subject.request(
        :method => :get,
        :user => 'joe',
        :password => 'secret'
      )

      req['authorization'].should == "Basic am9lOnNlY3JldA=="
    end

    it "should create HTTP Copy requests" do
      req = subject.request(:method => :copy)

      req.class.should == Net::HTTP::Copy
    end

    it "should create HTTP Delete requests" do
      req = subject.request(:method => :delete)

      req.class.should == Net::HTTP::Delete
    end

    it "should create HTTP Get requests" do
      req = subject.request(:method => :get)

      req.class.should == Net::HTTP::Get
    end

    it "should create HTTP Head requests" do
      req = subject.request(:method => :head)

      req.class.should == Net::HTTP::Head
    end

    it "should create HTTP Lock requests" do
      req = subject.request(:method => :lock)

      req.class.should == Net::HTTP::Lock
    end

    it "should create HTTP Mkcol requests" do
      req = subject.request(:method => :mkcol)

      req.class.should == Net::HTTP::Mkcol
    end

    it "should create HTTP Move requests" do
      req = subject.request(:method => :move)

      req.class.should == Net::HTTP::Move
    end

    it "should create HTTP Options requests" do
      req = subject.request(:method => :options)

      req.class.should == Net::HTTP::Options
    end

    it "should create HTTP Post requests" do
      req = subject.request(:method => :post)

      req.class.should == Net::HTTP::Post
    end

    it "should create HTTP Propfind requests" do
      req = subject.request(:method => :propfind)

      req.class.should == Net::HTTP::Propfind
    end

    it "should create HTTP Proppatch requests" do
      req = subject.request(:method => :proppatch)

      req.class.should == Net::HTTP::Proppatch
    end

    it "should create HTTP Trace requests" do
      req = subject.request(:method => :trace)

      req.class.should == Net::HTTP::Trace
    end

    it "should create HTTP Unlock requests" do
      req = subject.request(:method => :unlock)

      req.class.should == Net::HTTP::Unlock
    end

    it "should raise an ArgumentError when :method is not specified" do
      lambda {
        subject.request()
      }.should raise_error(ArgumentError)
    end
  end
end
