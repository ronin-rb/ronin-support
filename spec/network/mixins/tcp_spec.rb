require 'spec_helper'
require 'ronin/network/mixins/tcp'

require 'resolv'

describe Network::Mixins::TCP do
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

    before do
      subject.host = host
      subject.port = port
    end

    describe "#tcp_open?" do
      let(:host) { 'example.com' }
      let(:port) { 80 }

      it "should return true for open ports" do
        subject.tcp_open?.should == true
      end

      it "should return false for closed ports" do
        subject.host = 'localhost'
        subject.port = rand(1024) + 1

        subject.tcp_open?.should == false
      end

      it "should have a timeout for firewalled ports" do
        subject.port = 1337

        timeout = 2

        t1 = Time.now
        subject.tcp_open?(timeout)
        t2 = Time.now

        (t2 - t1).to_i.should <= timeout
      end
    end

    describe "#tcp_connect" do
      let(:local_port) { 1024 + rand(65535 - 1024) }

      it "should open a TCPSocket" do
        socket = subject.tcp_connect

        socket.should be_kind_of(TCPSocket)
        socket.should_not be_closed

        socket.close
      end

      it "should bind to a local host and port" do
        subject.local_port = local_port

        socket     = subject.tcp_connect
        bound_port = socket.addr[1]

        bound_port.should == local_port

        socket.close
      end

      it "should yield the new TCPSocket" do
        socket = nil

        subject.tcp_connect do |yielded_socket|
          socket = yielded_socket
        end

        socket.should_not be_closed
        socket.close
      end
    end

    describe "#tcp_connect_and_send" do
      let(:data) { "HELO ronin\n" }
      let(:local_port) { 1024 + rand(65535 - 1024) }

      let(:expected_response) { "250 mx.google.com at your service\r\n" }

      it "should connect and then send data" do
        socket   = subject.tcp_connect_and_send(data)
        banner   = socket.readline
        response = socket.readline

        response.should == expected_response

        socket.close
       end

      it "should bind to a local host and port" do
        subject.local_port = local_port

        socket     = subject.tcp_connect_and_send(data)
        bound_port = socket.addr[1]

        bound_port.should == local_port

        socket.close
      end

      it "should yield the TCPSocket" do
        response = nil

        socket = subject.tcp_connect_and_send(data) do |socket|
          banner   = socket.readline
          response = socket.readline
        end

        response.should == expected_response

        socket.close
      end
    end

    describe "#tcp_session" do
      let(:local_port) { 1024 + rand(65535 - 1024) }

      it "should open then close a TCPSocket" do
        socket = nil

        subject.tcp_session do |yielded_socket|
          socket = yielded_socket
        end

        socket.should be_kind_of(TCPSocket)
        socket.should be_closed
      end

      it "should bind to a local host and port" do
        subject.local_port = local_port

        bound_port = nil

        subject.tcp_session do |socket|
          bound_port = socket.addr[1]
        end

        bound_port.should == local_port
      end
    end

    describe "#tcp_banner" do
      let(:host)       { 'smtp.gmail.com' }
      let(:port)       { 25 }
      let(:local_port) { 1024 + rand(65535 - 1024) }

      let(:expected_banner) { /^220 mx\.google\.com ESMTP/ }

      it "should return the read service banner" do
        banner = subject.tcp_banner

        banner.should =~ expected_banner
      end

      it "should bind to a local host and port" do
        subject.local_port = local_port

        banner = subject.tcp_banner

        banner.should =~ expected_banner
      end

      it "should yield the banner" do
        banner = nil
        
        subject.tcp_banner do |yielded_banner|
          banner = yielded_banner
        end

        banner.should =~ expected_banner
      end
    end

    describe "#tcp_send" do
      let(:server)      { TCPServer.new(server_host,0) }
      let(:server_port) { server.addr[1] }

      let(:data)       { "hello\n" }
      let(:local_port) { 1024 + rand(65535 - 1024) }

      before do
        subject.host = server_host
        subject.port = server_port
      end

      after(:all)  { server.close }

      it "should send data to a service" do
        subject.tcp_send(data)

        client = server.accept
        sent   = client.readline

        client.close

        sent.should == data
      end

      it "should bind to a local host and port" do
        subject.local_port = local_port

        subject.tcp_send(data)

        client      = server.accept
        client_port = client.peeraddr[1]

        client_port.should == local_port

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
        subject.server_port = server_port
        subject.server_host = server_host

        server     = subject.tcp_server
        bound_host = server.addr[3]
        bound_port = server.addr[1]

        bound_host.should == server_ip
        bound_port.should == server_port

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
        subject.server_port = server_port
        subject.server_host = server_host

        bound_host = nil
        bound_port = nil
        
        subject.tcp_server_session do |yielded_server|
          bound_host = yielded_server.addr[3]
          bound_port = yielded_server.addr[1]
        end

        bound_host.should == server_ip
        bound_port.should == server_port
      end
    end

    describe "#tcp_server_loop" do
      pending "need to automate connecting to the TCPServer"
    end

    describe "#tcp_accept" do
      pending "need to automate connecting to the TCPServer"
    end
  end
end
