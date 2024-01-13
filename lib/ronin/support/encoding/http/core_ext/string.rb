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

require 'ronin/support/encoding/http/core_ext/integer'

class String

  #
  # HTTP escapes the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase hexadecimal.
  #   Defaults to uppercase hexadecimal.
  #
  # @return [String]
  #   The HTTP escaped form of the String.
  #
  # @raise [ArgumentError]
  #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
  #
  # @example
  #   "x > y".http_escape
  #   # => "x+%3E+y"
  #
  # @example Lowercase encoding:
  #   "x > y".html_escape(case: :lower)
  #   # => "x+%3e+y"
  #
  # @see Ronin::Support::Encoding::HTTP.escape
  #
  # @api public
  #
  # @since 0.6.0
  #
  def http_escape(**kwargs)
    Ronin::Support::Encoding::HTTP.escape(self,**kwargs)
  end

  #
  # HTTP unescapes the String.
  #
  # @return [String]
  #   The raw String.
  #
  # @example
  #   "sweet+%26+sour".http_unescape
  #   # => "sweet & sour"
  #
  # @see Ronin::Support::Encoding::HTTP.unescape
  #
  # @api public
  #
  # @since 0.6.0
  #
  def http_unescape
    Ronin::Support::Encoding::HTTP.unescape(self)
  end

  #
  # HTTP encodes each byte of the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase hexadecimal.
  #   Defaults to uppercase hexadecimal.
  #
  # @return [String]
  #   The HTTP hexadecimal encoded form of the String.
  #
  # @raise [ArgumentError]
  #   The `case:` keyword argument was not `:lower`, `:upper`, or `nil`.
  #
  # @example
  #   "hello".http_encode
  #   # => "%68%65%6c%6c%6f"
  #
  # @example Lowercase encoding:
  #   "hello".http_encode(case: :lower)
  #   # => "%68%65%6c%6c%6f"
  #
  # @see Ronin::Support::Encoding::HTTP.encode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def http_encode(**kwargs)
    Ronin::Support::Encoding::HTTP.encode(self,**kwargs)
  end

  #
  # HTTP decodes the HTTP encoded String.
  #
  # @return [String]
  #   The decoded String.
  #
  # @example
  #   "sweet+%26+sour".http_decode
  #   # => "sweet & sour"
  #
  # @see Ronin::Support::Encoding::HTTP.decode
  #
  # @api public
  #
  def http_decode
    Ronin::Support::Encoding::HTTP.decode(self)
  end

end
