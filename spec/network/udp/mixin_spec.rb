require 'spec_helper'
require 'ronin/support/network/udp/mixin'

require 'resolv'

describe Ronin::Support::Network::UDP::Mixin do
  let(:host) { 'scanme.nmap.org' }
  let(:port) { 123 }

  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  shared_examples "UDP Server" do
    let(:server_host) { bind_host }
    let(:server_port) { 1024 + rand(65535 - 1024) }
    let(:server)      { UDPSocket.new }
    let(:server_bind_ip)   { server.addr[3] }
    let(:server_bind_port) { server.addr[1] }

    before(:each) { server.bind(server_host,server_port) }
    after(:each)  { server.close }
  end

  describe "#udp_open?" do
    context "integration", :network do
      let(:host) { server_bind_ip   }
      let(:port) { server_bind_port }

      include_context "UDP Server"

      it "must return true for open ports" do
        expect(subject.udp_open?(host,port)).to be(true)
      end

      let(:closed_port) { port + 1 }

      it "must return false for closed ports" do
        expect(subject.udp_open?(host,closed_port)).to be(false)
      end

      it "must have a timeout for firewalled ports" do
        timeout = 2

        t1 = Time.now
        subject.udp_open?(host,1337, timeout: timeout)
        t2 = Time.now

        expect((t2 - t1).to_i).to be <= timeout
      end
    end
  end

  describe "#udp_connect" do
    context "integration", :network do
      it "must open a UDPSocket" do
        socket = subject.udp_connect(host,port)

        expect(socket).to be_kind_of(UDPSocket)
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
          socket = subject.udp_connect(host,port)

          expect(ips).to include(socket.remote_address.ip_address)
        end
      end

      context "when given the bind_port: keyword argument" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to the local port" do
          socket     = subject.udp_connect(host,port, bind_port: bind_port)
          bound_port = socket.addr[1]

          expect(bound_port).to eq(bind_port)

          socket.close
        end
      end

      context "when given a block" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must open then close a UDPSocket" do
          socket = nil

          subject.udp_connect(host,port) do |yielded_socket|
            socket = yielded_socket
          end

          expect(socket).to be_kind_of(UDPSocket)
          expect(socket).to be_closed
        end

        context "when given the bind_port: keyword argument" do
          it "must bind to the local port" do
            bound_port = nil

            subject.udp_connect(host,port, bind_port: bind_port) do |socket|
              bound_port = socket.addr[1]
            end

            expect(bound_port).to eq(bind_port)
          end
        end
      end
    end
  end

  describe "#udp_connect_and_send" do
    context "integration", :network do
      pending "need to find a UDP Service for these specs" do
        let(:data) { "HELO ronin\n" }
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must connect and then send data" do
          socket = subject.udp_connect_and_send(data,host,port)

          # ignore the banner
          socket.readline

          response = socket.readline

          expect(response.start_with?('250')).to be_true

          socket.close
        end

        it "must bind to a local port" do
          socket     = subject.udp_connect_and_send(
                         data,host,port, bind_port: bind_port
                       )
          bound_port = socket.addr[1]

          expect(bound_port).to eq(bind_port)

          socket.close
        end

        it "must yield the UDPSocket" do
          response = nil

          socket = subject.udp_connect_and_send(data,host,port) do |new_socket|
            # ignore the banner
            new_socket.readline

            response = new_socket.readline
          end

          expect(response.start_with?('250')).to be_true

          socket.close
        end
      end
    end
  end

  describe "#udp_banner" do
    context "integration", :network do
      pending "need to find a UDP service that sends a banner" do
        let(:host) { 'smtp.gmail.com' }
        let(:port) { 25 }

        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must read the service banner" do
          banner = subject.udp_banner(host,port)

          expect(banner.start_with?('220')).to be_true
        end

        context "when given a local host and port" do
          it "must bind to a local host and port" do
            banner = subject.udp_banner(host,port, bind_port: bind_port)

            expect(banner.start_with?('220')).to be_true
          end
        end

        context "when given a block" do
          it "must yield the banner" do
            banner = nil

            subject.udp_banner(host,port) do |yielded_banner|
              banner = yielded_banner
            end

            expect(banner.start_with?('220')).to be_true
          end
        end
      end
    end
  end

  let(:bind_host) { 'localhost' }
  let(:local_ip)  { '127.0.0.1' } # XXX: UPDSocket defaults to using IPv4

  describe "#udp_send" do
    context "integration", :network do
      include_context "UDP Server"

      let(:data) { "hello\n" }

      it "must send data to a service" do
        subject.udp_send(data,server_bind_ip,server_bind_port)

        mesg = server.recvfrom(data.length)

        expect(mesg[0]).to eq(data)
      end

      context "when given a local host and port" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          subject.udp_send(
            data,server_bind_ip,server_bind_port, bind_host: server_bind_ip,
                                                  bind_port: bind_port
          )
          mesg = server.recvfrom(data.length)

          client_address = mesg[1]
          expect(client_address[1]).to eq(bind_port)
        end
      end
    end
  end

  describe "#udp_server" do
    context "integration", :network do
      it "must create a new UDPSocket" do
        server = subject.udp_server

        expect(server).to be_kind_of(UDPSocket)
        expect(server).not_to be_closed

        server.close
      end

      context "when given a port and host" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a specific port and host" do
          server     = subject.udp_server(port: bind_port, host: bind_host)
          bound_host = server.addr[3]
          bound_port = server.addr[1]

          expect(bound_host).to eq(local_ip)
          expect(bound_port).to eq(bind_port)

          server.close
        end
      end

      context "when a block is given" do
        it "must yield the new UDPSocket" do
          server = nil

          subject.udp_server do |yielded_server|
            server = yielded_server
          end

          expect(server).to be_kind_of(UDPSocket)
          expect(server).not_to be_closed

          server.close
        end
      end
    end
  end

  describe "#udp_server_session" do
    context "integration", :network do
      it "must create a temporary UDPSocket" do
        server = nil

        subject.udp_server_session do |yielded_server|
          server = yielded_server
        end

        expect(server).to be_kind_of(UDPSocket)
        expect(server).to be_closed
      end

      context "when given a port and a host" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a specific port and host" do
          bound_host = nil
          bound_port = nil

          subject.udp_server_session(port: bind_port, host: bind_host) do |new_server|
            bound_host = new_server.addr[3]
            bound_port = new_server.addr[1]
          end

          expect(bound_host).to eq(local_ip)
          expect(bound_port).to eq(bind_port)
        end
      end
    end
  end

  describe "#udp_recv" do
    context "integration", :network do
      context "when a block is given" do
        let(:server_host) { '0.0.0.0' }
        let(:server_port) { 1024 + rand(65535 - 1024) }
        let(:mesg)        { "hello world" }

        it "must open a UDP server socket, receive a single message, yield the message and sender information, and then close the server socket" do
          Thread.new do
            sleep 0.1
            socket = UDPSocket.new
            socket.connect(server_host,server_port)
            sleep 0.5

            socket.send(mesg,0)
            socket.close
          end

          yielded_server = nil
          yielded_host   = nil
          yielded_port   = nil
          yielded_mesg   = nil

          subject.udp_recv(host: server_host, port: server_port) do |server,(host,port),mesg|
            yielded_server = server
            yielded_host   = host
            yielded_port   = port
            yielded_mesg   = mesg
          end

          expect(yielded_server).to be_kind_of(UDPSocket)
          expect(yielded_server).to be_closed

          expect(yielded_port).to be_kind_of(Integer)
          expect(yielded_port).to be > 0

          expect(yielded_mesg).to eq(mesg)
        end
      end
    end
  end
end
