# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'uri'
require 'time'

module Ronin
  module Support
    module Network
      class HTTP
        #
        # Parses and generates `Cookie` header values.
        #
        # @api public
        #
        # @since 1.0.0
        #
        class Cookie

          include Enumerable

          # Parameters of the cookie.
          #
          # @return [Hash{String => String}]
          attr_reader :params

          #
          # Initializes the `Cookie` header.
          #
          # @param [Hash{String => String}] params
          #   The params for the cookie.
          #
          def initialize(params={})
            @params = params
          end

          #
          # Initializes a copy of a cookie.
          #
          # @param [Cookie] other
          #   The original cookie that is being copied.
          #
          def initialize_copy(other)
            @params = other.params.dup
          end

          #
          # Escapes the string so that it can be embedded in a `Cookie` or
          # `Set-Cookie` header.
          #
          # @param [String] string
          #   The string to escape.
          #
          # @return [String]
          #   The escaped String.
          #
          def self.escape(string)
            URI.encode_www_form_component(string)
          end

          #
          # Unescapes a string that came from a `Cookie` or `Set-Cookie` header.
          #
          # @param [String] string
          #   The String to unescape.
          #
          # @param [Encoding] encoding
          #   The optional String encoding to use.
          #
          # @return [String]
          #   The unescaped String.
          #
          def self.unescape(string,encoding=Encoding::UTF_8)
            URI.decode_www_form_component(string,encoding)
          end

          #
          # Parses a `Cookie` string.
          #
          # @param [String] string
          #   The raw `Cookie` string.
          #
          # @return [Cookie]
          #   The parsed cookie.
          #
          def self.parse(string)
            params = {}

            string.split(/;\s+/) do |field|
              key, value = field.split('=',2)

              params[unescape(key)] = unescape(value)
            end

            return new(params)
          end

          #
          # Determines if the cookie has the param with the given name.
          #
          # @param [String, Symbol] name
          #   The param name to check for.
          #
          # @return [Boolean]
          #
          def has_param?(name)
            @params.has_key?(name.to_s)
          end

          #
          # Fetches a param from the cookie.
          #
          # @param [String] name
          #   The name of the param.
          #
          # @return [String, nil]
          #   The value of the param in the cookie.
          #
          def [](name)
            @params[name.to_s]
          end

          #
          # Sets a param in the cookie.
          #
          # @param [String] name
          #   The param name to set.
          #
          # @param [#to_s] value
          #   The param value to set.
          #
          # @return [#to_s]
          #   The set param value.
          #
          def []=(name,value)
            name = name.to_s

            case value
            when nil then @params.delete(name)
            else          @params[name] = value.to_s
            end

            return value
          end

          #
          # Enumerates over the params in the cookie.
          #
          # @yield [name,value]
          #   If a block is given, then it will be passed each param name and
          #   corresponding value.
          #
          # @yieldparam [String] name
          #   The name of the cookie param.
          #
          # @yieldparam [String] value
          #   The value of the cookie param.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumerator will be returned.
          #
          def each(&block)
            @params.each(&block)
          end

          #
          # Merges other cookie params into the cookie.
          #
          # @param [Cookie, Hash] params
          #   The other cookie params to merge into the cookie.
          #
          # @return [self]
          #
          def merge!(params)
            params.each do |name,value|
              self[name] = value
            end

            return self
          end

          #
          # Merges the cookie with other cookie params.
          #
          # @param [Cookie, Hash] params
          #   The other cookie parmas to merge.
          #
          # @return [Cookie]
          #   The new combined cookie.
          #
          def merge(params)
            clone.merge!(params)
          end

          #
          # Determines if the cookie is empty.
          #
          # @return [Boolean]
          #
          def empty?
            @params.empty?
          end

          #
          # Converts the cookie into a Hash of names and values.
          #
          # @return [Hash{String => String}]
          #   The params of the cookie.
          #
          def to_h
            @params
          end

          #
          # Converts the cookie back into a `Cookie` value.
          #
          # @return [String]
          #   The formatted cookie.
          #
          def to_s
            @params.map { |name,value|
              "#{self.class.escape(name)}=#{self.class.escape(value)}"
            }.join('; ')
          end

        end
      end
    end
  end
end
