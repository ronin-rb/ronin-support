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

require 'ronin/support/network/ssl'

begin
  require 'net/imap'
rescue LoadError => error
  warn "ronin/network/imap requires the net-imap gem be listed in the Gemfile."
  raise(error)
end

module Ronin
  module Support
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
        # @param [String, nil] user
        #   The user to authenticate as when connecting to the server.
        #
        # @param [String, nil] password
        #   The password to authenticate with when connecting to the server.
        #
        # @param [Integer] port
        #   The port the IMAP server is running on.
        #
        # @param [Boolean, Hash, nil] ssl
        #   Additional SSL options.
        #
        # @option ssl [Boolean] :verify
        #   Specifies that the SSL certificate should be verified.
        #
        # @option ssl [String] :certs
        #   The path to the file containing CA certs of the server.
        #
        # @param [:login, :cram_md5] auth
        #   The type of authentication to perform when connecting to the server.
        #   May be either `:login` or `:cram_md5`.
        #
        # @yield [imap]
        #   If a block is given, it will be passed the newly created IMAP
        #   session.
        #
        # @yieldparam [Net::IMAP] imap
        #   The newly created IMAP session object.
        #
        # @return [Net::IMAP]
        #   The newly created IMAP session object.
        #
        # @api public
        #
        def imap_connect(host,user,password, port: IMAP.default_port,
                                             ssl:  nil,
                                             auth: :login)
          host = host.to_s

          case ssl
          when Hash
            ssl        = true
            ssl_certs  = ssl[:certs]
            ssl_verify = SSL::VERIFY[ssl[:verify]]
          when TrueClass
            ssl        = true
            ssl_certs  = nil
            ssl_verify = nil
          else
            ssl        = false
            ssl_certs  = nil
            ssl_verify = false
          end

          imap = Net::IMAP.new(host,port,ssl,ssl_certs,ssl_verify)

          case auth
          when :cram_md5 then imap.authenticate('CRAM-MD5',user,passwd)
          else                imap.authenticate('LOGIN',user,passwd)
          end

          yield imap if block_given?
          return imap
        end

        #
        # Starts an IMAP session with the IMAP server.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#imap_connect}.
        #
        # @yield [imap]
        #   If a block is given, it will be passed the newly created IMAP
        #   session. After the block has returned, the session will be closed.
        #
        # @yieldparam [Net::IMAP] imap
        #   The newly created IMAP session object.
        #
        # @return [nil]
        #
        # @see #imap_connect
        #
        # @api public
        #
        def imap_session(host,user,password,**kwargs)
          imap = imap_connect(host,**kwargs)

          yield imap if block_given?

          imap.logout
          imap.close
          imap.disconnect
          return nil
        end
      end
    end
  end
end
