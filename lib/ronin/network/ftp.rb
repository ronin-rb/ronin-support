#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
#
# ronin-support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
#

begin
  require 'net/ftp'
rescue LoadError => error
  warn "ronin/network/ftp requires the net-ftp gem be listed in the Gemfile."
  raise(error)
end

module Ronin
  module Network
    #
    # Provides helper methods for communicating with FTP servers.
    #
    # @since 0.5.0
    #
    module FTP
      # Default FTP port
      DEFAULT_PORT = 21

      # Default FTP user
      DEFAULT_USER = 'anonymous'

      #
      # Default port used by {FTP}.
      #
      # @return [Integer]
      #   The default Ronin FTP port.
      #
      # @api public
      #
      def self.default_port
        @default_port ||= DEFAULT_PORT
      end

      #
      # Sets the default port used by {FTP}.
      #
      # @param [Integer] new_port
      #   The new default Ronin FTP port.
      #
      # @api public
      #
      def self.default_port=(new_port)
        @default_port = new_port
      end

      #
      # Creates a connection to the FTP server.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :port (FTP.default_port)
      #   The port to connect to.
      #
      # @option options [String] :user (DEFAULT_USER)
      #   The user to authenticate with.
      #
      # @option options [String] :password
      #   The password to authenticate with.
      #
      # @option options [String] :account
      #   The FTP account information to send via the `ACCT` command.
      #
      # @option options [Boolean] :passive (true)
      #   Specifies whether the FTP session should use passive mode.
      #
      # @yield [ftp]
      #   If a block is given, it will be passed an FTP session object.
      #
      # @yieldparam [Net::FTP] ftp
      #   The FTP session.
      #
      # @return [Net::FTP]
      #   The FTP session.
      #
      # @example
      #   ftp_connect('www.example.com', user: 'joe', password: 'secret')
      #
      # @api public
      #
      def ftp_connect(host,options={})
        host     = host.to_s
        port     = (options[:port] || FTP.default_port)
        user     = (options[:user] || DEFAULT_USER)
        password = options[:password]
        acct     = options[:account]

        ftp = Net::FTP.new
        ftp.connect(host,port)
        ftp.login(user,password,acct)
        ftp.passive = options.fetch(:passive,true)

        yield ftp if block_given?
        return ftp
      end

      #
      # Starts a session with the FTP server.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :port (FTP.default_port)
      #   The port to connect to.
      #
      # @option options [String] :user (DEFAULT_USER)
      #   The user to authenticate with.
      #
      # @option options [String] :password
      #   The password to authenticate with.
      #
      # @option options [String] :account
      #   The FTP account information to send via the `ACCT` command.
      #
      # @option options [Boolean] :passive (true)
      #   Specifies whether the FTP session should use passive mode.
      #
      # @yield [ftp]
      #   If a block is given, it will be passed an FTP session object.
      #   After the block has returned, the session will be closed.
      #
      # @yieldparam [Net::FTP] ftp
      #   The FTP session.
      #
      # @example
      #   ftp_session('www.example.com', user: 'joe') do |ftp|
      #     # ...
      #   end
      #
      # @see Network::FTP#ftp_session
      #
      # @api public
      #
      def ftp_session(host,options={})
        ftp = ftp_connect(host,options)

        yield ftp if block_given?

        ftp.close
        return nil
      end
    end
  end
end
