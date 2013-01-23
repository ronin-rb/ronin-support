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

require 'ronin/formatting/extensions/binary/integer'
require 'ronin/formatting/extensions/text/string'
require 'ronin/binary/hexdump/parser'
require 'ronin/binary/template'

require 'base64'

begin
  require 'zlib'
rescue ::LoadError
  warn "WARNING: Ruby was not compiled with zlib support"
end

class String

  alias unpack_original unpack

  #
  # Unpacks the String.
  #
  # @param [String, Array<Symbol, (Symbol, Integer)>] arguments
  #   The `String#unpack` template or a list of {Ronin::Binary::Template} types.
  #
  # @return [Array]
  #   The values unpacked from the String.
  #
  # @raise [ArgumentError]
  #   One of the arguments was not a known {Ronin::Binary::Template} type.
  #
  # @example using {Ronin::Binary::Template} types:
  #   "A\0\0\0hello\0".unpack(:uint32_le, :string)
  #   # => [10, "hello"]
  #
  # @example using a `String#unpack` template:
  #   "A\0\0\0".unpack('V')
  #   # => 65
  #
  # @see http://rubydoc.info/stdlib/core/String:unpack
  # @see Ronin::Binary::Template
  #
  # @since 0.5.0
  #
  # @api public
  #
  def unpack(*arguments)
    if (arguments.length == 1 && arguments.first.kind_of?(String))
      unpack_original(arguments.first)
    else
      unpack_original(Ronin::Binary::Template.compile(arguments))
    end
  end

  #
  # Hex-escapes characters in the String.
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
  def hex_escape(options={})
    format_bytes(options) { |b| b.hex_escape }
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

  #
  # Converts a multitude of hexdump formats back into raw-data.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Symbol] :format
  #   The expected format of the hexdump. Must be either `:od` or
  #   `:hexdump`.
  #
  # @option options [Symbol] :encoding
  #   Denotes the encoding used for the bytes within the hexdump.
  #   Must be one of the following:
  #
  #   * `:binary`
  #   * `:octal`
  #   * `:octal_bytes`
  #   * `:octal_shorts`
  #   * `:octal_ints`
  #   * `:octal_quads` (Ruby 1.9 only)
  #   * `:decimal`
  #   * `:decimal_bytes`
  #   * `:decimal_shorts`
  #   * `:decimal_ints`
  #   * `:decimal_quads` (Ruby 1.9 only)
  #   * `:hex`
  #   * `:hex_chars`
  #   * `:hex_bytes`
  #   * `:hex_shorts`
  #   * `:hex_ints`
  #   * `:hex_quads`
  #   * `:named_chars` (Ruby 1.9 only)
  #   * `:floats`
  #   * `:doubles`
  #
  # @option options [:little, :big, :network] :endian (:little)
  #   The endianness of the words.
  #
  # @option options [Integer] :segment (16)
  #   The length in bytes of each segment in the hexdump.
  #
  # @return [String]
  #   The raw-data from the hexdump.
  #
  # @api public
  #
  def unhexdump(options={})
    Ronin::Binary::Hexdump::Parser.new(options).parse(self)
  end

end
