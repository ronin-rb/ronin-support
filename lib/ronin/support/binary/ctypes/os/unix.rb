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

require 'ronin/support/binary/ctypes/os'

module Ronin
  module Support
    module Binary
      module CTypes
        class OS
          #
          # Common types shared by all UNIX `libc` implementations.
          #
          # @api private
          #
          # @since 1.0.0
          #
          class UNIX < OS
            #
            # Initializes the common UNIX `libc` typedefs.
            #
            # @param [#[]] types
            #   The base types module.
            #
            def initialize(types)
              super(types)

              typedef :char,  :__int8_t
              typedef :short, :__int16_t
              typedef :int,   :__int32_t

              typedef :uchar,  :__uint8_t
              typedef :ushort, :__uint16_t
              typedef :uint,   :__uint32_t

              typedef :char,  :int8_t
              typedef :short, :int16_t
              typedef :int,   :int32_t

              typedef :uchar,      :u_int8_t
              typedef :ushort,     :u_int16_t
              typedef :uint,       :u_int32_t
              typedef :ulong_long, :u_int64_t

              typedef :uchar,  :u_char
              typedef :uint,   :u_int
              typedef :ulong,  :u_long
              typedef :ushort, :u_short

              typedef :uint, :uid_t
              typedef :uint, :gid_t
              typedef :int,  :pid_t

              typedef :uint,   :in_addr_t
              typedef :ushort, :in_port_t
              typedef :uint,   :socklen_t
            end
          end
        end
      end
    end
  end
end
