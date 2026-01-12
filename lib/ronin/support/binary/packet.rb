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
      # Represents a network packet in network byte-order.
      #
      # ## Examples
      #
      # ### Defining Packet Fields
      #
      #     class Packet < Ronin::Support::Binary::Packet
      #
      #       member :flags,  :uint8
      #       member :src,    :uint32
      #       member :dst,    :uint32
      #       member :length, :uint32
      #
      #     end
      #
      # ### Initializing Packets
      #
      # From a Hash:
      #
      #     packet = Packet.new(
      #       flags:  0x0c,
      #       src:    IPAddr.new('1.2.3.4').to_i,
      #       dst:    IPAddr.new('5.6.7.8').to_i,
      #       length: 1024
      #     )
      #
      # From a buffer:
      #
      #     packet = Packet.unpack("\f\x01\x02\x03\x04\x05\x06\a\b\x00\x00\x04\x00")
      #
      # ### Reading Fields
      #
      #     packet = Packet.new("\f\x01\x02\x03\x04\x05\x06\a\b\x00\x00\x04\x00")
      #     packet[:flags]
      #     # => 12
      #     packet.flags
      #     # => 12
      #
      # ### Packing Packets
      #
      #     class Packet < Ronin::Support::Binary::Packet
      #
      #       member :flags,  :uint8
      #       member :src,    :uint32
      #       member :dst,    :uint32
      #       member :length, :uint32
      #
      #     end
      #
      #     packet = Packet.new(
      #       flags:  0x0c,
      #       src:    IPAddr.new('1.2.3.4').to_i,
      #       dst:    IPAddr.new('5.6.7.8').to_i,
      #       length: 1024
      #     )
      #     packet.pack
      #     # => "\f\x01\x02\x03\x04\x05\x06\a\b\x00\x00\x04\x00"
      #
      # ### Unpacking Packets
      #
      #     class Packet < Ronin::Support::Binary::Packet
      #
      #       member :flags,  :uint8
      #       member :src,    :uint32
      #       member :dst,    :uint32
      #       member :length, :uint32
      #
      #     end
      #
      #     packet = Packet.unpack("\f\x01\x02\x03\x04\x05\x06\a\b\x00\x00\x04\x00")
      #     packet.flags
      #     # => 12
      #     packet.src
      #     # => 16909060
      #     packet.dst
      #     # => 84281096
      #     packet.length
      #     # => 1024
      #
      class Packet < Binary::Struct

        platform endian: :net
        align 1
        padding false

      end
    end
  end
end
