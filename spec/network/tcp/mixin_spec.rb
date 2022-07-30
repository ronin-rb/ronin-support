require 'spec_helper'
require 'ronin/support/network/tcp/mixin'

require 'resolv'

describe Ronin::Support::Network::TCP::Mixin do
  let(:host) { 'smtp.gmail.com' }
  let(:port) { 587 }

  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  shared_examples "TCP Server" do
    let(:server_host) { 'localhost' }
    let(:server_port) { 1024 + rand(65535 - 1024) }
    let(:server_ip)   { Resolv.getaddress(server_host) }
    let(:server) { TCPServer.new(server_host,server_port) }
    let(:server_bind_ip)   { server.addr[3] }
    let(:server_bind_port) { server.addr[1] }

    before(:each) { server.listen(1) }
    after(:each)  { server.close }
  end

  describe "#tcp_open?" do
    context "integration", :network do
      include_examples "TCP Server"

      let(:host) { server_bind_ip }
      let(:port) { server_bind_port }

      it "must return true for open ports" do
        expect(subject.tcp_open?(host,port)).to be(true)
      end

      let(:closed_port) { port + 1 }

      it "must return false for closed ports" do
        expect(subject.tcp_open?(host,closed_port)).to be(false)
      end

      context "when given a timeout" do
        it "must have a timeout for firewalled ports" do
          timeout = 2

          t1 = Time.now
          subject.tcp_open?(host,port+1, timeout: timeout)
          t2 = Time.now

          expect((t2 - t1).to_i).to be <= timeout
        end
      end
    end
  end

  describe "#tcp_connect" do
    context "integration", :network do
      let(:host) { 'example.com' }
      let(:port) { 80 }

      it "must open a TCPSocket" do
        socket = subject.tcp_connect(host,port)

        expect(socket).to be_kind_of(TCPSocket)
        expect(socket).not_to be_closed

        socket.close
      end

      context "when given a local host and port" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          socket     = subject.tcp_connect(host,port, local_port: local_port)
          bound_port = socket.addr[1]

          expect(bound_port).to eq(local_port)

          socket.close
        end
      end

      context "when given a block" do
        it "must yield the new TCPSocket" do
          socket = nil

          subject.tcp_connect(host,port) do |yielded_socket|
            socket = yielded_socket
          end

          expect(socket).not_to be_closed
          socket.close
        end
      end
    end
  end

  describe "#tcp_connect_and_send" do
    context "integration", :network do
      let(:data) { "HELO ronin-support\n" }

      let(:expected_response) { "250 #{host} at your service\r\n" }

      it "must connect and then send data" do
        socket   = subject.tcp_connect_and_send(data,host,port)
        banner   = socket.readline
        response = socket.readline

        expect(response).to eq(expected_response)

        socket.close
      end

      context "when given a local host and port" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          socket     = subject.tcp_connect_and_send(
                         data,host,port, local_port: local_port
                       )
          bound_port = socket.addr[1]

          expect(bound_port).to eq(local_port)

          socket.close
        end
      end

      context "when given a block" do
        it "must yield the TCPSocket" do
          response = nil

          socket = subject.tcp_connect_and_send(data,host,port) do |socket|
            banner   = socket.readline
            response = socket.readline
          end

          expect(response).to eq(expected_response)

          socket.close
        end
      end
    end
  end

  describe "#tcp_session" do
    context "integration", :network do
      it "must open then close a TCPSocket" do
        socket = nil

        subject.tcp_session(host,port) do |yielded_socket|
          socket = yielded_socket
        end

        expect(socket).to be_kind_of(TCPSocket)
        expect(socket).to be_closed
      end

      context "when given a local host and port" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          bound_port = nil

          subject.tcp_session(host,port, local_port: local_port) do |socket|
            bound_port = socket.addr[1]
          end

          expect(bound_port).to eq(local_port)
        end
      end
    end
  end

  describe "#tcp_banner" do
    context "integration", :network do
      let(:host)       { 'smtp.gmail.com' }
      let(:port)       { 587 }

      let(:expected_banner) do
        /^220 #{Regexp.escape(host)} ESMTP [^\s]+ - gsmtp$/
      end

      it "must return the read service banner" do
        banner = subject.tcp_banner(host,port)

        expect(banner).to match(expected_banner)
      end

      context "when given a local host and port" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          banner = subject.tcp_banner(host,port, local_port: local_port)

          expect(banner).to match(expected_banner)
        end
      end

      context "when given a block" do
        it "must yield the banner" do
          banner = nil

          subject.tcp_banner(host,port) do |yielded_banner|
            banner = yielded_banner
          end

          expect(banner).to match(expected_banner)
        end
      end
    end
  end

  let(:local_host) { 'localhost' }
  let(:local_ip)   { Resolv.getaddress(local_host) }

  describe "#tcp_send" do
    context "integration", :network do
      include_context "TCP Server"

      let(:data) { "hello\n" }

      it "must send data to a service" do
        subject.tcp_send(data,server_bind_ip,server_bind_port)

        client = server.accept
        sent   = client.readline

        client.close

        expect(sent).to eq(data)
      end

      context "when given a local host and port" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          subject.tcp_send(
            data, server_bind_ip, server_bind_port,
            local_host: server_bind_ip,
            local_port: local_port
          )

          client      = server.accept
          client_port = client.peeraddr[1]

          expect(client_port).to eq(local_port)

          client.close
        end
      end
    end
  end

  describe "#tcp_server" do
    context "integration", :network do
      it "must create a new TCPServer" do
        server = subject.tcp_server

        expect(server).to be_kind_of(TCPServer)
        expect(server).not_to be_closed

        server.close
      end

      context "when given a local host and port" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a specific port and host" do
          server     = subject.tcp_server(port: local_port, host: local_host)
          bound_host = server.addr[3]
          bound_port = server.addr[1]

          expect(bound_host).to eq(local_ip)
          expect(bound_port).to eq(local_port)

          server.close
        end
      end

      context "when given a block" do
        it "must yield the new TCPServer" do
          server = nil

          subject.tcp_server do |yielded_server|
            server = yielded_server
          end

          expect(server).to be_kind_of(TCPServer)
          expect(server).not_to be_closed

          server.close
        end
      end
    end
  end

  describe "#tcp_server_session" do
    context "integration", :network do
      it "must create a temporary TCPServer" do
        server = nil

        subject.tcp_server_session do |yielded_server|
          server = yielded_server
        end

        expect(server).to be_kind_of(TCPServer)
        expect(server).to be_closed
      end

      context "when given a block" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a specific port and host" do
          bound_host = nil
          bound_port = nil

          subject.tcp_server_session(port: local_port, host: local_host) do |server|
            bound_host = server.addr[3]
            bound_port = server.addr[1]
          end

          expect(bound_host).to eq(local_ip)
          expect(bound_port).to eq(local_port)
        end
      end
    end
  end

  describe "#tcp_accept" do
    context "integration", :network do
      let(:server_port) { 1024 + rand(65535 - 1024) }

      pending "need to automate connecting to the TCPServer"
    end
  end
end
