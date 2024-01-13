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

require 'ronin/support/encoding/http'

class Integer

  #
  # Encodes the byte as an escaped HTTP decimal character.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase hexadecimal.
  #   Defaults to uppercase hexadecimal.
  #
  # @return [String]
  #   The encoded HTTP byte.
  #
  # @raise [ArgumentError]
  #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
  #
  # @raise [RangeError]
  #   The byte value is negative or greater than 255.
  #
  # @example
  #   0x41.http_encode
  #   # => "%41"
  #
  # @example Lowercase encoding:
  #   0xff.http_encode(case: :lower)
  #   # => "%ff"
  #
  # @see Ronin::Support::Encoding::HTTP.encode_byte
  #
  # @api public
  #
  def http_encode(**kwargs)
    Ronin::Support::Encoding::HTTP.encode_byte(self,**kwargs)
  end

  #
  # HTTP escapes the Integer.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase hexadecimal.
  #   Defaults to uppercase hexadecimal.
  #
  # @return [String]
  #   The HTTP escaped form of the Integer.
  #
  # @raise [ArgumentError]
  #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
  #
  # @raise [RangeError]
  #   The byte value is negative or greater than 255.
  #
  # @example
  #   62.http_escape
  #   # => "%3E"
  #
  # @example Lowercase encoding:
  #   0xff.http_escape(case: :lower)
  #   # => "%ff"
  #
  # @see Ronin::Support::Encoding::HTTP.escape_byte
  #
  # @api public
  #
  # @since 0.6.0
  #
  def http_escape(**kwargs)
    Ronin::Support::Encoding::HTTP.escape_byte(self,**kwargs)
  end

end
