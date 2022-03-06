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

require 'ronin/support/network/smtp/email'
require 'ronin/support/network/mixins/ssl'

begin
  require 'net/smtp'
rescue LoadError => error
  warn "ronin/network/smtp requires the net-smtp gem listed in the Gemfile."
  raise(error)
end

module Ronin
  module Support
    module Network
      module Mixins
        #
        # Provides helper methods for communicating with SMTP services.
        #
        module SMTP
          include Mixins::SSL
  
          # Default SMTP port
          DEFAULT_PORT = 25
  
          #
          # Creates a properly formatted email.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for
          #   {Network::SMTP::Email#initialize}.
          #
          # @yield [email]
          #   If a block is given, it will be passed the newly created
          #   {Network::SMTP::Email} object.
          #
          # @yieldparam [Email] email
          #   The new Email object.
          #
          # @return [String]
          #   Formatted SMTP email.
          #
          # @see Email#initialize
          #
          # @api public
          #
          def self.message(**kwargs,&block)
            Email.new(**kwargs,&block).to_s
          end
  
          #
          # Creates a new email message.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for
          #   {Network::SMTP::Email#initialize}.
          #
          # @yield [email]
          #   The given block will be passed the new email.
          #
          # @yieldparam [Email] email
          #   The new email.
          #
          # @see Email#initialize
          #
          # @api public
          #
          def smtp_message(**kwargs,&block)
            Email.new(**kwargs,&block)
          end
  
          #
          # Creates a connection to the SMTP server.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [String] user
          #   The user-name to authenticate with.
          #
          # @param [String] password
          #   The password to authenticate with.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Boolean, Hash] ssl
          #   Additional SSL options.
          #
          # @option ssl [Boolean] :verify
          #   Specifies that the SSL certificate should be verified.
          #
          # @option ssl [String] :certs
          #   The path to the file containing CA certs of the server.
          #
          # @param [String] helo
          #   The HELO domain.
          #
          # @param [:login, :plain, :cram_md5] auth
          #   The type of authentication to use. Can be either `:login`,
          #   `:plain`, or `:cram_md5`.
          #
          # @yield [smtp]
          #   If a block is given, it will be passed an SMTP session object.
          #
          # @yieldparam [Net::SMTP] smtp
          #   The SMTP session.
          #
          # @return [Net::SMTP]
          #   The SMTP session.
          #
          # @example
          #   smtp_connect('www.example.com', user: 'joe')
          #
          # @api public
          #
          def smtp_connect(host,user,password, port: DEFAULT_PORT,
                                               ssl:  nil,
                                               helo: 'localhost',
                                               auth: :login)
            host = host.to_s
            user = user.to_s
            password = password.to_s
  
            case ssl
            when Hash
              ssl     = true
              context = ssl_context(ssl)
            when TrueClass
              ssl     = true
              context = ssl_context
            end
  
            smtp = Net::SMTP.new(host,port)
            smtp.enable_starttls(context) if ssl
            smtp.start(helo,user,password,auth)
  
            yield smtp if block_given?
            return smtp
          end
  
          #
          # Starts a session with the SMTP server.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {#smtp_connect}.
          #
          # @yield [smtp]
          #   If a block is given, it will be passed an SMTP session object.
          #   After the block has returned, the session will be closed.
          #
          # @yieldparam [Net::SMTP] smtp
          #   The SMTP session.
          #
          # @example
          #   smtp_session('www.example.com', user: 'joe') do |smtp|
          #     # ...
          #   end
          #
          # @see #smtp_connect
          #
          # @api public
          #
          def smtp_session(host,user,password, **kwargs)
            smtp = smtp_connect(host,**kwargs)
  
            yield smtp if block_given?
  
            smtp.finish
            return nil
          end
  
          #
          # Connects to an SMTP server and sends a message.
          #
          # @param [String] host
          #   The host to connect to.
          #
          # @param [Integer] port
          #   The port to connect to.
          #
          # @param [Boolean, Hash] ssl
          #   Additional SSL options.
          #
          # @option ssl [Boolean] :verify
          #   Specifies that the SSL certificate should be verified.
          #
          # @option ssl [String] :certs
          #   The path to the file containing CA certs of the server.
          #
          # @param [String] helo
          #   The HELO domain.
          #
          # @param [:login, :plain, :cram_md5] auth
          #   The type of authentication to use. Can be either `:login`,
          #   `:plain`, or `:cram_md5`.
          #
          # @param [String] from
          #   The address the email is from.
          #
          # @param [Array, String] to
          #   The address that the email should be sent to.
          #
          # @param [String] subject
          #   The subject of the email.
          #
          # @param [String] message_id
          #   Message-ID of the email.
          #
          # @param [String, Time] date
          #   The date the email was sent on.
          #
          # @param [Hash<String => String}] headers
          #   Additional headers.
          #
          # @param [String, Array<String>] body
          #   The body of the email.
          #
          # @yield [email]
          #   The given block will be passed the new email to be sent.
          #
          # @yieldparam [SMTP::Email] email
          #   The new email to be sent.
          #
          # @see #smtp_session
          #
          # @example
          #   smtp_send_message 'www.example.com',
          #                     to:         'joe@example.com',
          #                     from:       'eve@example.com',
          #                     subject:    'Hello',
          #                     message_id: 'XXXX',
          #                     body:       'Hello'
          #
          # @example Using the block:
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
          def smtp_send_message(host,user,password, # smtp options
                                                    port: DEFAULT_PORT,
                                                    ssl:  nil,
                                                    helo: 'localhost',
                                                    auth: :login,
                                                    # email options
                                                    from:       nil,
                                                    to:         nil,
                                                    subject:    nil,
                                                    date:       Time.now,
                                                    message_id: nil,
                                                    headers:    nil,
                                                    body:       nil,
                                                    &block)
            email = smtp_message(
              to:         to,
              subject:    subject,
              date:       date,
              message_id: message_id,
              headers:    headers,
              body:       body,
              &block
            )
  
            smtp_session(host,user,password,
                         port: port, ssl: ssl, helo: helo, auth: auth) do |smtp|
              smtp.send_message(email.to_s, email.from, email.to)
            end
          end
        end
      end
    end
  end
end
