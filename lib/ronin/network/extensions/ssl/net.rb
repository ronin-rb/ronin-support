#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301  USA
#

require 'ronin/network/ssl'

begin
  require 'openssl'
rescue ::LoadError
end

module Net
  #
  # Establishes a SSL connection.
  #
  # @param [String] host
  #   The host to connect to.
  #
  # @param [Integer] port
  #   The port to connect to.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [String] :local_host
  #   The local host to bind to.
  #
  # @option options [Integer] :local_port
  #   The local port to bind to.
  #
  # @option options [Symbol] :verify
  #   Specifies whether to verify the SSL certificate.
  #
  # @option options [String] :cert
  #   The path to the SSL certificate.
  #
  # @option options [String] :key
  #   The path to the SSL key.
  #
  # @yield [ssl_socket]
  #   The given block will be passed the new SSL Socket.
  #
  # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
  #   The new SSL Socket.
  #
  # @return [OpenSSL::SSL::SSLSocket]
  #   the new SSL Socket.
  #
  # @example
  #   socket = Net.ssl_connect('twitter.com',443)
  #
  def Net.ssl_connect(host,port,options={})
    socket = TCPSocket.new(host,port,options[:local_host],options[:local_port])

    ssl_context = OpenSSL::SSL::SSLContext.new()
    ssl_context.verify_mode = Ronin::Network::SSL.verify(options[:verify])

    if options[:cert]
      cert_file = File.new(options[:cert])
      ssl_context.cert = OpenSSL::X509::Certificate.new(cert_file)
    end

    if options[:key]
      key_file = File.new(options[:key])
      ssl_context.key = OpenSSL::PKey::RSA.new(key_file)
    end

    ssl_socket = OpenSSL::SSL::SSLSocket.new(socket,ssl_context)
    ssl_socket.sync_close = true
    ssl_socket.connect

    yield ssl_socket if block_given?
    return ssl_socket
  end

  #
  # Creates a new temporary SSL connection.
  #
  # @param [String] host
  #   The host to connect to.
  #
  # @param [Integer] port
  #   The port to connect to.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [String] :local_host
  #   The local host to bind to.
  #
  # @option options [Integer] :local_port
  #   The local port to bind to.
  #
  # @option options [Symbol] :verify
  #   Specifies whether to verify the SSL certificate.
  #
  # @option options [String] :cert
  #   The path to the SSL certificate.
  #
  # @option options [String] :key
  #   The path to the SSL key.
  #
  # @yield [ssl_socket]
  #   The given block will be passed the temporary SSL Socket.
  #
  # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
  #   The temporary SSL Socket.
  #
  # @return [nil]
  #
  # @example
  #   Net.ssl_session('twitter.com',443) do |sock|
  #     sock.write("GET /\n\n")
  #
  #     sock.each_line { |line| puts line }
  #   end
  #
  def Net.ssl_session(host,port)
    ssl_socket = Net.ssl_connect(host,port)

    yield ssl_socket if block_given?

    ssl_socket.close
    return nil
  end
end
