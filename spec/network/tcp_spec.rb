require 'spec_helper'
require 'ronin/network/tcp'

require 'resolv'

describe Network::TCP do
  describe "helper methods", :network do
    let(:host) { 'smtp.gmail.com' }
    let(:port) { 25 }

    let(:server_host) { 'localhost' }
    let(:server_ip)   { Resolv.getaddress(server_host) }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    describe "#tcp_connect" do
      let(:local_port) { 1024 + rand(65535 - 1024) }

      it "should open a TCPSocket" do
        socket = subject.tcp_connect(host,port)

        socket.should be_kind_of(TCPSocket)
        socket.should_not be_closed

        socket.close
      end

      it "should bind to a local host and port" do
        socket        = subject.tcp_connect(host,port,nil,local_port)

        local_address = socket.local_address
        local_address.ip_port.should == local_port

        socket.close
      end

      it "should yield the new TCPSocket" do
        socket = nil

        subject.tcp_connect(host,port) do |yielded_socket|
          socket = yielded_socket
        end

        socket.should_not be_closed
        socket.close
      end
    end

    describe "#tcp_connect_and_send" do
      let(:data) { "HELO ronin\n" }
      let(:local_port) { 1024 + rand(65535 - 1024) }

      it "should connect and then send data" do
        socket   = subject.tcp_connect_and_send(data,host,port)
        banner   = socket.readline
        response = socket.readline

        response.start_with?('250').should be_true

        socket.close
       end

      it "should bind to a local host and port" do
        socket = subject.tcp_connect_and_send(data,host,port,nil,local_port)

        local_address = socket.local_address
        local_address.ip_port.should == local_port

        socket.close
      end

      it "should yield the TCPSocket" do
        response = nil

        socket = subject.tcp_connect_and_send(data,host,port) do |socket|
          banner   = socket.readline
          response = socket.readline
        end

        response.start_with?('250').should be_true

        socket.close
      end
    end

    describe "#tcp_session" do
      let(:local_port) { 1024 + rand(65535 - 1024) }

      it "should open then close a TCPSocket" do
        socket = nil

        subject.tcp_session(host,port) do |yielded_socket|
          socket = yielded_socket
        end

        socket.should be_kind_of(TCPSocket)
        socket.should be_closed
      end

      it "should bind to a local host and port" do
        local_address = nil

        subject.tcp_session(host,port,nil,local_port) do |socket|
          local_address = socket.local_address
        end

        local_address.ip_port.should == local_port
      end
    end

    describe "#tcp_banner" do
      let(:host) { 'smtp.gmail.com' }
      let(:port) { 25 }

      let(:local_port) { 1024 + rand(65535 - 1024) }

      it "should read the service banner" do
        banner = subject.tcp_banner(host,port)

        banner.start_with?('220').should be_true
      end

      it "should bind to a local host and port" do
        banner = subject.tcp_banner(host,port,nil,local_port)

        banner.start_with?('220').should be_true
      end

      it "should yield the banner" do
        banner = nil
        
        subject.tcp_banner(host,port) do |yielded_banner|
          banner = yielded_banner
        end

        banner.start_with?('220').should be_true
      end
    end

    describe "#tcp_send" do
      let(:server)      { TCPServer.new(server_host,nil) }
      let(:server_port) { server.local_address.ip_port }

      let(:data)       { "hello\n" }
      let(:local_port) { 1024 + rand(65535 - 1024) }

      after(:all) { server.close }

      it "should send data to a service" do
        subject.tcp_send(data,server_host,server_port)

        client = server.accept
        sent   = client.readline

        client.close

        sent.should == data
      end

      it "should bind to a local host and port" do
        subject.tcp_send(data,server_host,server_port,nil,local_port)

        client = server.accept

        client_address = client.remote_address
        client_address.ip_port.should == local_port

        client.close
      end
    end

    describe "#tcp_server" do
      let(:server_port) { 1024 + rand(65535 - 1024) }

      it "should create a new TCPServer" do
        server = subject.tcp_server

        server.should be_kind_of(TCPServer)
        server.should_not be_closed

        server.close
      end

      it "should bind to a specific port and host" do
        server = subject.tcp_server(server_port,server_host)

        local_address = server.local_address
        local_address.ip_address.should == server_ip
        local_address.ip_port.should    == server_port

        server.close
      end

      it "should yield the new TCPServer" do
        server = nil
        
        subject.tcp_server do |yielded_server|
          server = yielded_server
        end

        server.should be_kind_of(TCPServer)
        server.should_not be_closed

        server.close
      end
    end

    describe "#tcp_server_session" do
      let(:server_port) { 1024 + rand(65535 - 1024) }

      it "should create a temporary TCPServer" do
        server = nil
        
        subject.tcp_server_session do |yielded_server|
          server = yielded_server
        end

        server.should be_kind_of(TCPServer)
        server.should be_closed
      end

      it "should bind to a specific port and host" do
        local_address = nil
        
        subject.tcp_server_session(server_port,server_host) do |yielded_server|
          local_address = yielded_server.local_address
        end

        local_address.ip_address.should == server_ip
        local_address.ip_port.should    == server_port
      end
    end

    describe "#tcp_single_server" do
      let(:server_port) { 1024 + rand(65535 - 1024) }

      pending "need to automate connecting to the TCPServer"
    end
  end
end
