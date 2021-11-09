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

require 'ronin/network/mixins/mixin'
require 'ronin/network/smtp'

module Ronin
  module Network
    module Mixins
      #
      # Adds SMTP convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - SMTP host.
      # * `port` (`Integer`) - SMTP port.
      # * `smtp_auth` (`String`) - SMTP authentication method.
      # * `smtp_user` (`String`) - SMTP user to login as.
      # * `smtp_password` (`String`) - SMTP password to login with.
      # * `ssl` (`Boolean`) - Enables SSL.
      # * `ssl_verify` (`Boolean`) - SSL verify mode.
      # * `ssl_cert` (`String`) - Path to the `.crt` file.
      #
      module SMTP
        include Mixin, Network::SMTP

        # SMTP host
        parameter :host, type:        String,
                         description: 'SMTP host'

        # SMTP port
        parameter :port, type:        Integer,
                         description: 'SMTP port'

        # SMTP authentication method
        #
        # @since 0.6.0
        parameter :smtp_auth, type:        String,
                              description: 'SMTP authentication method'

        # SMTP user to login as
        parameter :smtp_user, type:        String,
                              description: 'SMTP user to login as'

        # SMTP user to login with
        parameter :smtp_password, type:        String,
                                  description: 'SMTP password to login with'

        # Enables SSL support
        parameter :ssl, type:        true,
                        description: 'Enables SSL support'

        # SSL verify mode
        parameter :ssl_verify, type:        true,
                               description: 'Verifies the SSL certificate'

        # SSL cert file
        parameter :ssl_cert, type:        String,
                             description: 'SSL cert file'

        #
        # @deprecated
        #   Use {#smtp_auth} instead.
        #
        def smtp_login
          warn "DEPRECATED: #{SMTP}#smtp_login. Use #smtp_auth instead"

          return smtp_auth
        end

        #
        # @deprecated
        #   Use {#smtp_auth=} instead.
        #
        def smtp_login=(new_login)
          warn "DEPRECATED: #{SMTP}#smtp_login=. Use #smtp_auth= instead"

          self.smtp_auth = new_login
        end

        #
        # Creates a connection to the SMTP server.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port
        #   The port to connect to. Defaults to {#port}.
        #
        # @option options [Boolean, Hash] :ssl
        #   Additional SSL options.
        #
        # @option :ssl [Boolean] :verify
        #   Specifies that the SSL certificate should be verified.
        #
        # @option :ssl [String] :certs
        #   The path to the file containing CA certs of the server.
        #
        # @option options [String] :helo
        #   The HELO domain.
        #
        # @option options [String] :helo
        #   The HELO domain.
        #
        # @option options [Symbol] :auth
        #   The type of authentication to use. Defaults to {#smtp_auth}.
        #   May be one of the following:
        #
        #   * `:login`
        #   * `:plain`
        #   * `:cram_md5`
        #
        # @option options [String] :user
        #   The user-name to authenticate with. Defaults to {#smtp_user}.
        #
        # @option options [String] :password
        #   The password to authenticate with. Defaults to {#smtp_password}.
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
        # @see Network::SMTP#smtp_connect
        #
        # @api public
        #
        def smtp_connect(host=nil,options={},&block)
          host  ||= self.host
          options = smtp_merge_options(options)

          print_info "Connecting to #{host}:#{options[:port]} ..."

          return super(host,smtp_merge_options(options),&block)
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
        # @option options [Integer] :port
        #   The port to connect to. Defaults to {#port}.
        #
        # @option options [Boolean, Hash] :ssl
        #   Additional SSL options.
        #
        # @option :ssl [Boolean] :verify
        #   Specifies that the SSL certificate should be verified.
        #
        # @option :ssl [String] :certs
        #   The path to the file containing CA certs of the server.
        #
        # @option options [String] :helo
        #   The HELO domain.
        #
        # @option options [String] :helo
        #   The HELO domain.
        #
        # @option options [Symbol] :auth
        #   The type of authentication to use. Defaults to {#smtp_auth}.
        #   May be one of the following:
        #
        #   * `:login`
        #   * `:plain`
        #   * `:cram_md5`
        #
        # @option options [String] :user
        #   The user-name to authenticate with. Defaults to {#smtp_user}.
        #
        # @option options [String] :password
        #   The password to authenticate with. Defaults to {#smtp_password}.
        #
        # @yield [smtp]
        #   If a block is given, it will be passed an SMTP session object.
        #   After the block has returned, the session will be closed.
        #
        # @yieldparam [Net::SMTP] smtp
        #   The SMTP session.
        #
        # @see Network::SMTP#smtp_session
        #
        # @api public
        #
        def smtp_session(host=nil,options={},&block)
          host  ||= self.host
          options = smtp_merge_options(options)

          super(host,options) do |smtp|
            yield smtp if block_given?

            print_info "Logging out ..."
          end

          print_info "Disconnected to #{host}:#{options[:port]}"
          return nil
        end

        private

        #
        # Merges the SMTP parameters into the options for {Network::SMTP}
        # methods.
        #
        # @param [Hash] options
        #   The original options.
        #
        # @return [Hash]
        #   The merged options.
        #
        # @since 0.4.0
        #
        # @api private
        #   
        def smtp_merge_options(options={})
          options[:port]     ||= self.port
          options[:auth]     ||= self.smtp_auth
          options[:user]     ||= self.smtp_user
          options[:password] ||= self.smtp_password

          if self.ssl?
            options[:ssl] = options.fetch(:ssl) do
              {verify: self.ssl_verify?, certs:  self.ssl_cert}
            end
          end

          return options
        end
      end
    end
  end
end
