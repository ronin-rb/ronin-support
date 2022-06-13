require 'spec_helper'
require 'ronin/support/network/ssl/proxy'
require 'ronin/support/network/ssl/mixin'

describe Network::SSL::Proxy, network: true do
  include Ronin::Support::Network::SSL::Mixin

  let(:port)   { 1337                  }
  let(:host)   { 'localhost'           }
  let(:server) { ['www.iana.org', 443] }

  let(:request) { "GET / HTTP/1.1\r\nHost: #{server[0]}\r\n\r\n" }

  before(:each) do
    @proxy  = described_class.new(
      port:   port,
      host:   host,
      server: server
    )
    @thread = Thread.new { @proxy.start }

    sleep 0.1
  end

  describe "#on_client_connect" do
    let(:injection) { "Client connected\r\n" }

    before do
      @proxy.on_client_connect do |client|
        client.write(injection)
      end

      @socket = ssl_connect(host,port)
    end

    it "must trigger when a new client connects" do
      @socket.readline.should == injection
    end

    after { @socket.close }
  end

  describe "#on_server_connect" do
    let(:injection) { "Server connected\r\n" }

    before do
      @proxy.on_server_connect do |client,server|
        client.write(injection)
      end

      @socket = ssl_connect(host,port)
    end

    it "must trigger after a new client connects" do
      @socket.readline.should == injection
    end

    after { @socket.close }
  end

  describe "#on_client_data" do
    before do
      @proxy.on_client_data do |client,server,data|
        data.gsub!('GET /','GET /foo')
      end

      @socket = ssl_connect(host,port)
    end

    it "must trigger when the client sends data" do
      @socket.write(request)

      @socket.readline.should == "HTTP/1.1 404 NOT FOUND\r\n"
    end

    after { @socket.close }
  end

  describe "#on_server_data" do
    before do
      @proxy.on_server_data do |client,server,data|
        data.gsub!(/Connection: \S+/,'Connection: keep-alive')
      end

      @socket = ssl_connect(host,port)
    end

    it "must trigger when the server sends data" do
      @socket.write(request)

      @socket.read.should include("Connection: keep-alive\r\n")
    end

    after { @socket.close }
  end

  describe "#on_server_disconnect" do
    let(:injection) { "Haha Internet!\r\n" }

    before do
      @proxy.on_server_disconnect do |client,server|
        client.write(injection)
      end

      @socket = ssl_connect(host,port)
    end

    it "must trigger when the server closes the connection" do
      @socket.write(request)

      @socket.read.end_with?(injection).should be_true
    end

    after { @socket.close }
  end

  after(:each) do
    @thread.kill
    @proxy.close
  end
end
