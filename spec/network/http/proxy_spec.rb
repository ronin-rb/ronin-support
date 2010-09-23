require 'spec_helper'
require 'ronin/network/http/proxy'

describe Network::HTTP::Proxy do
  describe "parse" do
    subject { Network::HTTP::Proxy }

    it "should parse host-names" do
      proxy = subject.parse('127.0.0.1')

      proxy.host.should == '127.0.0.1'
    end

    it "should parse 'host:port' URLs" do
      proxy = subject.parse('127.0.0.1:80')

      proxy.host.should == '127.0.0.1'
      proxy.port.should == 80
    end

    it "should parse 'user@host:port' URLs" do
      proxy = subject.parse('joe@127.0.0.1:80')

      proxy.user.should == 'joe'
      proxy.host.should == '127.0.0.1'
      proxy.port.should == 80
    end

    it "should prase 'user:password@host:port' URLs" do
      proxy = subject.parse('joe:lol@127.0.0.1:80')

      proxy.user.should == 'joe'
      proxy.password.should == 'lol'
      proxy.host.should == '127.0.0.1'
      proxy.port.should == 80
    end

    it "should ignore http:// prefixes when parsing proxy URLs" do
      proxy = subject.parse('http://joe:lol@127.0.0.1:80')

      proxy.user.should == 'joe'
      proxy.password.should == 'lol'
      proxy.host.should == '127.0.0.1'
      proxy.port.should == 80
    end
  end

  describe "create" do
    subject { Network::HTTP::Proxy }

    let(:host) { '127.0.0.1' }
    let(:port) { 8080 }

    it "should accept Proxy objects" do
      proxy = subject.new(:host => host, :port => port)

      subject.create(proxy).should == proxy
    end

    it "should accept URI::HTTP objects" do
      url = URI::HTTP.build(:host => host, :port => port)
      proxy = subject.create(url)

      proxy.host.should == host
      proxy.port.should == port
    end

    it "should accept Hash objects" do
      hash = {:host => host, :port => port}
      proxy = subject.create(hash)

      proxy.host.should == host
      proxy.port.should == port
    end

    it "should accept String objects" do
      string = "#{host}:#{port}"
      proxy = subject.create(string)

      proxy.host.should == host
      proxy.port.should == port
    end

    it "should accept nil" do
      proxy = subject.create(nil)

      proxy.should_not be_enabled
    end
  end

  subject { Network::HTTP::Proxy.new }

  it "should behave like a Hash" do
    subject[:host] = 'example.com'
    subject[:host].should == 'example.com'
  end

  it "should not have a host by default" do
    subject.host.should be_nil
  end

  it "should not have a port by default" do
    subject.port.should be_nil
  end

  it "should be disabled by default" do
    subject.should_not be_enabled
  end

  it "should reset the host, port, user and password when disabled" do
    subject[:host] = 'example.com'
    subject[:port] = 9001
    subject[:user] = 'joe'
    subject[:password] = 'lol'

    subject.disable!

    subject[:host].should be_nil
    subject[:port].should be_nil
    subject[:user].should be_nil
    subject[:password].should be_nil
  end

  it "should return a URI::HTTP representing the proxy" do
    subject[:host] = 'example.com'
    subject[:port] = 9001
    subject[:user] = 'joe'
    subject[:password] = 'lol'

    url = subject.url

    url.host.should == 'example.com'
    url.port.should == 9001
    url.user.should == 'joe'
    url.password.should == 'lol'
  end

  it "should return nil when converting a disabled proxy to a URL" do
    subject.url.should be_nil
  end

  it "should return the host-name when converted to a String" do
    subject[:host] = 'example.com'
    subject.to_s.should == 'example.com'
  end

  it "should return an empty String when there is no host-name" do
    subject.to_s.should be_empty
  end
end
