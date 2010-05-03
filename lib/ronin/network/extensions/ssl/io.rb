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

begin
  require 'openssl'
rescue ::LoadError
end

class IO

  #
  # Creates an SSL socket around the IO object.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Boolean] :verify (:none)
  #   Specifies whether the SSL certificate will be verified. May be either
  #   `:none`, `:client_once`, `:peer` or `:fail_if_no_peer_cert`.
  #
  # @option options [Boolean] :sync (true)
  #   Specifies that the SSL socket will sync the write buffer.
  #
  # @yield [ssl]
  #   If a block is given, it will be passed the newly created ssl socket.
  #
  # @yieldparam [OpenSSL::SSL::SSLSocket] ssl
  #   The ssl socket.
  #
  # @return [OpenSSL::SSL::SSLSocket]
  #   The ssl socket.
  #
  def ssl_start(options={})
    verify_mode = 'VERIFY_' + (options[:verify] || :none).to_s.upcase

    unless OpenSSL::SSL.const_defined?(verify_mode)
      raise(RuntimeError,"unknown verify mode #{options[:verify]}",caller)
    end

    ctx = OpenSSL::SSL::SSLContext.new()
    ctx.verify_mode = OpenSSL::SSL.const_get(verify_mode)

    socket = OpenSSL::SSL::SSLSocket.new(self,ctx)
    socket.sync = true if options[:sync]

    yield socket if block_given?
    return socket
  end

  #
  # Creates a temporary SSL socket around the IO object.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Boolean] :verify (:none)
  #   Specifies whether the SSL certificate will be verified. May be either
  #   `:none`, `:client_once`, `:peer` or `:fail_if_no_peer_cert`.
  #
  # @option options [Boolean] :sync (true)
  #   Specifies that the SSL socket will sync the write buffer.
  #
  # @yield [ssl]
  #   If a block is given, it will be passed the newly created ssl socket.
  #   After the block has returned, the ssl socket will be closed.
  #
  # @yieldparam [OpenSSL::SSL::SSLSocket] ssl
  #   The ssl socket.
  #
  # @return [nil]
  #
  def ssl_session(options={})
    session = ssl(options)

    yield session if block_given?
    session.close
    return nil
  end

end
