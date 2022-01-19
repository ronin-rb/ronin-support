require 'spec_helper'
require 'ronin/support/network/ssl'

require 'tmpdir'
require 'resolv'

describe Network::SSL do
  describe 'VERIFY' do
    subject { Network::SSL::VERIFY }

    it "should define :client_once" do
      expect(subject[:client_once]).to eq(OpenSSL::SSL::VERIFY_CLIENT_ONCE)
    end

    it "should define :fail_if_no_peer_cert" do
      expect(subject[:fail_if_no_peer_cert]).to eq(OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
    end

    it "should define :none" do
      expect(subject[:none]).to eq(OpenSSL::SSL::VERIFY_NONE)
    end

    it "should define :peer" do
      expect(subject[:peer]).to eq(OpenSSL::SSL::VERIFY_PEER)
    end

    it "should map true to :peer" do
      expect(subject[true]).to eq(subject[:peer])
    end

    it "should map false to :none" do
      expect(subject[false]).to eq(subject[:none])
    end
  end

  describe "helpers", network: true do
    let(:host) { 'smtp.gmail.com' }
    let(:port) { 465 }

    let(:server_host) { 'localhost' }
    let(:server_ip)   { Resolv.getaddress(server_host) }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    describe "#ssl_context", network: false do
      describe "defaults" do
        subject { super().ssl_context }

        it "should return an OpenSSL::SSL::SSLContext object" do
          expect(subject).to be_kind_of(OpenSSL::SSL::SSLContext)
        end

        it "should set verify_mode to OpenSSL::SSL::VERIFY_NONE" do
          expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
        end

        it "should set cert to nil" do
          expect(subject.cert).to be(nil)
        end

        it "should set key to nil" do
          expect(subject.key).to be(nil)
        end
      end

      describe ":verify" do
        subject { super().ssl_context(verify: :peer) }

        it "should set verify_mode" do
          expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER)
        end
      end

      describe ":cert" do
        let(:cert) { File.join(File.dirname(__FILE__),'ssl.crt') }

        subject { super().ssl_context(cert: cert) }

        it "should set cert" do
          expect(subject.cert.to_s).to eq(File.read(cert))
        end
      end

      describe ":key" do
        let(:key) { File.join(File.dirname(__FILE__),'ssl.key') }

        subject { super().ssl_context(key: key) }

        it "should set key" do
          expect(subject.key.to_s).to eq(File.read(key))
        end
      end

      describe ":certs" do
        context "when value is a file" do
          let(:file) { File.join(File.dirname(__FILE__),'ssl.crt') }

          subject { super().ssl_context(certs: file) }

          it "should set ca_file" do
            expect(subject.ca_file).to eq(file)
          end
        end

        context "when value is a directory" do
          let(:dir) { File.dirname(__FILE__) }

          subject { super().ssl_context(certs: dir) }

          it "should set ca_path" do
            expect(subject.ca_path).to eq(dir)
          end
        end
      end
    end

    describe "#ssl_socket" do
      let(:socket) { TCPSocket.new(host,port) }

      it "should create a new OpenSSL::SSL::SSLSocket" do
        expect(subject.ssl_socket(socket)).to be_kind_of(OpenSSL::SSL::SSLSocket)
      end
    end

    describe "#ssl_open?" do
      it "should return true for open ports" do
        expect(subject.ssl_open?(host,port)).to be(true)
      end

      it "should return false for closed ports" do
        expect(subject.ssl_open?('localhost',rand(1024) + 1)).to be(false)
      end

      it "should have a timeout for firewalled ports" do
        timeout = 2

        t1 = Time.now
        subject.ssl_open?(host,1337, timeout: timeout)
        t2 = Time.now

        expect((t2 - t1).to_i).to be <= timeout
      end
    end

    describe "#ssl_connect" do
      it "should connect to an SSL protected port" do
        expect {
          subject.ssl_connect(host,port)
        }.to raise_error(OpenSSL::SSL::SSLError)
      end

      it "should return an OpenSSL::SSL::SSLSocket" do
        socket = subject.ssl_connect(host,port)

        expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
      end

      context "when a block is given" do
        it "should yield the OpenSSL::SSL::SSLSocket" do
          socket = nil

          subject.ssl_connect(host,port) do |yielded_socket|
            socket = yielded_socket
          end

          expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
        end
      end
    end

    describe "#ssl_connect_and_send" do
      let(:data) { "HELO ronin\n" }
      let(:expected_response) { "250 mx.google.com at your service\r\n" }

      it "should connect and then send data" do
        socket   = subject.ssl_connect_and_send(data,host,port)
        banner   = socket.readline
        response = socket.readline

        expect(response).to eq(expected_response)

        socket.close
       end

      it "should yield the OpenSSL::SSL::SSLSocket" do
        response = nil

        socket = subject.ssl_connect_and_send(data,host,port) do |socket|
          banner   = socket.readline
          response = socket.readline
        end

        expect(response).to eq(expected_response)

        socket.close
      end
    end

    describe "#ssl_session" do
      it "should open then close a OpenSSL::SSL::SSLSocket" do
        socket = nil

        subject.ssl_session(host,port) do |yielded_socket|
          socket = yielded_socket
        end

        expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
        expect(socket).to be_closed
      end
    end

    describe "#ssl_banner" do
      let(:expected_banner) { /^220 mx\.google\.com ESMTP/ }

      it "should return the read service banner" do
        banner = subject.ssl_banner(host,port)

        expect(banner).to be =~ expected_banner
      end

      context "when local_port is given" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        it "should bind to a local host and port" do
          banner = subject.ssl_banner(host,port,nil,local_port)

          expect(banner).to be =~ expected_banner
        end
      end

      it "should yield the banner" do
        banner = nil
        
        subject.ssl_banner(host,port) do |yielded_banner|
          banner = yielded_banner
        end

        expect(banner).to be =~ expected_banner
      end
    end

    describe "#ssl_server_socket" do
      pending "need to automate connecting to the SSL server"
    end

    describe "#ssl_server_loop" do
      pending "need to automate connecting to the SSL server"
    end

    describe "#ssl_accept" do
      pending "need to automate connecting to the SSL server"
    end
  end
end
