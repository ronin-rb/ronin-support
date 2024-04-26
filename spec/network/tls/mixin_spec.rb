require 'spec_helper'
require 'ronin/support/network/tls/mixin'

require 'tmpdir'
require 'resolv'

describe Ronin::Support::Network::TLS::Mixin do
  describe "helpers", network: true do
    let(:host) { 'smtp.gmail.com' }
    let(:port) { 465 }

    let(:server_host) { 'localhost' }
    let(:server_ip)   { Resolv.getaddress(server_host) }

    let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }
    let(:key_file)     { File.join(fixtures_dir,'ssl.key') }
    let(:key)          { Ronin::Support::Crypto::Key::RSA.load_file(key_file) }
    let(:cert_file)    { File.join(fixtures_dir,'ssl.crt') }
    let(:cert)         { Ronin::Support::Crypto::Cert.load_file(cert_file) }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    describe "#tls_context", network: false do
      describe "defaults" do
        subject { super().tls_context }

        it "must return an OpenSSL::SSL::SSLContext object" do
          expect(subject).to be_kind_of(OpenSSL::SSL::SSLContext)
        end

        it "must set verify_mode to OpenSSL::SSL::VERIFY_NONE" do
          expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
        end

        it "must set cert to nil" do
          expect(subject.cert).to be(nil)
        end

        it "must set key to nil" do
          expect(subject.key).to be(nil)
        end
      end

      context "when no version: keyword argument is given" do
        let(:context) { double(OpenSSL::SSL::SSLContext) }

        it "must call OpenSSL::SSL::SSLContext#min_version= with OpenSSL::SSL::TLS1_VERSION" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
          allow(context).to receive(:verify_mode=).with(0)

          subject.tls_context
        end
      end

      context "when given the version: keyword argument" do
        let(:context) { double(OpenSSL::SSL::SSLContext) }

        context "and it's 1" do
          it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
            expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(version: 1)
          end
        end

        context "and it's 1.1" do
          it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_1_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
            expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(version: 1.1)
          end
        end

        context "and it's 1_2" do
          it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_2_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
            expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(version: 1.2)
          end
        end

        context "and it's a Symbol" do
          let(:symbol) { :TLS1 }

          it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with the Symbol" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(symbol)
            expect(context).to receive(:max_version=).with(symbol)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(version: symbol)
          end

          context "but it's :TLSv1" do
            it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_VERSION" do
              expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
              expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
              expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_VERSION)
              allow(context).to receive(:verify_mode=).with(0)

              subject.tls_context(version: :TLSv1)
            end
          end

          context "but it's :TLSv1_1" do
            it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_1_VERSION" do
              expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
              expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
              expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
              allow(context).to receive(:verify_mode=).with(0)

              subject.tls_context(version: :TLSv1_1)
            end
          end

          context "but it's :TLSv1_2" do
            it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_2_VERSION" do
              expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
              expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
              expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
              allow(context).to receive(:verify_mode=).with(0)

              subject.tls_context(version: :TLSv1_2)
            end
          end
        end
      end

      context "when given the min_version: keyword argument" do
        let(:context) { double(OpenSSL::SSL::SSLContext) }

        context "and it's 1" do
          it "must call OpenSSL::SSL::SSLContext#min_version= with OpenSSL::SSL::TLS1_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(min_version: 1)
          end
        end

        context "and it's 1.1" do
          it "must call OpenSSL::SSL::SSLContext#min_version= with OpenSSL::SSL::TLS1_1_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(min_version: 1.1)
          end
        end

        context "and it's 1_2" do
          it "must call OpenSSL::SSL::SSLContext#min_version= with OpenSSL::SSL::TLS1_2_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(min_version: 1.2)
          end
        end

        context "and it's a Symbol" do
          let(:symbol) { :TLS1 }

          it "must call OpenSSL::SSL::SSLContext#min_version= with the Symbol" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(symbol)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(min_version: symbol)
          end

          context "but it's :TLSv1" do
            it "must call OpenSSL::SSL::SSLContext#min_version= with OpenSSL::SSL::TLS1_VERSION" do
              expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
              expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
              allow(context).to receive(:verify_mode=).with(0)

              subject.tls_context(min_version: :TLSv1)
            end
          end

          context "but it's :TLSv1_1" do
            it "must call OpenSSL::SSL::SSLContext#min_version= with OpenSSL::SSL::TLS1_1_VERSION" do
              expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
              expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
              allow(context).to receive(:verify_mode=).with(0)

              subject.tls_context(min_version: :TLSv1_1)
            end
          end

          context "but it's :TLSv1_2" do
            it "must call OpenSSL::SSL::SSLContext#min_version= with OpenSSL::SSL::TLS1_2_VERSION" do
              expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
              expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
              allow(context).to receive(:verify_mode=).with(0)

              subject.tls_context(min_version: :TLSv1_2)
            end
          end
        end
      end

      context "when given the max_version: keyword argument" do
        let(:context) { double(OpenSSL::SSL::SSLContext) }

        context "and it's 1" do
          it "must call OpenSSL::SSL::SSLContext#max_version= with OpenSSL::SSL::TLS1_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
            expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(max_version: 1)
          end
        end

        context "and it's 1.1" do
          it "must call OpenSSL::SSL::SSLContext#max_version= with OpenSSL::SSL::TLS1_1_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
            expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(max_version: 1.1)
          end
        end

        context "and it's 1_2" do
          it "must call OpenSSL::SSL::SSLContext#max_version= with OpenSSL::SSL::TLS1_2_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
            expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(max_version: 1.2)
          end
        end

        context "and it's a Symbol" do
          let(:symbol) { :TLS1 }

          it "must call OpenSSL::SSL::SSLContext#max_version= with the Symbol" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
            expect(context).to receive(:max_version=).with(symbol)
            allow(context).to receive(:verify_mode=).with(0)

            subject.tls_context(max_version: symbol)
          end

          context "but it's :TLSv1" do
            it "must call OpenSSL::SSL::SSLContext#max_version= with OpenSSL::SSL::TLS1_VERSION" do
              expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
              expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
              expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_VERSION)
              allow(context).to receive(:verify_mode=).with(0)

              subject.tls_context(max_version: :TLSv1)
            end
          end

          context "but it's :TLSv1_1" do
            it "must call OpenSSL::SSL::SSLContext#max_version= with OpenSSL::SSL::TLS1_1_VERSION" do
              expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
              expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
              expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
              allow(context).to receive(:verify_mode=).with(0)

              subject.tls_context(max_version: :TLSv1_1)
            end
          end

          context "but it's :TLSv1_2" do
            it "must call OpenSSL::SSL::SSLContext#max_version= with OpenSSL::SSL::TLS1_2_VERSION" do
              expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
              expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
              expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
              allow(context).to receive(:verify_mode=).with(0)

              subject.tls_context(max_version: :TLSv1_2)
            end
          end
        end
      end

      describe "when given the verify: keyword argument" do
        subject { super().tls_context(verify: :peer) }

        it "must set verify_mode" do
          expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER)
        end
      end

      describe "when given the cert_file: keyword argument" do
        subject { super().tls_context(key: key, cert_file: cert_file) }

        it "must set cert" do
          expect(subject.cert.to_s).to eq(File.read(cert_file))
        end
      end

      describe "when given the key_file: keyword argument" do
        subject { super().tls_context(key_file: key_file, cert: cert) }

        it "must set key" do
          expect(subject.key.to_s).to eq(File.read(key_file))
        end
      end

      describe "when given the ca_bundle: keyword argument" do
        context "when value is a file" do
          let(:ca_bundle) { File.join(fixtures_dir,'ca_bundle.crt') }

          subject { super().tls_context(ca_bundle: ca_bundle) }

          it "must set ca_file" do
            expect(subject.ca_file).to eq(ca_bundle)
          end
        end

        context "when value is a directory" do
          let(:ca_bundle) { File.join(fixtures_dir,'ca_bundle') }

          subject { super().tls_context(ca_bundle: ca_bundle) }

          it "must set ca_path" do
            expect(subject.ca_path).to eq(ca_bundle)
          end
        end
      end
    end

    describe "#tls_socket" do
      let(:socket) { TCPSocket.new(host,port) }

      it "must create a new OpenSSL::SSL::SSLSocket" do
        expect(subject.tls_socket(socket)).to be_kind_of(OpenSSL::SSL::SSLSocket)
      end

      it "must default the SSLSocket#hostname to the given host" do
        socket = subject.tls_connect(host,port)

        expect(socket.hostname).to eq(host)
      end

      context "when given the hostname: keyword argument" do
        let(:host) { '162.159.140.67' }
        let(:port) { 443 }

        let(:hostname) { 'merch.ronin-rb.dev' }

        it "must set the SSLSocket#hostname to the hostname: keyword argument" do
          socket = subject.tls_connect(host,port, hostname: hostname)

          expect(socket.hostname).to eq(hostname)
        end
      end
    end

    describe "#tls_open?" do
      it "must return true for open ports" do
        expect(subject.tls_open?(host,port)).to be(true)
      end

      it "must return false for closed ports" do
        random_port = rand(1..1024)

        expect(subject.tls_open?('localhost',random_port)).to be(false)
      end

      it "must have a timeout for firewalled ports" do
        timeout = 2

        t1 = Time.now
        subject.tls_open?(host,1337, timeout: timeout)
        t2 = Time.now

        expect((t2 - t1).to_i).to be <= timeout
      end
    end

    describe "#tls_connect" do
      it "must return an OpenSSL::SSL::SSLSocket" do
        socket = subject.tls_connect(host,port)

        expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
      end

      context "when a block is given" do
        it "must open then close a OpenSSL::SSL::SSLSocket" do
          socket = nil

          subject.tls_connect(host,port) do |yielded_socket|
            socket = yielded_socket
          end

          expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
          expect(socket).to be_closed
        end
      end
    end

    describe "#tls_connect_and_send" do
      let(:data) { "HELO ronin\n" }
      let(:expected_response) do
        /^250 (smtp\.gmail\.com|mx\.google\.com) at your service\r\n$/
      end

      it "must connect and then send data" do
        socket = subject.tls_connect_and_send(data,host,port)

        # ignore the banner
        socket.readline

        response = socket.readline

        expect(response).to be =~ expected_response

        socket.close
      end

      it "must yield the OpenSSL::SSL::SSLSocket" do
        response = nil

        socket = subject.tls_connect_and_send(data,host,port) do |new_socket|
          # ignore the banner
          new_socket.readline

          response = new_socket.readline
        end

        expect(response).to be =~ expected_response

        socket.close
      end
    end

    describe "#tls_cert" do
      it "must connect and return the peer Ronin::Support::Crypto::Cert object" do
        cert = subject.tls_cert(host,port)

        expect(cert).to be_kind_of(Ronin::Support::Crypto::Cert)
        expect(cert.subject.common_name).to eq(host)
      end
    end

    describe "#tls_banner" do
      let(:expected_banner) { /^220 (smtp\.gmail\.com|mx\.google\.com) ESMTP/ }

      it "must return the read service banner" do
        banner = subject.tls_banner(host,port)

        expect(banner).to be =~ expected_banner
      end

      context "when the bind_port: keyword argument is given" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          banner = subject.tls_banner(host,port, bind_port: bind_port)

          expect(banner).to be =~ expected_banner
        end
      end

      it "must yield the banner" do
        banner = nil

        subject.tls_banner(host,port) do |yielded_banner|
          banner = yielded_banner
        end

        expect(banner).to be =~ expected_banner
      end
    end

    describe "#tls_server_socket" do
      pending "need to automate connecting to the SSL server"
    end

    let(:bind_host) { 'localhost' }
    let(:local_ip)  { Resolv.getaddress(bind_host) }

    describe "#tls_server" do
      context "integration", :network do
        it "must create a new OpenSSL::SSL::SSLServer" do
          ssl_server = subject.tls_server
          tcp_server = ssl_server.to_io

          expect(ssl_server).to be_kind_of(OpenSSL::SSL::SSLServer)
          expect(tcp_server).not_to be_closed

          ssl_server.close
        end

        context "when given a local host and port" do
          let(:bind_port) { 1024 + rand(65535 - 1024) }

          it "must bind to a specific port and host" do
            ssl_server = subject.tls_server(port: bind_port, host: bind_host)
            tcp_server = ssl_server.to_io
            bound_host = tcp_server.addr[3]
            bound_port = tcp_server.addr[1]

            expect(bound_host).to eq(local_ip)
            expect(bound_port).to eq(bind_port)

            ssl_server.close
          end
        end

        context "when given a block" do
          it "must yield the new OpenSSL::SSL::SSLServer" do
            ssl_server = nil
            tcp_server = nil

            subject.tls_server do |yielded_server|
              ssl_server = yielded_server
              tcp_server = ssl_server.to_io
            end

            expect(ssl_server).to be_kind_of(OpenSSL::SSL::SSLServer)
            expect(tcp_server).not_to be_closed

            ssl_server.close
          end
        end
      end
    end

    describe "#tls_server_session" do
      context "integration", :network do
        it "must create a temporary OpenSSL::SSL::SSLServer" do
          ssl_server = nil
          tcp_server = nil

          subject.tls_server_session do |yielded_server|
            ssl_server = yielded_server
            tcp_server = ssl_server.to_io
          end

          expect(ssl_server).to be_kind_of(OpenSSL::SSL::SSLServer)
          expect(tcp_server).to be_closed
        end

        context "when given a block" do
          let(:bind_port) { 1024 + rand(65535 - 1024) }

          it "must bind to a specific port and host" do
            bound_host = nil
            bound_port = nil

            subject.tls_server_session(port: bind_port, host: bind_host) do |ssl_server|
              tcp_server = ssl_server.to_io
              bound_host = tcp_server.addr[3]
              bound_port = tcp_server.addr[1]
            end

            expect(bound_host).to eq(local_ip)
            expect(bound_port).to eq(bind_port)
          end
        end
      end
    end

    describe "#tls_server_loop" do
      pending "need to automate connecting to the SSL server"
    end

    describe "#tls_accept" do
      context "integration", :network do
        context "when a block is given" do
          let(:server_host) { 'localhost' }
          let(:server_port) { 1024 + rand(65535 - 1024) }

          it "must open a TLS server socket, accept a single connection, yield a OpenSSL::SSL::SSLSocket, and then close both sockets" do
            Thread.new do
              sleep 0.1
              socket     = TCPSocket.new(server_host,server_port)
              ssl_socket = OpenSSL::SSL::SSLSocket.new(socket)
              ssl_socket.connect

              sleep 0.5
              ssl_socket.close
            end

            yielded_client = nil

            subject.tls_accept(port: server_port) do |client|
              yielded_client = client
            end

            expect(yielded_client).to be_kind_of(OpenSSL::SSL::SSLSocket)
            expect(yielded_client).to be_closed
          end
        end
      end
    end
  end
end
