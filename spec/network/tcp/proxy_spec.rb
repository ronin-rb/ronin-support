require 'spec_helper'
require 'ronin/network/tcp/proxy'

describe Network::TCP::Proxy, :network => true do
  let(:port)  { 1337              }
  let(:host)  { 'localhost'       }
  let(:server) { ['www.example.com', 80] }

  before(:all) do
  end

  before(:each) do
    @proxy  = described_class.new(:port => port, :host => host, :server => server)
    @thread = Thread.new { @proxy.start }

    sleep 0.1
  end

  describe "#on_client_connect" do
    before do
      @proxy.on_client_connect do |client|
        client.puts "Client connected"
      end

      @socket = TCPSocket.new(host,port)
    end

    it "should trigger when a new client connects" do
      response = @socket.readline.chomp

      response.should == 'Client connected'
    end

    after { @socket.close }
  end

  describe "#on_server_connect" do
    before do
      @proxy.on_server_connect do |client,server|
        client.puts "Server connected"
      end

      @socket = TCPSocket.new(host,port)
    end

    it "should trigger after a new client connects" do
      response = @socket.readline.chomp

      response.should == 'Server connected'
    end

    after { @socket.close }
  end

  describe "#on_client_data" do
    before do
      @proxy.on_client_data do |client,server,data|
        data.gsub!(/HTTP\/1.1/,'HTTP/1.0')
      end

      @socket = TCPSocket.new(host,port)
    end

    it "should trigger when the client sends data" do
      @socket.write("GET / HTTP/1.1\r\n\r\n")

      @socket.readline.should == "HTTP/1.0 302 Found\r\n"
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

      @socket.read.should include("Connection: keep-alive\r\n")
    end

    after { @socket.close }
  end

  after(:each) do
    @thread.kill
    @proxy.close
  end
end
