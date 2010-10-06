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

require 'ronin/network/pop3'

require 'net/pop'

module Net
  #
  # Creates a connection to the POP3 server.
  #
  # @param [String] host
  #   The host to connect to.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Integer] :port (Ronin::Network::POP3.default_port)
  #   The port the POP3 server is running on.
  #
  # @option options [String] :user
  #   The user to authenticate with when connecting to the POP3 server.
  #
  # @option options [String] :password
  #   The password to authenticate with when connecting to the POP3 server.
  #
  # @yield [session]
  #   If a block is given, it will be passed the newly created POP3 session.
  #
  # @yieldparam [Net::POP3] session
  #   The newly created POP3 session.
  #
  # @return [Net::POP3]
  #   The newly created POP3 session.
  #
  def Net.pop3_connect(host,options={})
    port = (options[:port] || Ronin::Network::POP3.default_port)
    user = options[:user]
    password = options[:password]

    session = Net::POP3.start(host,port,user,password)

    yield session if block_given?
    return session
  end

  #
  # Starts a session with the POP3 server.
  #
  # @param [String] host
  #   The host to connect to.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @yield [session]
  #   If a block is given, it will be passed the newly created POP3 session.
  #   After the block has returned, the session will be closed.
  #
  # @yieldparam [Net::POP3] session
  #   The newly created POP3 session.
  #
  # @return [nil]
  #
  def Net.pop3_session(host,options={})
    session = Net.pop3_connect(host,options)

    yield session if block_given?

    session.finish
    return nil
  end
end
