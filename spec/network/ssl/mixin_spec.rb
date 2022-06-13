require 'spec_helper'
require 'ronin/support/network/ssl/mixin'

require 'tmpdir'
require 'resolv'

describe Ronin::Support::Network::SSL::Mixin do
  describe "helpers", network: true do
    let(:host) { 'smtp.gmail.com' }
    let(:port) { 465 }

    let(:server_host) { 'localhost' }
    let(:server_ip)   { Resolv.getaddress(server_host) }

    let(:fixtures_dir) { File.join(__dir__,'..','fixtures')   }
    let(:key_file)     { File.join(fixtures_dir,'ssl.key')    }
    let(:key)          { Crypto::Key::RSA.load_file(key_file) }
    let(:cert_file)    { File.join(fixtures_dir,'ssl.crt')    }
    let(:cert)         { Crypto::Cert.load_file(cert_file)    }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    describe "#ssl_context", network: false do
      describe "defaults" do
        subject { super().ssl_context }

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

      context "when given the version: keyword argument" do
        let(:context) { double(OpenSSL::SSL::SSLContext) }

        context "and it's 1" do
          it "must call OpenSSL::SSL::SSLContext#ssl_version with :TLSv1" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:ssl_version=).with(:TLSv1)
            allow(context).to receive(:verify_mode=).with(0)

            subject.ssl_context(version: 1)
          end
        end

        context "and it's 1.1" do
          it "must call OpenSSL::SSL::SSLContext#ssl_version with :TLSv1_1" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:ssl_version=).with(:TLSv1_1)
            allow(context).to receive(:verify_mode=).with(0)

            subject.ssl_context(version: 1.1)
          end
        end

        context "and it's 1_2" do
          it "must call OpenSSL::SSL::SSLContext#ssl_version with :TLSv1_2" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:ssl_version=).with(:TLSv1_2)
            allow(context).to receive(:verify_mode=).with(0)

            subject.ssl_context(version: 1.2)
          end
        end

        context "and it's a Symbol" do
          let(:symbol) { :TLSv1 }

          it "must call OpenSSL::SSL::SSLContext#ssl_version= with the Symbol" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:ssl_version=).with(symbol)
            allow(context).to receive(:verify_mode=).with(0)

            subject.ssl_context(version: symbol)
          end
        end

        context "and it's a String" do
          let(:string) { "SSLv23" }

          it "must call OpenSSL::SSL::SSLContext#ssl_version= with the String" do
            expect(OpenSSL::SSL::SSLContext).to receive(:new).and_return(context)
            expect(context).to receive(:ssl_version=).with(string)
            allow(context).to receive(:verify_mode=).with(0)

            subject.ssl_context(version: string)
          end
        end
      end

      describe "when given the verify: keyword argument" do
        subject { super().ssl_context(verify: :peer) }

        it "must set verify_mode" do
          expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER)
        end
      end

      describe "when given the verify: keyword argument" do
        subject { super().ssl_context(verify: :peer) }

        it "must set verify_mode" do
          expect(subject.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER)
        end
      end

      describe "when given the cert_file: keyword argument" do
        subject { super().ssl_context(key: key, cert_file: cert_file) }

        it "must set cert" do
          expect(subject.cert.to_s).to eq(File.read(cert_file))
        end
      end

      describe "when given the key_file: keyword argument" do
        subject { super().ssl_context(key_file: key_file, cert: cert) }

        it "must set key" do
          expect(subject.key.to_s).to eq(File.read(key_file))
        end
      end

      describe "when given the ca_bundle: keyword argument" do
        context "when value is a file" do
          let(:ca_bundle) { File.join(fixtures_dir,'ca_bundle.crt') }

          subject { super().ssl_context(ca_bundle: ca_bundle) }

          it "must set ca_file" do
            expect(subject.ca_file).to eq(ca_bundle)
          end
        end

        context "when value is a directory" do
          let(:ca_bundle) { File.join(fixtures_dir,'ca_bundle') }

          subject { super().ssl_context(ca_bundle: ca_bundle) }

          it "must set ca_path" do
            expect(subject.ca_path).to eq(ca_bundle)
          end
        end
      end
    end

    describe "#ssl_socket" do
      let(:socket) { TCPSocket.new(host,port) }

      it "must create a new OpenSSL::SSL::SSLSocket" do
        expect(subject.ssl_socket(socket)).to be_kind_of(OpenSSL::SSL::SSLSocket)
      end
    end

    describe "#ssl_open?" do
      it "must return true for open ports" do
        expect(subject.ssl_open?(host,port)).to be(true)
      end

      it "must return false for closed ports" do
        expect(subject.ssl_open?('localhost',rand(1024) + 1)).to be(false)
      end

      it "must have a timeout for firewalled ports" do
        timeout = 2

        t1 = Time.now
        subject.ssl_open?(host,1337, timeout: timeout)
        t2 = Time.now

        expect((t2 - t1).to_i).to be <= timeout
      end
    end

    describe "#ssl_connect" do
      it "must return an OpenSSL::SSL::SSLSocket" do
        socket = subject.ssl_connect(host,port)

        expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
      end

      context "when a block is given" do
        it "must yield the OpenSSL::SSL::SSLSocket" do
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
      let(:expected_response) do
        /^250 (smtp\.gmail\.com|mx\.google\.com) at your service\r\n$/
      end

      it "must connect and then send data" do
        socket   = subject.ssl_connect_and_send(data,host,port)
        banner   = socket.readline
        response = socket.readline

        expect(response).to be =~ expected_response

        socket.close
       end

      it "must yield the OpenSSL::SSL::SSLSocket" do
        response = nil

        socket = subject.ssl_connect_and_send(data,host,port) do |socket|
          banner   = socket.readline
          response = socket.readline
        end

        expect(response).to be =~ expected_response

        socket.close
      end
    end

    describe "#ssl_session" do
      it "must open then close a OpenSSL::SSL::SSLSocket" do
        socket = nil

        subject.ssl_session(host,port) do |yielded_socket|
          socket = yielded_socket
        end

        expect(socket).to be_kind_of(OpenSSL::SSL::SSLSocket)
        expect(socket).to be_closed
      end
    end

    describe "#ssl_banner" do
      let(:expected_banner) { /^220 (smtp\.gmail\.com|mx\.google\.com) ESMTP/ }

      it "must return the read service banner" do
        banner = subject.ssl_banner(host,port)

        expect(banner).to be =~ expected_banner
      end

      context "when local_port is given" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        it "must bind to a local host and port" do
          banner = subject.ssl_banner(host,port,nil,local_port)

          expect(banner).to be =~ expected_banner
        end
      end

      it "must yield the banner" do
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
