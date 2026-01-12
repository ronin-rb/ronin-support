# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/struct'

module Ronin
  module Support
    module Binary
      #
      # Generic Binary Union class.
      #
      # @note This class provides lazy memory mapped access to an underlying
      # buffer. This means values are decoded/encoded each time they are read
      # or written to.
      #
      # ## Examples
      #
      # ### Defining Fields
      #
      #     class MyUnion < Ronin::Support::Binary::Union
      #
      #       member :c, :char
      #       member :i, :int16
      #       member :u, :uint32
      #
      #     end
      #
      # ### Initializing Fields
      #
      #     union   = MyUnion.new
      #     union.i = -1
      #
      #     union = MyUnion.new(i: -1)
      #
      # ### Inheriting Unions
      #
      #     class MyUnion < Ronin::Support::Binary::Union
      #
      #       member :c, :char
      #       member :i, :int16
      #       member :u, :uint32
      #
      #     end
      #
      #     class MyUnion2 < MyUnion
      #
      #       member :f, :float32
      #       member :d, :float64
      #
      #     end
      #
      #     union   = MyUnion.new
      #     union.i = -1
      #
      #     union2   = MyUnion.new
      #     union2.i = -1
      #     union2.d = 1.123
      #
      # ### Packing Unions
      #
      #     class MyUnion < Ronin::Support::Binary::Union
      #
      #       member :c, :char
      #       member :i, :int16
      #       member :u, :uint32
      #
      #     end
      #
      #     union = MyUnion.new
      #     union.u = 0x11111111
      #     union.i = -1
      #     union.pack
      #     # => "\xFF\xFF\x11\x11"
      #
      # ### Unpacking Unions
      #
      #     class MyUnion < Ronin::Support::Binary::Union
      #
      #       member :c, :char
      #       member :i, :int32
      #       member :u, :uint32
      #
      #     end
      #
      #     union = MyUnion.unpack("\xFF\xFF\x11\x11")
      #     union.c
      #     # => "\xFF"
      #     union.i
      #     # => -1
      #     union.u
      #     # => 286392319
      #
      # ### Array Fields
      #
      #     class MyUnion < Ronin::Support::Binary::Union
      #
      #       member :c, :char
      #       member :i, :int16
      #       member :u, :uint32
      #       member :nums, [:uint8, 10]
      #
      #     end
      #
      #     union = MyUnion.new
      #     union.nums = [0x01, 0x02, 0x03, 0x04]
      #     union.pack
      #     # => "\x01\x02\x03\x04\x00\x00\x00\x00\x00\x00"
      #
      # ### Unbounded Array Fields
      #
      #     class MyUnion < Ronin::Support::Binary::Union
      #
      #       member :c, :char
      #       member :i, :int16
      #       member :u, :uint32
      #       member :payload, (:uint8..)
      #
      #     end
      #
      #     union = MyUnion.new
      #     union.payload = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
      #     union.pack
      #     # => "\x01\x02\x03\x04\x05\x06\a\b"
      #
      # ### Default Endianness
      #
      #     class MyUnion < Ronin::Support::Binary::Union
      #
      #       endian :big
      #
      #       member :c, :char
      #       member :i, :int32
      #       member :u, :uint32
      #
      #     end
      #
      #     union = MyUnion.new(u: 0xaabbccdd)
      #     union.pack
      #     # => "\xAA\xBB\xCC\xDD"
      #
      # @api public
      #
      class Union < Struct
      end
    end
  end
end
