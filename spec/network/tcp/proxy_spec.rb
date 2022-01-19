require 'spec_helper'
require 'ronin/support/network/tcp/proxy'

describe Network::TCP::Proxy, :network => true do
  let(:port)   { 1337                    }
  let(:host)   { 'localhost'             }
  let(:server) { ['www.example.com', 80] }

  before(:each) do
    @proxy  = described_class.new(
      :port   => port,
      :host   => host,
      :server => server
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

      @socket = TCPSocket.new(host,port)
    end

    it "should trigger when a new client connects" do
      expect(@socket.readline).to eq(injection)
    end

    after { @socket.close }
  end

  describe "#on_server_connect" do
    let(:injection) { "Server connected\r\n" }

    before do
      @proxy.on_server_connect do |client,server|
        client.write(injection)
      end

      @socket = TCPSocket.new(host,port)
    end

    it "should trigger after a new client connects" do
      expect(@socket.readline).to eq(injection)
    end

    after { @socket.close }
  end

  describe "#on_client_data" do
    before do
      @proxy.on_client_data do |client,server,data|
        if (match = data.match(/HTTP\/(\d\.\d)/))
          client.write("HTTP #{match[1]} detected!\r\n")
        end
      end

      @socket = TCPSocket.new(host,port)
    end

    it "should trigger when the client sends data" do
      @socket.write("GET /placeholder HTTP/1.0\r\n\r\n")

      expect(@socket.readline).to eq("HTTP 1.0 detected!\r\n")
    end

    after { @socket.close }
  end

  describe "#on_server_data" do
    before do
      @proxy.on_server_data do |client,server,data|
        data.gsub!(/Connection: \S+/,'Connection: keep-alive')
      end

      @socket = TCPSocket.new(host,port)
    end

    it "should trigger when the server sends data" do
      @socket.write("GET / HTTP/1.0\r\n\r\n")

      expect(@socket.read).to include("Connection: keep-alive\r\n")
    end

    after { @socket.close }
  end

  describe "#on_server_disconnect" do
    let(:injection) { "Haha Internet!\r\n" }

    before do
      @proxy.on_server_disconnect do |client,server|
        client.write(injection)
      end

      @socket = TCPSocket.new(host,port)
    end

    it "should trigger when the server closes the connection" do
      @socket.write("GET / HTTP/1.0\r\n\r\n")

      expect(@socket.read.end_with?(injection)).to be(true)
    end

    after { @socket.close }
  end

  after(:each) do
    @thread.kill
    @proxy.close
  end
end
