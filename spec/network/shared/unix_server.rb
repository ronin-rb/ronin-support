require 'rspec'

require 'tmpdir'
require 'fileutils'
require 'socket'

shared_context "UNIX Server" do
  def socket_path(name); File.join(Dir.tmpdir,name); end

  let(:path) { socket_path('ronin_unix_server') }

  before(:each) do
    @server = UNIXServer.new(path)
    @server_thread = Thread.new do
      socket = @server.accept

      begin
        socket.puts socket.readline
      ensure
        socket.close
      end
    end
  end

  after(:each) do
    @server_thread.kill
    @server.close

    FileUtils.rm(path)
  end
end
