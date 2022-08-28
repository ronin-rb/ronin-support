#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      module IMAP
        #
        # Provides helper methods for communicating with IMAP services.
        #
        module Mixin
          # Default IMAP port
          DEFAULT_PORT = 143

          # Authentication types.
          AUTH_TYPES = {
            login:    'LOGIN',
            cram_md5: 'CRAM_MD5'
          }

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
          #   The type of authentication to perform when connecting to the
          #   server. May be either `:login` or `:cram_md5`.
          #
          # @yield [imap]
          #   If a block is given, it will be passed the newly created IMAP
          #   session. Once the block returns, it will close the IMAP session.
          #
          # @yieldparam [Net::IMAP] imap
          #   The newly created IMAP session object.
          #
          # @return [Net::IMAP, nil]
          #   The newly created IMAP session object. If a block is given, `nil`
          #   will be returned.
          #
          # @raise [ArgumentType]
          #   The `auth:` keyword argument must be either `:login` or
          #   `:cram_md5`.
          #
          # @api public
          #
          def imap_connect(host,user,password, port: DEFAULT_PORT,
                                               ssl:  nil,
                                               auth: :login)
            host      = host.to_s
            auth_type = AUTH_TYPES.fetch(auth) do
              raise(ArgumentError,"auth: must be either :login or :cram_md5")
            end

            case ssl
            when Hash
              ssl        = true
              ssl_certs  = ssl[:certs]
              ssl_verify = Network::SSL::VERIFY[ssl[:verify]]
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
            imap.authenticate(auth_type,user,passwd)

            if block_given?
              yield imap
              imap.logout
              imap.close
              imap.disconnect
            else
              return imap
            end
          end
        end
      end
    end
  end
end
