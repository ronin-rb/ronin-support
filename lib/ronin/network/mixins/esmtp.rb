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

require 'ronin/network/mixins/mixin'
require 'ronin/network/esmtp'

module Ronin
  module Network
    module Mixins
      #
      # Adds ESMTP convenience methods and connection parameters to a class.
      #
      # Defines the following parameters:
      #
      # * `host` (`String`) - ESMTP host.
      # * `port` (`Integer`) - ESMTP port.
      # * `esmtp_login` (`String`) - ESMTP authentication method to use.
      # * `esmtp_user` (`String`) - ESMTP user to login as.
      # * `esmtp_password` (`String`) - ESMTP password to login with.
      #
      module ESMTP
        include Mixin, Network::ESMTP

        # ESMTP host
        parameter :host, type:        String,
                         description: 'ESMTP host'

        # ESMTP port
        parameter :port, type:        Integer,
                         default:     Network::SMTP.default_port,
                         description: 'ESMTP port'

        # ESMTP authentication method to use
        parameter :esmtp_auth, type:        String,
                               description: 'ESMTP authentication method to use'

        # ESMTP user to login as
        parameter :esmtp_user, type:        String,
                               description: 'ESMTP user to login as'

        # ESMTP password to login with
        parameter :esmtp_password, type:        String,
                                   description: 'ESMTP password to login with'

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
        #   Use {#esmtp_auth} instead.
        #
        def esmtp_login
          warn "DEPRECATED: #{SMTP}#esmtp_login. Use #esmtp_auth instead"

          return smtp_auth
        end

        #
        # @deprecated
        #   Use {#esmtp_auth=} instead.
        #
        def esmtp_login=(new_login)
          warn "DEPRECATED: #{SMTP}#esmtp_login=. Use #esmtp_auth= instead"

          self.esmtp_auth = new_login
        end

        #
        # Creates a connection to the ESMTP server.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port
        #  The port to connect to. Defaults to {#port}.
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
        #   The type of authentication to use. Defaults to {#esmtp_auth}.
        #   May be one of the following:
        #
        #   * `:login`
        #   * `:plain`
        #   * `:cram_md5`
        #
        # @option options [String] :user
        #   The user-name to authenticate with. Defaults to {#esmtp_user}.
        #
        # @option options [String] :password
        #   The password to authenticate with. Defaults to {#esmtp_password}.
        #
        # @yield [esmtp]
        #   If a block is given, it will be passed an ESMTP enabled
        #   session object.
        #
        # @yieldparam [Net::SMTP] esmtp
        #   The ESMTP session.
        #
        # @return [Net::SMTP]
        #   The ESMTP enabled session.
        #
        # @see Network::ESMTP#esmtp_connect
        #
        # @api public
        #
        def esmtp_connect(host=nil,options={},&block)
          host  ||= self.host
          options = esmtp_merge_options(options)

          print_info "Connecting to #{host}:#{options[:port]} ..."

          return super(host,options,&block)
        end

        #
        # Starts a session with the ESMTP server.
        #
        # @param [String] host
        #   The host to connect to. Defaults to {#host}.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port
        #  The port to connect to. Defaults to {#port}.
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
        # @option options [Symbol] :auth
        #   The type of authentication to use. Defaults to {#esmtp_auth}.
        #   May be one of the following:
        #
        #   * `:login`
        #   * `:plain`
        #   * `:cram_md5`
        #
        # @option options [String] :user
        #   The user-name to authenticate with. Defaults to {#esmtp_user}.
        #
        # @option options [String] :password
        #   The password to authenticate with. Defaults to {#esmtp_password}.
        #
        # @yield [esmtp]
        #   If a block is given, it will be passed an ESMTP enabled
        #   session object. After the block has returned, the session
        #   will be closed.
        #
        # @yieldparam [Net::SMTP] esmtp
        #   The ESMTP session.
        #
        # @see Network::ESMTP#esmtp_session
        #
        # @api public
        #
        def esmtp_session(host=nil,options={})
          host  ||= self.host
          options = esmtp_merge_options(options)

          super(host,options) do |esmtp|
            yield esmtp if block_given?

            print_info "Logging out ..."
          end

          print_info "Disconnected from #{host}:#{options[:port]}"
          return nil
        end

        private

        #
        # Merges the ESMTP parameters into the options for {Network::ESMTP}
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
        def esmtp_merge_options(options={})
          options[:port]     ||= self.port
          options[:auth]     ||= self.esmtp_auth
          options[:user]     ||= self.esmtp_user
          options[:password] ||= self.esmtp_password

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
