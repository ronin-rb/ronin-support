require 'spec_helper'
require 'network/shared/unix_server'
require 'ronin/network/mixins/unix'

require 'fileutils'

describe Network::Mixins::UNIX do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "helper methods", :network do
    describe "#unix_open?" do
      include_context "UNIX Server"

      before { subject.socket = path }

      it "should return true for listening UNIX sockets" do
        subject.unix_open?.should == true
      end

      context "when the socket is old" do
        let(:old_socket) { socket_path('ronin_old_unix_socket') }

        before do
          UNIXServer.new(old_socket).close
          subject.socket = old_socket
        end

        it "should return false" do
          subject.unix_open?.should == false
        end

        after { FileUtils.rm(old_socket) }
      end

      context "when the socket is non-existent" do
        before { subject.socket = socket_path('ronin_bad_unix_socket') }

        it "should have a timeout" do
          timeout = 2

          t1 = Time.now
          subject.unix_open?(nil,timeout)
          t2 = Time.now

          (t2 - t1).to_i.should <= timeout
        end
      end
    end

    describe "#unix_connect" do
      include_context "UNIX Server"

      before { subject.socket = path }

      it "should open a UNIXSocket" do
        socket = subject.unix_connect

        socket.should be_kind_of(UNIXSocket)
        socket.should_not be_closed

        socket.close
      end

      it "should yield the new UNIXSocket" do
        socket = nil

        subject.unix_connect do |yielded_socket|
          socket = yielded_socket
        end

        socket.should_not be_closed
        socket.close
      end
    end

    describe "#unix_connect_and_send" do
      include_context "UNIX Server"

      let(:data) { "HELO ronin\n" }

      before { subject.socket = path }

      it "should connect and then send data" do
        socket   = subject.unix_connect_and_send(data)
        response = socket.readline

        response.should == data

        socket.close
       end

      it "should yield the UNIXSocket" do
        response = nil

        socket = subject.unix_connect_and_send(data) do |socket|
          response = socket.readline
        end

        response.should == data

        socket.close
      end
    end

    describe "#unix_session" do
      include_context "UNIX Server"

      before { subject.socket = path }

      it "should open then close a UNIXSocket" do
        socket = nil

        subject.unix_session do |yielded_socket|
          socket = yielded_socket
        end

        socket.should be_kind_of(UNIXSocket)
        socket.should be_closed
      end
    end

    describe "#unix_send" do
      include_context "UNIX Server"

      let(:server_socket) { File.join(Dir.tmpdir,'ronin_unix_server') }
      let(:data)        { "hello\n" }

      before do
        @server = UNIXServer.new(server_socket)
        subject.socket = server_socket
      end

      it "should send data to a service" do
        subject.unix_send(data)

        client = @server.accept
        sent   = client.readline

        client.close

        sent.should == data
      end

      after do
        @server.close
        FileUtils.rm(server_socket)
      end
    end

    describe "#unix_server" do
      include_context "UNIX Server"

      let(:server_socket) { File.join(Dir.tmpdir,'ronin_unix_server') }

      before { subject.server_socket = server_socket }

      it "should create a new UNIXServer" do
        server = subject.unix_server

        server.should be_kind_of(UNIXServer)
        server.should_not be_closed

        server.close
      end

      it "should yield the new UNIXServer" do
        server = nil
        
        subject.unix_server do |yielded_server|
          server = yielded_server
        end

        server.should be_kind_of(UNIXServer)
        server.should_not be_closed

        server.close
      end

      after { FileUtils.rm(server_socket) }
    end

    describe "#unix_server_session" do
      include_context "UNIX Server"

      let(:server_socket) { File.join(Dir.tmpdir,'ronin_unix_server') }

      before { subject.server_socket = server_socket }

      it "should create a temporary UNIXServer" do
        server = nil
        
        subject.unix_server_session do |yielded_server|
          server = yielded_server
        end

        server.should be_kind_of(UNIXServer)
        server.should be_closed
      end

      after { FileUtils.rm(server_socket) }
    end

    describe "#unix_accept" do
      pending "need to automate connecting to the UNIXServer"
    end
  end
end
