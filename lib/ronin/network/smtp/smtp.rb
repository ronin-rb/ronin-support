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

require 'ronin/network/smtp/email'

require 'net/smtp'

module Ronin
  module Network
    #
    # Provides helper methods for communicating with SMTP services.
    #
    module SMTP
      # Default SMTP port
      DEFAULT_PORT = 25

      #
      # @return [Integer]
      #   The default Ronin SMTP port.
      #
      # @api public
      #
      def SMTP.default_port
        @default_port ||= DEFAULT_PORT
      end

      #
      # Sets the default Ronin SMTP port.
      #
      # @param [Integer] port
      #   The new default Ronin SMTP port.
      #
      # @api public
      #
      def SMTP.default_port=(port)
        @default_port = port
      end

      #
      # Creates a properly formatted email.
      #
      # @yield [email]
      #   If a block is given, it will be passed the newly created Email
      #   object.
      #
      # @yieldparam [Email] email
      #   The new Email object.
      #
      # @return [String]
      #   Formatted SMTP email.
      #
      # @see SMTP::Email
      #
      # @api public
      #
      def SMTP.message(options={},&block)
        Email.new(options,&block).to_s
      end

      #
      # Creates a new email message.
      #
      # @param [Hash] options
      #   Additional options for the email.
      #
      # @yield [email]
      #   The given block will be passed the new email.
      #
      # @yieldparam [Email] email
      #   The new email.
      #
      # @see Email.new
      #
      # @api public
      #
      def smtp_message(options={},&block)
        Email.new(options,&block)
      end

      #
      # Creates a connection to the SMTP server.
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
      #   If a block is given, it will be passed an SMTP session object.
      #
      # @yieldparam [Net::SMTP] session
      #   The SMTP session.
      #
      # @return [Net::SMTP]
      #   The SMTP session.
      #
      # @example
      #   smtp_connect('www.example.com', :user => 'joe')
      #
      # @api public
      #
      def smtp_connect(host,options={})
        host = host.to_s
        port = (options[:port] || SMTP.default_port)

        helo = options[:helo]

        auth = options[:auth]
        user = options[:user]
        password = options[:password]

        session = Net::SMTP.start(host,port,helo,user,password,auth)

        yield session if block_given?
        return session
      end

      #
      # Starts a session with the SMTP server.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @yield [session]
      #   If a block is given, it will be passed an SMTP session object.
      #   After the block has returned, the session will be closed.
      #
      # @yieldparam [Net::SMTP] session
      #   The SMTP session.
      #
      # @example
      #   smtp_session('www.example.com', :user => 'joe') do |smtp|
      #     # ...
      #   end
      #
      # @see smtp_connect
      #
      # @api public
      #
      def smtp_session(host,options={})
        session = smtp_connect(host,options)

        yield session if block_given?

        session.finish
        return nil
      end

      #
      # @since 0.2.0
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Hash] options
      #   Additional SMTP and Email options.
      #
      # @yield [email]
      #   The given block will be passed the new email to be sent.
      #
      # @yieldparam [SMTP::Email] email
      #   The new email to be sent.
      #
      # @see smtp_session
      #
      # @example
      #   smtp_send_message 'www.example.com', :to => 'joe@example.com',
      #                                        :from => 'eve@example.com',
      #                                        :subject => 'Hello',
      #                                        :message_id => 'XXXX',
      #                                        :body => 'Hello'
      #
      # @example Using the block.
      #   smtp_send_message('www.example.com') do |email|
      #     email.to = 'joe@example.com'
      #     email.from 'eve@example.com'
      #     email.subject = 'Hello'
      #     email.message_id = 'XXXXXXXXXX'
      #     email.body << 'Hello!'
      #   end
      #
      # @since 0.2.0
      #
      # @api public
      #
      def smtp_send_message(host,options={},&block)
        email = smtp_message(options,&block)

        smtp_session(host,options) do |smtp|
          smtp.send_message(email.to_s, email.from, email.to)
        end
      end
    end
  end
end
