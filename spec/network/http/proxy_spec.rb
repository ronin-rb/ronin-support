require 'spec_helper'
require 'ronin/network/http/proxy'

describe Network::HTTP::Proxy do
  describe "parse" do
    subject { described_class }

    it "should parse host-names" do
      proxy = subject.parse('127.0.0.1')

      expect(proxy.host).to eq('127.0.0.1')
    end

    it "should parse 'host:port' URLs" do
      proxy = subject.parse('127.0.0.1:80')

      expect(proxy.host).to eq('127.0.0.1')
      expect(proxy.port).to eq(80)
    end

    it "should parse 'user@host:port' URLs" do
      proxy = subject.parse('joe@127.0.0.1:80')

      expect(proxy.user).to eq('joe')
      expect(proxy.host).to eq('127.0.0.1')
      expect(proxy.port).to eq(80)
    end

    it "should prase 'user:password@host:port' URLs" do
      proxy = subject.parse('joe:lol@127.0.0.1:80')

      expect(proxy.user).to eq('joe')
      expect(proxy.password).to eq('lol')
      expect(proxy.host).to eq('127.0.0.1')
      expect(proxy.port).to eq(80)
    end

    it "should ignore http:// prefixes when parsing proxy URLs" do
      proxy = subject.parse('http://joe:lol@127.0.0.1:80')

      expect(proxy.user).to eq('joe')
      expect(proxy.password).to eq('lol')
      expect(proxy.host).to eq('127.0.0.1')
      expect(proxy.port).to eq(80)
    end
  end

  describe "create" do
    subject { described_class }

    let(:host) { '127.0.0.1' }
    let(:port) { 8080 }

    it "should accept Proxy objects" do
      proxy = subject.new(:host => host, :port => port)

      expect(subject.create(proxy)).to eq(proxy)
    end

    it "should accept URI::HTTP objects" do
      url = URI::HTTP.build(:host => host, :port => port)
      proxy = subject.create(url)

      expect(proxy.host).to eq(host)
      expect(proxy.port).to eq(port)
    end

    it "should accept Hash objects" do
      hash = {:host => host, :port => port}
      proxy = subject.create(hash)

      expect(proxy.host).to eq(host)
      expect(proxy.port).to eq(port)
    end

    it "should accept String objects" do
      string = "#{host}:#{port}"
      proxy = subject.create(string)

      expect(proxy.host).to eq(host)
      expect(proxy.port).to eq(port)
    end

    it "should accept nil" do
      proxy = subject.create(nil)

      expect(proxy).not_to be_enabled
    end
  end

  it "should behave like a Hash" do
    subject[:host] = 'example.com'
    expect(subject[:host]).to eq('example.com')
  end

  it "should not have a host by default" do
    expect(subject.host).to be_nil
  end

  it "should not have a port by default" do
    expect(subject.port).to be_nil
  end

  it "should be disabled by default" do
    expect(subject).not_to be_enabled
  end

  it "should reset the host, port, user and password when disabled" do
    subject[:host] = 'example.com'
    subject[:port] = 9001
    subject[:user] = 'joe'
    subject[:password] = 'lol'

    subject.disable!

    expect(subject[:host]).to be_nil
    expect(subject[:port]).to be_nil
    expect(subject[:user]).to be_nil
    expect(subject[:password]).to be_nil
  end

  it "should return a URI::HTTP representing the proxy" do
    subject[:host] = 'example.com'
    subject[:port] = 9001
    subject[:user] = 'joe'
    subject[:password] = 'lol'

    url = subject.url

    expect(url.host).to eq('example.com')
    expect(url.port).to eq(9001)
    expect(url.user).to eq('joe')
    expect(url.password).to eq('lol')
  end

  it "should return nil when converting a disabled proxy to a URL" do
    expect(subject.url).to be_nil
  end

  it "should return the host-name when converted to a String" do
    subject[:host] = 'example.com'
    expect(subject.to_s).to eq('example.com')
  end

  it "should return an empty String when there is no host-name" do
    expect(subject.to_s).to be_empty
  end
end
