#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/network/ssl'

require 'net/imap'

module Ronin
  module Network
    #
    # Provides helper methods for communicating with IMAP services.
    #
    module IMAP
      # Default IMAP port
      DEFAULT_PORT = 143

      #
      # @return [Integer]
      #   The default Ronin IMAP port.
      #
      # @api public
      #
      def self.default_port
        @default_port ||= DEFAULT_PORT
      end

      #
      # Sets the default Ronin IMAP port.
      #
      # @param [Integer] port
      #   The new default Ronin IMAP port.
      #
      # @api public
      #
      def self.default_port=(port)
        @default_port = port
      end

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
      # @api public
      #
      def imap_connect(host,options={})
        host   = host.to_s
        port   = (options[:port] || IMAP.default_port)
        certs  = options[:certs]
        auth   = options[:auth]
        user   = options[:user]
        passwd = options[:password]

        if options[:ssl]
          ssl        = true
          ssl_certs  = options[:ssl][:certs]
          ssl_verify = SSL::VERIFY[options[:ssl][:verify]]
        else
          ssl        = false
          ssl_certs  = nil
          ssl_verify = false
        end

        session = Net::IMAP.new(host,port,ssl,ssl_certs,ssl_verify)

        if user
          if auth == :cram_md5
            session.authenticate('CRAM-MD5',user,passwd)
          else
            session.authenticate('LOGIN',user,passwd)
          end
        end

        yield session if block_given?
        return session
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
      # @see imap_connect
      #
      # @api public
      #
      def imap_session(host,options={})
        session = imap_connect(host,options)

        yield session if block_given?

        session.logout if options[:user]
        session.close
        session.disconnect
        return nil
      end
    end
  end
end
