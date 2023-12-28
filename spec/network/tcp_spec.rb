require 'spec_helper'
require 'ronin/support/network/tcp'

require 'resolv'

describe Ronin::Support::Network::TCP do
  let(:host) { 'smtp.gmail.com' }
  let(:port) { 587 }

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

  describe ".open?" do
    context "integration", :network do
      include_examples "TCP Server"

      let(:host) { server_bind_ip }
      let(:port) { server_bind_port }

      it "must return true for open ports" do
        expect(subject.open?(host,port)).to be(true)
      end

      let(:closed_port) { port + 1 }

      it "must return false for closed ports" do
        expect(subject.open?(host,closed_port)).to be(false)
      end

      context "when given a timeout" do
        it "must have a timeout for firewalled ports" do
          closed_port = port + 1
          timeout     = 2

          t1 = Time.now
          subject.open?(host,closed_port, timeout: timeout)
          t2 = Time.now

          expect((t2 - t1).to_i).to be <= timeout
        end
      end
    end
  end

  describe ".connect" do
    context "integration", :network do
      let(:host) { 'example.com' }
      let(:port) { 80 }

      it "must open a TCPSocket" do
        socket = subject.connect(host,port)

        expect(socket).to be_kind_of(TCPSocket)
        expect(socket).not_to be_closed

        socket.close
      end

      context "when given a unicode hostname" do
        let(:host)  { "www.詹姆斯.com" }
        let(:ips) do
          %w[
            104.21.6.29
            172.67.154.155
            2606:4700:3036::ac43:9a9b
            2606:4700:3037::6815:61d
          ]
        end

        it "must convert the unicode hostname to the punycode version" do
          socket = subject.connect(host,port)

          expect(ips).to include(socket.remote_address.ip_address)
        end
      end

      context "when given the bind_port: keyword argument" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to the local port" do
          socket     = subject.connect(host,port, bind_port: bind_port)
          bound_port = socket.addr[1]

          expect(bound_port).to eq(bind_port)

          socket.close
        end
      end

      context "when given a block" do
        it "must open then close a TCPSocket" do
          socket = nil

          subject.connect(host,port) do |yielded_socket|
            socket = yielded_socket
          end

          expect(socket).to be_kind_of(TCPSocket)
          expect(socket).to be_closed
        end

        it "must return the block's return value" do
          returned_value = subject.connect(host,port) do |socket|
            :return_value
          end

          expect(returned_value).to eq(:return_value)
        end

        context "when the block raises an exception" do
          it "must close the TCPSocket" do
            socket = nil

            expect do
              subject.connect(host,port) do |yielded_socket|
                socket = yielded_socket
                raise "test exception"
              end
            end.to raise_error("test exception")

            expect(socket).to be_kind_of(TCPSocket)
            expect(socket).to be_closed
          end
        end

        context "when given the bind_port: keyword argument" do
          let(:bind_port) { 1024 + rand(65535 - 1024) }

          it "must bind to the local port" do
            bound_port = nil

            subject.connect(host,port, bind_port: bind_port) do |socket|
              bound_port = socket.addr[1]
            end

            expect(bound_port).to eq(bind_port)
          end
        end
      end
    end
  end

  describe ".connect_and_send" do
    context "integration", :network do
      let(:data) { "HELO ronin-support\n" }

      let(:expected_response) { "250 #{host} at your service\r\n" }

      it "must connect and then send data" do
        socket = subject.connect_and_send(data,host,port)

        # ignore the banner
        socket.readline

        response = socket.readline

        expect(response).to eq(expected_response)

        socket.close
      end

      context "when given a local host and port" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          socket     = subject.connect_and_send(
                         data,host,port, bind_port: bind_port
                       )
          bound_port = socket.addr[1]

          expect(bound_port).to eq(bind_port)

          socket.close
        end
      end

      context "when given a block" do
        it "must yield the TCPSocket" do
          response = nil

          socket = subject.connect_and_send(data,host,port) do |new_socket|
            # ignore the banner
            new_socket.readline

            response = new_socket.readline
          end

          expect(response).to eq(expected_response)

          socket.close
        end
      end
    end
  end

  describe ".banner" do
    context "integration", :network do
      let(:host)       { 'smtp.gmail.com' }
      let(:port)       { 587 }

      let(:expected_banner) do
        /^220 #{Regexp.escape(host)} ESMTP [^\s]+ - gsmtp$/
      end

      it "must return the read service banner" do
        banner = subject.banner(host,port)

        expect(banner).to match(expected_banner)
      end

      context "when given a local host and port" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          banner = subject.banner(host,port, bind_port: bind_port)

          expect(banner).to match(expected_banner)
        end
      end

      context "when given a block" do
        it "must yield the banner" do
          banner = nil

          subject.banner(host,port) do |yielded_banner|
            banner = yielded_banner
          end

          expect(banner).to match(expected_banner)
        end
      end
    end
  end

  let(:bind_host) { 'localhost' }
  let(:local_ip)  { Resolv.getaddress(bind_host) }

  describe ".send" do
    context "integration", :network do
      include_context "TCP Server"

      let(:data) { "hello\n" }

      it "must send data to a service" do
        subject.send(data,server_bind_ip,server_bind_port)

        client = server.accept
        sent   = client.readline

        client.close

        expect(sent).to eq(data)
      end

      context "when given a local host and port" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          subject.send(
            data, server_bind_ip, server_bind_port,
            bind_host: server_bind_ip,
            bind_port: bind_port
          )

          client      = server.accept
          client_port = client.peeraddr[1]

          expect(client_port).to eq(bind_port)

          client.close
        end
      end
    end
  end

  describe ".server" do
    context "integration", :network do
      it "must create a new TCPServer" do
        server = subject.server

        expect(server).to be_kind_of(TCPServer)
        expect(server).not_to be_closed

        server.close
      end

      context "when given a local host and port" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a specific port and host" do
          server     = subject.server(port: bind_port, host: bind_host)
          bound_host = server.addr[3]
          bound_port = server.addr[1]

          expect(bound_host).to eq(local_ip)
          expect(bound_port).to eq(bind_port)

          server.close
        end
      end

      context "when given a block" do
        it "must yield the new TCPServer" do
          server = nil

          subject.server do |yielded_server|
            server = yielded_server
          end

          expect(server).to be_kind_of(TCPServer)
          expect(server).not_to be_closed

          server.close
        end
      end
    end
  end

  describe ".server_session" do
    context "integration", :network do
      it "must create a temporary TCPServer" do
        server = nil

        subject.server_session do |yielded_server|
          server = yielded_server
        end

        expect(server).to be_kind_of(TCPServer)
        expect(server).to be_closed
      end

      context "when given a block" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a specific port and host" do
          bound_host = nil
          bound_port = nil

          subject.server_session(port: bind_port, host: bind_host) do |server|
            bound_host = server.addr[3]
            bound_port = server.addr[1]
          end

          expect(bound_host).to eq(local_ip)
          expect(bound_port).to eq(bind_port)
        end
      end
    end
  end

  describe ".accept" do
    context "integration", :network do
      let(:server_port) { 1024 + rand(65535 - 1024) }

      pending "need to automate connecting to the TCPServer"
    end
  end
end
