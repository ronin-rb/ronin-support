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

require 'base64'

#
# Adds Ruby 1.9 specific methods when running on Ruby 1.8.7.
#
module Base64
  if RUBY_VERSION < '1.9.'
    module_function

    #
    # Strictly encodes a base64 String.
    #
    # @param [String] bin
    #   The String to encode.
    #
    # @return [String]
    #   The strictly encoded base64 String.
    #
    # @note
    #   This method complies with RFC 4648.
    #   No line feeds are added.
    #
    def strict_encode64(bin)
      encode64(bin).tr("\n",'')
    end

    #
    # Decodes a strictly base64 encoded String.
    #
    # @param [String] str
    #   The strictly encoded base64 String.
    #
    # @return [String]
    #   The decoded String.
    #
    # @raise [ArgumentError]
    #   The String is incorrectly padded or contains non-alphabet characters.
    #   Note: CR or LF are also rejected.
    #
    # @note
    #   This method complies with RFC 4648.
    #
    def strict_decode64(str)
      unless str.include?("\n")
        decode64(str)
      else
        raise(ArgumentError,"invalid base64")
      end
    end

    #
    # Encodes a URL-safe base64 String.
    #
    # @param [String] bin
    #   The String to encode.
    #
    # @return [String]
    #   The URL-safe encoded base64 String.
    #
    # @note
    #   This method complies with ``Base 64 Encoding with URL and filename Safe
    #   Alphabet'' in RFC 4648.
    #   The alphabet uses '-' instead of '+' and '_' instead of '/'.
    #
    def urlsafe_encode64(bin)
      strict_encode64(bin).tr("+/", "-_")
    end

    #
    # Decodes a URL-safe base64 encoded String.
    #
    # @param [String] str
    #   The URL-safe encoded base64 String.
    #
    # @return [String]
    #   The decoded String.
    #
    # @note
    #   This method complies with ``Base 64 Encoding with URL and filename Safe
    #   Alphabet'' in RFC 4648.
    #   The alphabet uses '-' instead of '+' and '_' instead of '/'.
    #
    def urlsafe_decode64(str)
      strict_decode64(str.tr("-_", "+/"))
    end
  end
end
