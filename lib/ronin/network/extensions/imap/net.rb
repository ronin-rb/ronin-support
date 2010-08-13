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

require 'ronin/network/imap'
require 'ronin/network/ssl'

require 'net/imap'

module Net
  #
  # Creates a connection to the IMAP server.
  #
  # @param [String] host
  #   The host to connect to.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Integer] :port (IMAP.default_port)
  #   The port the IMAP server is running on.
  #
  # @option options [String] :certs
  #   The path to the file containing CA certs of the server.
  #
  # @option options [Symbol] :auth
  #   The type of authentication to perform when connecting to the server.
  #   May be either `:login` or `:cram_md5`.
  #
  # @option options [String] :user
  #   The user to authenticate as when connecting to the server.
  #
  # @option options [String] :password
  #   The password to authenticate with when connecting to the server.
  #
  # @yield [session]
  #   If a block is given, it will be passed the newly created IMAP
  #   session.
  #
  # @yieldparam [Net::IMAP] session
  #   The newly created IMAP session object.
  #
  # @return [Net::IMAP]
  #   The newly created IMAP session object.
  #
  def Net.imap_connect(host,options={})
    port = (options[:port] || Ronin::Network::IMAP.default_port)
    certs = options[:certs]
    auth = options[:auth]
    user = options[:user]
    passwd = options[:password]

    if options[:ssl]
      ssl = true
      ssl_certs = options[:ssl][:certs]
      ssl_verify = Ronin::Network::SSL.verify(options[:ssl][:verify])
    else
      ssl = false
      ssl_verify = false
    end

    sess = Net::IMAP.new(host,port,ssl,ssl_certs,ssl_verify)

    if user
      if auth==:cram_md5
        sess.authenticate('CRAM-MD5',user,passwd)
      else
        sess.authenticate('LOGIN',user,passwd)
      end
    end

    yield sess if block_given?
    return sess
  end

  #
  # Starts an IMAP session with the IMAP server.
  #
  # @param [String] host
  #   The host to connect to.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @yield [session]
  #   If a block is given, it will be passed the newly created IMAP
  #   session. After the block has returned, the session will be closed.
  #
  # @yieldparam [Net::IMAP] session
  #   The newly created IMAP session object.
  #
  # @return [nil]
  #
  # @see Net.imap_connect
  #
  def Net.imap_session(host,options={})
    Net.imap_connect(host,options) do |sess|
      yield sess if block_given?

      sess.logout if options[:user]
      sess.close
      sess.disconnect
    end

    return nil
  end
end
