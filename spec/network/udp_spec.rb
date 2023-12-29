require 'spec_helper'
require 'ronin/support/network/udp'

require 'resolv'

describe Ronin::Support::Network::UDP do
  let(:host) { 'scanme.nmap.org' }
  let(:port) { 123 }

  shared_examples "UDP Server" do
    let(:server_host) { bind_host }
    let(:server_port) { 1024 + rand(65535 - 1024) }
    let(:server)      { UDPSocket.new }
    let(:server_bind_ip)   { server.addr[3] }
    let(:server_bind_port) { server.addr[1] }

    before(:each) { server.bind(server_host,server_port) }
    after(:each)  { server.close }
  end

  describe ".open?" do
    context "integration", :network do
      let(:host) { server_bind_ip   }
      let(:port) { server_bind_port }

      include_context "UDP Server"

      it "must return true for open ports" do
        expect(subject.open?(host,port)).to be(true)
      end

      let(:closed_port) { port + 1 }

      it "must return false for closed ports" do
        expect(subject.open?(host,closed_port)).to be(false)
      end

      it "must have a timeout for firewalled ports" do
        timeout = 2

        t1 = Time.now
        subject.open?(host,1337, timeout: timeout)
        t2 = Time.now

        expect((t2 - t1).to_i).to be <= timeout
      end
    end
  end

  describe ".connect" do
    context "integration", :network do
      it "must open a UDPSocket" do
        socket = subject.connect(host,port)

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
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must open then close a UDPSocket" do
          socket = nil

          subject.connect(host,port) do |yielded_socket|
            socket = yielded_socket
          end

          expect(socket).to be_kind_of(UDPSocket)
          expect(socket).to be_closed
        end

        context "when given the bind_port: keyword argument" do
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
      pending "need to find a UDP Service for these specs" do
        let(:data) { "HELO ronin\n" }
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must connect and then send data" do
          socket = subject.connect_and_send(data,host,port)

          # ignore the banner
          socket.readline

          response = socket.readline

          expect(response.start_with?('250')).to be_true

          socket.close
        end

        it "must bind to a local port" do
          socket     = subject.connect_and_send(
                         data,host,port, bind_port: bind_port
                       )
          bound_port = socket.addr[1]

          expect(bound_port).to eq(bind_port)

          socket.close
        end

        it "must yield the UDPSocket" do
          response = nil

          socket = subject.connect_and_send(data,host,port) do |new_socket|
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

  describe ".banner" do
    context "integration", :network do
      pending "need to find a UDP service that sends a banner" do
        let(:host) { 'smtp.gmail.com' }
        let(:port) { 25 }

        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must read the service banner" do
          banner = subject.banner(host,port)

          expect(banner.start_with?('220')).to be_true
        end

        context "when given a local host and port" do
          it "must bind to a local host and port" do
            banner = subject.banner(host,port, bind_port: bind_port)

            expect(banner.start_with?('220')).to be_true
          end
        end

        context "when given a block" do
          it "must yield the banner" do
            banner = nil

            subject.banner(host,port) do |yielded_banner|
              banner = yielded_banner
            end

            expect(banner.start_with?('220')).to be_true
          end
        end
      end
    end
  end

  let(:bind_host) { 'localhost' }
  let(:local_ip)   { '127.0.0.1' } # XXX: UPDSocket defaults to using IPv4

  describe ".send" do
    context "integration", :network do
      include_context "UDP Server"

      let(:data) { "hello\n" }

      it "must send data to a service" do
        subject.send(data,server_bind_ip,server_bind_port)

        mesg = server.recvfrom(data.length)

        expect(mesg[0]).to eq(data)
      end

      context "when given a local host and port" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          subject.send(
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

  describe ".server" do
    context "integration", :network do
      it "must create a new UDPSocket" do
        server = subject.server

        expect(server).to be_kind_of(UDPSocket)
        expect(server).not_to be_closed

        server.close
      end

      context "when given a port and host" do
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

      context "when a block is given" do
        it "must yield the new UDPSocket" do
          server = nil

          subject.server do |yielded_server|
            server = yielded_server
          end

          expect(server).to be_kind_of(UDPSocket)
          expect(server).not_to be_closed

          server.close
        end
      end
    end
  end

  describe ".server_session" do
    context "integration", :network do
      it "must create a temporary UDPSocket" do
        server = nil

        subject.server_session do |yielded_server|
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

          subject.server_session(port: bind_port, host: bind_host) do |new_server|
            bound_host = new_server.addr[3]
            bound_port = new_server.addr[1]
          end

          expect(bound_host).to eq(local_ip)
          expect(bound_port).to eq(bind_port)
        end
      end
    end
  end

  describe ".recv" do
    context "integration", :network do
      let(:server_port) { 1024 + rand(65535 - 1024) }
    end
  end
end
