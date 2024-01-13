# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/smtp/mixin'

module Ronin
  module Support
    module Network
      module ESMTP
        #
        # Provides helper methods for communicating with ESMTP services.
        #
        module Mixin
          include SMTP::Mixin

          #
          # Alias for {SMTP::Mixin#smtp_message}.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {SMTP::Mixin#smtp_message}.
          #
          # @return [SMTP::Email]
          #   The new email object.
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
          #   If a block is given, it will be passed an ESMTP enabled session.
          #   Once the block returns the ESMTP session will be closed.
          #
          # @yieldparam [Net::SMTP] esmtp
          #   The ESMTP session.
          #
          # @return [Net::SMTP, nil]
          #   The ESMTP enabled session. If a block is given, `nil` will be
          #   returned.
          #
          # @api public
          #
          def esmtp_connect(host,**kwargs)
            if block_given?
              smtp_connect(host,**kwargs) do |smtp|
                smtp.esmtp = true
                yield smtp
              end
            else
              smtp = smtp_connect(host,**kwargs)

              smtp.esmtp = true
              return smtp
            end
          end
        end
      end
    end
  end
end
