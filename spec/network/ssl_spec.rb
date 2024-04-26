require 'spec_helper'
require 'ronin/support/network/ssl'

require 'tempfile'

describe Ronin::Support::Network::SSL do
  describe "VERSIONS" do
    subject { described_class::VERSIONS }

    it "must map 1 to OpenSSL::SSL::TLS1_VERSION" do
      expect(subject[1]).to eq(OpenSSL::SSL::TLS1_VERSION)
    end

    it "must map 1.1 to OpenSSL::SSL::TLS1_1_VERSION" do
      expect(subject[1.1]).to eq(OpenSSL::SSL::TLS1_1_VERSION)
    end

    it "must map 1.2 to OpenSSL::SSL::TLS1_2_VERSION" do
      expect(subject[1.2]).to eq(OpenSSL::SSL::TLS1_2_VERSION)
    end

    it "must map :TLSv1 to OpenSSL::SSL::TLS1_VERSION" do
      expect(subject[:TLSv1]).to eq(OpenSSL::SSL::TLS1_VERSION)
    end

    it "must map :TLSv1_1 to OpenSSL::SSL::TLS1_1_VERSION" do
      expect(subject[:TLSv1_1]).to eq(OpenSSL::SSL::TLS1_1_VERSION)
    end

    it "must map :TLSv1_2 to OpenSSL::SSL::TLS1_2_VERSION" do
      expect(subject[:TLSv1_2]).to eq(OpenSSL::SSL::TLS1_2_VERSION)
    end
  end

  describe 'VERIFY' do
    subject { described_class::VERIFY }

    it "must define :client_once" do
      expect(subject[:client_once]).to eq(OpenSSL::SSL::VERIFY_CLIENT_ONCE)
    end

    it "must define :fail_if_no_peer_cert" do
      expect(subject[:fail_if_no_peer_cert]).to eq(OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
    end

    it "must define :none" do
      expect(subject[:none]).to eq(OpenSSL::SSL::VERIFY_NONE)
    end

    it "must define :peer" do
      expect(subject[:peer]).to eq(OpenSSL::SSL::VERIFY_PEER)
    end

    it "must map true to :peer" do
      expect(subject[true]).to eq(subject[:peer])
    end

    it "must map false to :none" do
      expect(subject[false]).to eq(subject[:none])
    end
  end

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:key_file)  { File.join(fixtures_dir,'ssl.key') }
  let(:key)       { Ronin::Support::Crypto::Key::RSA.load_file(key_file) }
  let(:cert_file) { File.join(fixtures_dir,'ssl.crt') }
  let(:cert)      { Ronin::Support::Crypto::Cert.load_file(cert_file) }

  describe ".key" do
    it "must return LocalKey.fetch" do
      expect(described_class::LocalKey).to receive(:fetch)

      subject.key
    end
  end

  describe ".key=" do
    before { subject.key = key }

    it "must set .key" do
      expect(subject.key).to be(key)
    end
  end

  describe ".cert" do
    it "must return LocalCert.fetch" do
      expect(described_class::LocalCert).to receive(:fetch)

      subject.cert
    end
  end

  describe ".cert=" do
    before { subject.cert = cert }

    it "must set .cert" do
      expect(subject.cert).to be(cert)
    end
  end

  describe ".context" do
    subject { described_class.context }

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

    context "when given the version: keyword argument" do
      subject { described_class }

      let(:context) { double(OpenSSL::SSL::SSLContext) }

      context "and it's 1" do
        it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_VERSION" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
          expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_VERSION)
          allow(context).to receive(:verify_mode=).with(0)

          subject.context(version: 1)
        end
      end

      context "and it's 1.1" do
        it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_1_VERSION" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
          expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
          allow(context).to receive(:verify_mode=).with(0)

          subject.context(version: 1.1)
        end
      end

      context "and it's 1_2" do
        it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_2_VERSION" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
          expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
          allow(context).to receive(:verify_mode=).with(0)

          subject.context(version: 1.2)
        end
      end

      context "and it's a Symbol" do
        let(:symbol) { :TLS1 }

        it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with the Symbol" do
          expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
          expect(context).to receive(:min_version=).with(symbol)
          expect(context).to receive(:max_version=).with(symbol)
          allow(context).to receive(:verify_mode=).with(0)

          subject.context(version: symbol)
        end

        context "but it's :TLSv1" do
          it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_VERSION)
            expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.context(version: :TLSv1)
          end
        end

        context "but it's :TLSv1_1" do
          it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_1_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
            expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_1_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.context(version: :TLSv1_1)
          end
        end

        context "but it's :TLSv1_2" do
          it "must call OpenSSL::SSL::SSLContext#min_version= and #max_version= with OpenSSL::SSL::TLS1_2_VERSION" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:min_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
            expect(context).to receive(:max_version=).with(OpenSSL::SSL::TLS1_2_VERSION)
            allow(context).to receive(:verify_mode=).with(0)

            subject.context(version: :TLSv1_2)
          end
        end
      end
    end

    context "when given the verify: keyword argument" do
      subject { described_class.context(verify: :peer) }

      it "must set verify_mode" do
        expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER)
      end
    end

    context "when given the key: keyword argument" do
      subject { described_class.context(key: key, cert: cert) }

      it "must set key" do
        expect(subject.key).to eq(key)
      end
    end

    context "when given the key_file: keyword argument" do
      subject { described_class.context(key_file: key_file, cert: cert) }

      it "must set key" do
        expect(subject.key.to_s).to eq(key.to_s)
      end
    end

    context "when given the cert: keyword argument" do
      subject { described_class.context(key: key, cert: cert) }

      it "must set cert" do
        expect(subject.cert).to eq(cert)
      end
    end

    context "when given the cert_file: keyword argument" do
      subject { described_class.context(key: key, cert_file: cert_file) }

      it "must set cert" do
        expect(subject.cert.to_s).to eq(cert.to_s)
      end
    end

    context "when given the ca_bundle: keyword argument" do
      context "when value is a file" do
        let(:ca_bundle) { File.join(fixtures_dir,'ca_bundle.crt') }

        subject { described_class.context(ca_bundle: ca_bundle) }

        it "must set ca_file" do
          expect(subject.ca_file).to eq(ca_bundle)
        end
      end

      context "when value is a directory" do
        let(:ca_bundle) { File.join(fixtures_dir,'ca_bundle') }

        subject { described_class.context(ca_bundle: ca_bundle) }

        it "must set ca_path" do
          expect(subject.ca_path).to eq(ca_bundle)
        end
      end
    end
  end

  let(:host) { 'smtp.gmail.com' }
  let(:port) { 465 }

  let(:server_host) { 'localhost' }
  let(:server_ip)   { Resolv.getaddress(server_host) }

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }
  let(:key_file)     { File.join(fixtures_dir,'ssl.key') }
  let(:key)          { Ronin::Support::Crypto::Key::RSA.load_file(key_file) }
  let(:cert_file)    { File.join(fixtures_dir,'ssl.crt') }
  let(:cert)         { Ronin::Support::Crypto::Cert.load_file(cert_file) }

  describe ".socket", network: true do
    let(:socket) { TCPSocket.new(host,port) }

    it "must create a new OpenSSL::SSL::SSLSocket" do
      expect(subject.socket(socket)).to be_kind_of(OpenSSL::SSL::SSLSocket)
    end
  end

  describe ".open?", network: true do
    it "must return true for open ports" do
      expect(subject.open?(host,port)).to be(true)
    end

    it "must return false for closed ports" do
      closed_port = rand(1..1024)

      expect(subject.open?('localhost',closed_port)).to be(false)
    end

    it "must have a timeout for firewalled ports" do
      timeout = 2

      t1 = Time.now
      subject.open?(host,1337, timeout: timeout)
      t2 = Time.now

      expect((t2 - t1).to_i).to be <= timeout
    end
  end

  describe ".connect", network: true do
    it "must return an OpenSSL::SSL::SSLSocket" do
      socket = subject.connect(host,port)

      expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
    end

    it "must default the SSLSocket#hostname to the given host" do
      socket = subject.connect(host,port)

      expect(socket.hostname).to eq(host)
    end

    context "when given the hostname: keyword argument" do
      let(:host) { '162.159.140.67' }
      let(:port) { 443 }

      let(:hostname) { 'merch.ronin-rb.dev' }

      it "must set the SSLSocket#hostname to the hostname: keyword argument" do
        socket = subject.connect(host,port, hostname: hostname)

        expect(socket.hostname).to eq(hostname)
      end
    end

    context "when a block is given" do
      it "must open then close a OpenSSL::SSL::SSLSocket" do
        socket = nil

        subject.connect(host,port) do |yielded_socket|
          socket = yielded_socket
        end

        expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
        expect(socket).to be_closed
      end
    end
  end

  describe ".connect_and_send", network: true do
    let(:data) { "HELO ronin\n" }
    let(:expected_response) do
      /^250 (smtp\.gmail\.com|mx\.google\.com) at your service\r\n$/
    end

    it "must connect and then send data" do
      socket = subject.connect_and_send(data,host,port)

      # ignore the banner
      socket.readline

      response = socket.readline

      expect(response).to be =~ expected_response

      socket.close
    end

    it "must yield the OpenSSL::SSL::SSLSocket" do
      response = nil

      socket = subject.connect_and_send(data,host,port) do |new_socket|
        # ignore the banner
        new_socket.readline

        response = new_socket.readline
      end

      expect(response).to be =~ expected_response

      socket.close
    end
  end

  describe ".get_cert", network: true do
    it "must connect and return the peer Ronin::Support::Crypto::Cert object" do
      cert = subject.get_cert(host,port)

      expect(cert).to be_kind_of(Ronin::Support::Crypto::Cert)
      expect(cert.subject.common_name).to eq(host)
    end
  end

  describe ".banner", network: true do
    let(:expected_banner) { /^220 (smtp\.gmail\.com|mx\.google\.com) ESMTP/ }

    it "must return the read service banner" do
      banner = subject.banner(host,port)

      expect(banner).to be =~ expected_banner
    end

    context "when bindl_port: keyword argument is given" do
      let(:bind_port) { 1024 + rand(65535 - 1024) }

      it "must bind to a local host and port" do
        banner = subject.banner(host,port, bind_port: bind_port)

        expect(banner).to be =~ expected_banner
      end
    end

    it "must yield the banner" do
      banner = nil

      subject.banner(host,port) do |yielded_banner|
        banner = yielded_banner
      end

      expect(banner).to be =~ expected_banner
    end
  end

  describe ".server_socket", network: true do
    pending "need to automate connecting to the SSL server"
  end

  let(:bind_host) { 'localhost' }
  let(:local_ip)  { Resolv.getaddress(bind_host) }

  describe ".server" do
    context "integration", :network do
      it "must create a new OpenSSL::SSL::SSLServer" do
        ssl_server = subject.server
        tcp_server = ssl_server.to_io

        expect(ssl_server).to be_kind_of(OpenSSL::SSL::SSLServer)
        expect(tcp_server).not_to be_closed

        ssl_server.close
      end

      context "when given a local host and port" do
        let(:bind_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a specific port and host" do
          ssl_server = subject.server(port: bind_port, host: bind_host)
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

          subject.server do |yielded_server|
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

  describe ".server_session" do
    context "integration", :network do
      it "must create a temporary OpenSSL::SSL::SSLServer" do
        ssl_server = nil
        tcp_server = nil

        subject.server_session do |yielded_server|
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

          subject.server_session(port: bind_port, host: bind_host) do |ssl_server|
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

  describe ".server_loop", network: true do
    pending "need to automate connecting to the SSL server"
  end

  describe ".accept", network: true do
    context "integration", :network do
      context "when a block is given" do
        let(:server_host) { 'localhost' }
        let(:server_port) { 1024 + rand(65535 - 1024) }

        it "must open a SSL server socket, accept a single connection, yield a OpenSSL::SSL::SSLSocket, and then close both sockets" do
          Thread.new do
            sleep 0.1
            socket     = TCPSocket.new(server_host,server_port)
            ssl_socket = OpenSSL::SSL::SSLSocket.new(socket)
            ssl_socket.connect

            sleep 0.5
            ssl_socket.close
          end

          yielded_client = nil

          subject.accept(port: server_port) do |client|
            yielded_client = client
          end

          expect(yielded_client).to be_kind_of(OpenSSL::SSL::SSLSocket)
          expect(yielded_client).to be_closed
        end
      end
    end
  end
end
