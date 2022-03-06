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

require 'ronin/support/network/mixins/smtp'

module Ronin
  module Support
    module Network
      module Mixins
        #
        # Provides helper methods for communicating with ESMTP services.
        #
        module ESMTP
          include Mixins::SMTP
  
          #
          # @see SMTP.message
          #
          # @api public
          #
          def esmtp_message(**kwargs,&block)
            smtp_message(**kwargs,&block)
          end
  
          #
          # Creates a connection to the ESMTP server.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#smtp_connect}.
          #
          # @option kwargs [Integer] :port (SMTP::DEFAULT_PORT)
          #   The port to connect to.
          #
          # @option kwargs [Boolean, Hash] :ssl
          #   Additional SSL options.
          #
          # @option :ssl [Boolean] :verify
          #   Specifies that the SSL certificate should be verified.
          #
          # @option :ssl [String] :certs
          #   The path to the file containing CA certs of the server.
          #
          # @option kwargs [String] :helo
          #   The HELO domain.
          #
          # @option kwargs [Symbol] :auth
          #   The type of authentication to use.
          #   May be one of the following:
          #
          #   * `:login`
          #   * `:plain`
          #   * `:cram_md5`
          #
          # @option kwargs [String] :user
          #   The user-name to authenticate with.
          #
          # @option kwargs [String] :password
          #   The password to authenticate with.
          #
          # @yield [esmtp]
          #   If a block is given, it will be passed an ESMTP enabled session
          #   object.
          #
          # @yieldparam [Net::SMTP] esmtp
          #   The ESMTP session.
          #
          # @return [Net::SMTP]
          #   The ESMTP enabled session.
          #
          # @api public
          #
          def esmtp_connect(host,**kwargs)
            smtp = smtp_connect(host,**kwargs)
            smtp.esmtp = true
  
            yield smtp if block_given?
            return smtp
          end
  
          #
          # Starts an ESMTP session with the ESMTP enabled server.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#smtp_session}.
          #
          # @option kwargs [Integer] :port (SMTP::DEFAULT_PORT)
          #   The port to connect to.
          #
          # @option kwargs [Boolean, Hash] :ssl
          #   Additional SSL options.
          #
          # @option :ssl [Boolean] :verify
          #   Specifies that the SSL certificate should be verified.
          #
          # @option :ssl [String] :certs
          #   The path to the file containing CA certs of the server.
          #
          # @option kwargs [String] :helo
          #   The HELO domain.
          #
          # @option kwargs [Symbol] :auth
          #   The type of authentication to use.
          #   May be one of the following:
          #
          #   * `:login`
          #   * `:plain`
          #   * `:cram_md5`
          #
          # @option kwargs [String] :user
          #   The user-name to authenticate with.
          #
          # @option kwargs [String] :password
          #   The password to authenticate with.
          #
          # @yield [esmtp]
          #   If a block is given, it will be passed an ESMTP enabled session
          #   object. After the block has returned, the session will be closed.
          #
          # @yieldparam [Net::SMTP] esmtp
          #   The ESMTP session.
          #
          # @see esmtp_connect
          #
          # @api public
          #
          def esmtp_session(host,**kwargs)
            smtp_session(host,**kwargs) do |smtp|
              smtp.esmtp = true
  
              yield smtp if block_given?
            end
          end
        end
      end
    end
  end
end
