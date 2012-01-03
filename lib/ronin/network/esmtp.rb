#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/network/smtp'

module Ronin
  module Network
    #
    # Provides helper methods for communicating with ESMTP services.
    #
    module ESMTP
      include SMTP

      #
      # @see SMTP.message
      #
      # @api public
      #
      def esmtp_message(options={},&block)
        smtp_message(options,&block)
      end

      #
      # Creates a connection to the ESMTP server.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :port (SMTP.default_port)
      #   The port to connect to.
      #
      # @option options [String] :helo
      #   The HELO domain.
      #
      # @option options [Symbol] :auth
      #   The type of authentication to use. Can be either `:login`, `:plain`,
      #   or `:cram_md5`.
      #
      # @option options [String] :user
      #   The user-name to authenticate with.
      #
      # @option options [String] :password
      #   The password to authenticate with.
      #
      # @yield [session]
      #   If a block is given, it will be passed an ESMTP enabled session
      #   object.
      #
      # @yieldparam [Net::SMTP] session
      #   The ESMTP session.
      #
      # @return [Net::SMTP]
      #   The ESMTP enabled session.
      #
      # @api public
      #
      def esmtp_connect(host,options={})
        session = smtp_connect(host,options)
        session.esmtp = true

        yield session if block_given?
        return session
      end

      #
      # Starts an ESMTP session with the ESMTP enabled server.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @yield [session]
      #   If a block is given, it will be passed an ESMTP enabled session
      #   object. After the block has returned, the session will be closed.
      #
      # @yieldparam [Net::SMTP] session
      #   The ESMTP session.
      #
      # @see Net.esmtp_connect
      #
      # @api public
      #
      def esmtp_session(host,options={})
        smtp_session(host,options) do |session|
          session.esmtp = true

          yield session if block_given?
        end
      end
    end
  end
end
