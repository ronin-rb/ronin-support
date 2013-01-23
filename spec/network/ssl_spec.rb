require 'spec_helper'
require 'ronin/network/ssl'

require 'resolv'

describe Network::SSL do
  describe 'VERIFY' do
    subject { Network::SSL::VERIFY }

    it "should define :client_once" do
      subject[:client_once].should == OpenSSL::SSL::VERIFY_CLIENT_ONCE
    end

    it "should define :fail_if_no_peer_cert" do
      subject[:fail_if_no_peer_cert].should == OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT
    end

    it "should define :none" do
      subject[:none].should == OpenSSL::SSL::VERIFY_NONE
    end

    it "should define :peer" do
      subject[:peer].should == OpenSSL::SSL::VERIFY_PEER
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

    describe "#ssl_socket" do
      let(:socket) { TCPSocket.new(host,port) }

      it "should create a new OpenSSL::SSL::SSLSocket" do
        subject.ssl_socket(socket).should be_kind_of(OpenSSL::SSL::SSLSocket)
      end
    end

    describe "#ssl_open?" do
      it "should return true for open ports" do
        subject.ssl_open?(host,port).should == true
      end

      it "should return false for closed ports" do
        subject.ssl_open?('localhost',rand(1024) + 1).should == false
      end

      it "should have a timeout for firewalled ports" do
        timeout = 2

        t1 = Time.now
        subject.ssl_open?(host,1337, timeout: timeout)
        t2 = Time.now

        (t2 - t1).to_i.should <= timeout
      end
    end

    describe "#ssl_connect" do
      it "should connect to an SSL protected port" do
        lambda {
          subject.ssl_connect(host,port)
        }.should_not raise_error(OpenSSL::SSL::SSLError)
      end

      it "should return an OpenSSL::SSL::SSLSocket" do
        socket = subject.ssl_connect(host,port)

        socket.should be_kind_of(OpenSSL::SSL::SSLSocket)
      end

      context "when a block is given" do
        it "should yield the OpenSSL::SSL::SSLSocket" do
          socket = nil

          subject.ssl_connect(host,port) do |yielded_socket|
            socket = yielded_socket
          end

          socket.should be_kind_of(OpenSSL::SSL::SSLSocket)
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

        response.should == expected_response

        socket.close
       end

      it "should yield the OpenSSL::SSL::SSLSocket" do
        response = nil

        socket = subject.ssl_connect_and_send(data,host,port) do |socket|
          banner   = socket.readline
          response = socket.readline
        end

        response.should == expected_response

        socket.close
      end
    end

    describe "#ssl_session" do
      it "should open then close a OpenSSL::SSL::SSLSocket" do
        socket = nil

        subject.ssl_session(host,port) do |yielded_socket|
          socket = yielded_socket
        end

        socket.should be_kind_of(OpenSSL::SSL::SSLSocket)
        socket.should be_closed
      end
    end

    describe "#ssl_banner" do
      let(:local_port) { 1024 + rand(65535 - 1024) }

      let(:expected_banner) { /^220 mx\.google\.com ESMTP/ }

      it "should return the read service banner" do
        banner = subject.ssl_banner(host,port)

        banner.should =~ expected_banner
      end

      it "should bind to a local host and port" do
        banner = subject.ssl_banner(host,port, local_port: local_port)

        banner.should =~ expected_banner
      end

      it "should yield the banner" do
        banner = nil
        
        subject.ssl_banner(host,port) do |yielded_banner|
          banner = yielded_banner
        end

        banner.should =~ expected_banner
      end
    end

    describe "#ssl_server_loop" do
      pending "need to automate connecting to the SSL server"
    end

    describe "#ssl_accept" do
      pending "need to automate connecting to the SSL server"
    end
  end
end
