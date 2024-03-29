require 'spec_helper'
require 'network/shared/unix_server'
require 'ronin/support/network/unix/mixin'

require 'fileutils'

describe Ronin::Support::Network::UNIX::Mixin do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#unix_open?" do
    context "integration", :network do
      include_context "UNIX Server"

      it "must return true for listening UNIX sockets" do
        expect(subject.unix_open?(path)).to be(true)
      end

      it "must return false for closed UNIX sockets" do
        old_path = socket_path('ronin_old_unix_socket')
        UNIXServer.new(old_path).close

        expect(subject.unix_open?(old_path)).to be(false)

        FileUtils.rm(old_path)
      end

      it "must have a timeout for non-existent UNIX sockets" do
        bad_path = socket_path('ronin_bad_unix_socket')
        timeout  = 2

        t1 = Time.now
        subject.unix_open?(bad_path,timeout)
        t2 = Time.now

        expect((t2 - t1).to_i).to be <= timeout
      end
    end
  end

  describe "#unix_connect" do
    context "integration", :network do
      include_context "UNIX Server"

      it "must open a UNIXSocket" do
        socket = subject.unix_connect(path)

        expect(socket).to be_kind_of(UNIXSocket)
        expect(socket).not_to be_closed

        socket.close
      end

      context "when a block is given" do
        it "must open then close a UNIXSocket" do
          socket = nil

          subject.unix_connect(path) do |yielded_socket|
            socket = yielded_socket
          end

          expect(socket).to be_kind_of(UNIXSocket)
          expect(socket).to be_closed
        end
      end
    end
  end

  describe "#unix_connect_and_send" do
    context "integration", :network do
      include_context "UNIX Server"

      let(:data) { "HELO ronin\n" }

      it "must connect and then send data" do
        socket   = subject.unix_connect_and_send(data,path)
        response = socket.readline

        expect(response).to eq(data)

        socket.close
      end

      it "must yield the UNIXSocket" do
        response = nil

        socket = subject.unix_connect_and_send(data,path) do |new_socket|
          response = new_socket.readline
        end

        expect(response).to eq(data)

        socket.close
      end
    end
  end

  describe "#unix_send" do
    context "integration", :network do
      let(:server_path) { File.join(Dir.tmpdir,'ronin_unix_server') }
      let(:data)        { "hello\n" }

      before(:each) { @server = UNIXServer.new(server_path) }

      it "must send data to a service" do
        subject.unix_send(data,server_path)

        client = @server.accept
        sent   = client.readline

        client.close

        expect(sent).to eq(data)
      end

      after(:each) do
        @server.close

        FileUtils.rm(server_path)
      end
    end
  end

  describe "#unix_server" do
    context "integration", :network do
      let(:server_path) { File.join(Dir.tmpdir,'ronin_unix_server') }

      it "must create a new UNIXServer" do
        server = subject.unix_server(server_path)

        expect(server).to be_kind_of(UNIXServer)
        expect(server).not_to be_closed

        server.close
      end

      it "must yield the new UNIXServer" do
        server = nil

        subject.unix_server(server_path) do |yielded_server|
          server = yielded_server
        end

        expect(server).to be_kind_of(UNIXServer)
        expect(server).not_to be_closed

        server.close
      end

      after(:each) { FileUtils.rm(server_path) }
    end
  end

  describe "#unix_server_session" do
    context "integration", :network do
      let(:server_path) { File.join(Dir.tmpdir,'ronin_unix_server') }

      it "must create a temporary UNIXServer" do
        server = nil

        subject.unix_server_session(server_path) do |yielded_server|
          server = yielded_server
        end

        expect(server).to be_kind_of(UNIXServer)
        expect(server).to be_closed
      end

      after(:each) { FileUtils.rm(server_path) }
    end
  end

  describe "#unix_accept" do
    context "integration", :network do
      pending "need to automate connecting to the UNIXServer"
    end
  end
end
