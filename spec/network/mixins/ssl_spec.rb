require 'spec_helper'
require 'ronin/network/mixins/ssl'

require 'resolv'

describe Network::Mixins::SSL do
  describe "helper methods", :network do
    let(:host) { 'smtp.gmail.com' }
    let(:port) { 465 }

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

    describe "#ssl_open?" do
      it "should return true for open ports" do
        subject.ssl_open?.should == true
      end

      it "should return false for closed ports" do
        subject.host = 'localhost'
        subject.port = rand(1024) + 1

        subject.ssl_open?.should == false
      end

      it "should have a timeout for firewalled ports" do
        subject.port = 1337

        timeout = 2

        t1 = Time.now
        subject.ssl_open?(timeout)
        t2 = Time.now

        (t2 - t1).to_i.should <= timeout
      end
    end

    describe "#ssl_connect" do
      it "should open a OpenSSL::SSL::SSLSocket" do
        socket = subject.ssl_connect

        socket.should be_kind_of(OpenSSL::SSL::SSLSocket)
        socket.should_not be_closed

        socket.close
      end

      context "when local_port is set" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        before { subject.local_port = local_port }

        it "should bind to a local host and port" do
          socket     = subject.ssl_connect
          bound_port = socket.addr[1]

          bound_port.should == local_port

          socket.close
        end
      end

      it "should yield the new OpenSSL::SSL::SSLSocket" do
        socket = nil

        subject.ssl_connect do |yielded_socket|
          socket = yielded_socket
        end

        socket.should_not be_closed
        socket.close
      end
    end

    describe "#ssl_connect_and_send" do
      let(:data) { "HELO ronin\n" }

      let(:expected_response) { "250 mx.google.com at your service\r\n" }

      it "should connect and then send data" do
        socket   = subject.ssl_connect_and_send(data)
        banner   = socket.readline
        response = socket.readline

        response.should == expected_response

        socket.close
       end

      context "when local_port is set" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        before { subject.local_port = local_port }

        it "should bind to a local host and port" do
          socket     = subject.ssl_connect_and_send(data)
          bound_port = socket.addr[1]

          bound_port.should == local_port

          socket.close
        end
      end

      it "should yield the OpenSSL::SSL::SSLSocket" do
        response = nil

        socket = subject.ssl_connect_and_send(data) do |socket|
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

        subject.ssl_session do |yielded_socket|
          socket = yielded_socket
        end

        socket.should be_kind_of(OpenSSL::SSL::SSLSocket)
        socket.should be_closed
      end

      context "when local_port is set" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        before { subject.local_port = local_port }

        it "should bind to a local host and port" do
          bound_port = nil

          subject.ssl_session do |socket|
            bound_port = socket.addr[1]
          end

          bound_port.should == local_port
        end
      end
    end

    describe "#ssl_banner" do
      let(:expected_banner) { /^220 mx\.google\.com ESMTP/ }

      it "should return the read service banner" do
        banner = subject.ssl_banner

        banner.should =~ expected_banner
      end

      context "when local_port is set" do
        let(:local_port) { 1024 + rand(65535 - 1024) }

        before { subject.local_port = local_port }

        it "should bind to a local host and port" do
          banner = subject.ssl_banner

          banner.should =~ expected_banner
        end
      end

      it "should yield the banner" do
        banner = nil
        
        subject.ssl_banner do |yielded_banner|
          banner = yielded_banner
        end

        banner.should =~ expected_banner
      end
    end

    describe "#ssl_server_loop" do
      pending "need to automate connecting to the TCPServer"
    end

    describe "#ssl_accept" do
      pending "need to automate connecting to the TCPServer"
    end
  end
end
