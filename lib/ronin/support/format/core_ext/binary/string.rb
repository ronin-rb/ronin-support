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

require 'ronin/support/format/core_ext/binary/integer'
require 'ronin/support/format/core_ext/text/string'

require 'base64'

begin
  require 'zlib'
rescue ::LoadError
  warn "WARNING: Ruby was not compiled with zlib support"
end

class String

  #
  # Hex-encodes characters in the String.
  #
  # @return [String]
  #   The hex encoded version of the String.
  #
  # @example
  #   "hello".hex_encode
  #   # => "68656C6C6F"
  #
  # @since 0.6.0
  #
  def hex_encode
    format_bytes { |b| b.hex_encode }
  end

  #
  # Hex-decodes the String.
  #
  # @return [String]
  #   The hex decoded version of the String.
  #
  # @example
  #   "68656C6C6F".hex_decode
  #   # => "hello"
  #
  def hex_decode
    scan(/../).map { |hex| hex.to_i(16).chr }.join
  end

  #
  # Hex-escapes characters in the String.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {#format_bytes}.
  #
  # @return [String]
  #   The hex escaped version of the String.
  #
  # @example
  #   "hello".hex_escape
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
  #
  # @see String#format_bytes
  #
  # @api public
  #
  def hex_escape(**kwargs)
    format_bytes(**kwargs) { |b| b.hex_escape }
  end

  alias hex_unescape unescape

  #
  # XOR encodes the String.
  #
  # @param [Enumerable, Integer] key
  #   The byte to XOR against each byte in the String.
  #
  # @return [String]
  #   The XOR encoded String.
  #
  # @example
  #   "hello".xor(0x41)
  #   # => ")$--."
  #
  # @example
  #   "hello again".xor([0x55, 0x41, 0xe1])
  #   # => "=$\x8d9.\xc14&\x80</"
  #
  # @api public
  #
  def xor(key)
    key = case key
          when Integer then [key]
          when String  then key.bytes
          else              key
          end

    key    = key.cycle
    result = ''

    bytes.each do |b|
      result << (b ^ key.next).chr
    end

    return result
  end

  alias ^ xor

  #
  # Base64 encodes a string.
  #
  # @param [Symbol, nil] mode
  #   The base64 mode to use. May be either:
  #
  #   * `:normal`
  #   * `:strict`
  #   * `:url` / `:urlsafe`
  #
  # @return [String]
  #   The base64 encoded form of the string.
  #
  # @example
  #   "hello".base64_encode
  #   # => "aGVsbG8=\n"
  #
  # @api public
  #
  def base64_encode(mode=nil)
    case mode
    when :strict        then Base64.strict_encode64(self)
    when :url, :urlsafe then Base64.urlsafe_encode64(self)
    else                     Base64.encode64(self)
    end
  end

  #
  # Base64 decodes a string.
  #
  # @param [Symbol, nil] mode
  #   The base64 mode to use. May be either:
  #
  #   * `nil`
  #   * `:strict`
  #   * `:url` / `:urlsafe`
  #
  # @return [String]
  #   The base64 decoded form of the string.
  #
  # @note
  #   `mode` argument is only available on Ruby >= 1.9.
  #
  # @example
  #   "aGVsbG8=\n".base64_decode
  #   # => "hello"
  #
  # @api public
  #
  def base64_decode(mode=nil)
    case mode
    when :strict        then Base64.strict_decode64(self)
    when :url, :urlsafe then Base64.urlsafe_decode64(self)
    else                     Base64.decode64(self)
    end
  end

  #
  # Zlib inflate a string.
  #
  # @return [String]
  #   The Zlib inflated form of the string.
  #
  # @example
  #   "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15".zlib_inflate
  #   # => "hello"
  #
  # @api public
  #
  def zlib_inflate
    Zlib::Inflate.inflate(self)
  end

  #
  # Zlib deflate a string.
  #
  # @return [String]
  #   The Zlib deflated form of the string.
  #
  # @example
  #   "hello".zlib_deflate
  #   # => "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15"
  #
  # @api public
  #
  def zlib_deflate
    Zlib::Deflate.deflate(self)
  end

end
