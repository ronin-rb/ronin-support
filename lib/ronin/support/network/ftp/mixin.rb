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
  module Support
    module Network
      module FTP
        #
        # Provides helper methods for communicating with FTP servers.
        #
        module Mixin
          # Default FTP port
          DEFAULT_PORT = 21

          # Default FTP user
          DEFAULT_USER = 'anonymous'

          #
          # Creates a connection to the FTP server.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [String] user
          #   The user to authenticate with.
          #
          # @param [String] password
          #   The password to authenticate with.
          #
          # @param [String] account
          #   The FTP account information to send via the `ACCT` command.
          #
          # @param [Boolean] passive
          #   Specifies whether the FTP session should use passive mode.
          #
          # @yield [ftp]
          #   If a block is given, it will be passed an FTP session object.
          #   Once the block returns, the FTP session will be closed.
          #
          # @yieldparam [Net::FTP] ftp
          #   The FTP session.
          #
          # @return [Net::FTP, nil]
          #   The FTP session. If a block is given, then `nil` will be returned.
          #
          # @example
          #   ftp_connect('www.example.com', user: 'joe', password: 'secret')
          #
          # @api public
          #
          def ftp_connect(host, port:     DEFAULT_PORT,
                                user:     DEFAULT_USER,
                                password: nil,
                                account:  nil,
                                passive:  true)
            host = host.to_s

            ftp = Net::FTP.new
            ftp.connect(host,port)
            ftp.login(user,password,account)
            ftp.passive = passive

            if block_given?
              yield ftp
              ftp.close
            else
              return ftp
            end
          end
        end
      end
    end
  end
end
