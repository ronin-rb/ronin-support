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

require 'ronin/support/network/http/cookie'

require 'time'

module Ronin
  module Support
    module Network
      class HTTP
        #
        # Parses and generates `Set-Cookie` header values.
        #
        # @api public
        #
        # @since 1.0.0
        #
        class SetCookie < Cookie

          # The `Max-Age` cookie attribute.
          #
          # @return [Integer, nil]
          attr_reader :max_age

          # The `Expires` cookie attribute.
          #
          # @return [Time, nil]
          attr_reader :expires

          # The `Domain` cookie attribute.
          #
          # @return [String, nil]
          attr_reader :domain

          # The `Path` cookie attribute.
          #
          # @return [String, nil]
          attr_reader :path

          # The `SameSite` cookie attribute.
          #
          # @return [:strict, :lax, :none]
          attr_reader :same_site

          # The `HttpOnly` flag.
          #
          # @return [true, nil]
          attr_reader :http_only

          # The `Secure` flag.
          #
          # @return [true, nil]
          attr_reader :secure

          #
          # Initializes the `Set-Cookie` object.
          #
          # @param [Hash{String => String}] params
          #
          # @param [Time, nil] expires
          #   The parsed `Expires` value.
          #
          # @param [Integer, nil] max_age
          #   The parsed `Max-Age` value.
          #
          # @param [String, nil] path
          #   The parsed `Path` value.
          #
          # @param [String, nil] domain
          #   The parsed `Domain` value.
          #
          # @param [true, nil] http_only
          #   Indicates the `HttpOnly` flag is enabled.
          #
          # @param [true, nil] secure
          #   Indicates the `Secure` flag is enabled.
          #
          # @param [:strict, :lax, :none, nil] same_site
          #   The parsed `SameSite` value.
          #
          def initialize(params, expires:   nil,
                                 max_age:   nil,
                                 path:      nil,
                                 domain:    nil,
                                 http_only: nil,
                                 secure:    nil,
                                 same_site: nil)
            super(params)

            @expires   = expires
            @max_age   = max_age
            @path      = path
            @domain    = domain
            @http_only = http_only
            @secure    = secure
            @same_site = same_site
          end

          # Mapping of `SameSite` values to Symbols.
          SAME_SITE = {
            'None'   => :none,
            'Strict' => :strict,
            'Lax'    => :lax
          }

          #
          # Parses a `Set-Cookie` string.
          #
          # @param [String] string
          #   The raw `Set-Cookie` string.
          #
          # @return [Cookie]
          #   The parsed cookie.
          #
          # @raise [ArgumentError]
          #   The string contained an unknown `SameSite` value or flag.
          #
          def self.parse(string)
            kwargs = {}
            params = {}

            string.split(/;\s+/) do |field|
              if field.include?('=')
                key, value = field.split('=',2)

                case key
                when 'Max-Age' then kwargs[:max_age] = value.to_i
                when 'Expires' then kwargs[:expires] = Time.parse(value)
                when 'Path'    then kwargs[:path]    = value
                when 'Domain'  then kwargs[:domain]  = value
                when 'SameSite'
                  kwargs[:same_site] = SAME_SITE.fetch(value) do
                    raise(ArgumentError,"unrecognized SameSite value: #{value.inspect}")
                  end
                else
                  params[unescape(key)] = unescape(value)
                end
              else
                case field
                when 'HttpOnly' then kwargs[:http_only] = true
                when 'Secure'   then kwargs[:secure]    = true
                else
                  raise(ArgumentError,"unrecognized Cookie flag: #{field.inspect}")
                end
              end
            end

            return new(params,**kwargs)
          end

          #
          # Determines if the `HttpOnly` flag is set.
          #
          # @return [Boolean]
          #
          def http_only?
            @http_only == true
          end

          #
          # Determines if the `Secure` flag is set.
          #
          # @return [Boolean]
          #
          def secure?
            @secure == true
          end

          #
          # Converts the cookie back into a `Set-Cookie` value.
          #
          # @return [String]
          #   The formatted cookie.
          #
          def to_s
            string = super()
            string << "; Max-Age=#{@max_age}"          if @max_age
            string << "; Expires=#{@expires.httpdate}" if @expires
            string << "; Path=#{@path}"                if @path
            string << "; Domain=#{@domain}"            if @domain
            string << "; SameSite=#{@same_site.to_s.capitalize}" if @same_site

            if    @secure    then string << '; Secure'
            elsif @http_only then string << '; HttpOnly'
            end

            string
          end

        end
      end
    end
  end
end
