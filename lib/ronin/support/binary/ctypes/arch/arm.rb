# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes/little_endian'

module Ronin
  module Support
    module Binary
      module CTypes
        module Arch
          #
          # Represents the C types for the ARM architecture.
          #
          module ARM
            include LittleEndian

            # The size of a pointer in bytes on ARM.
            ADDRESS_SIZE = 4

            # The `long` type.
            LONG = LittleEndian::INT32

            # The `unsigned long` type.
            ULONG = LittleEndian::UINT32

            # The "machine word" type.
            MACHINE_WORD = LittleEndian::UINT32

            # The `void *` type.
            POINTER = MACHINE_WORD

            # The ARM types.
            TYPES = LittleEndian::TYPES.merge(
              long:  self::LONG,
              ulong: self::ULONG,

              machine_word: self::MACHINE_WORD,
              pointer:      self::POINTER
            )

            #
            # Fetches the type from {TYPES}.
            #
            # @param [Symbol] name
            #   The type name to lookup.
            #
            # @return [Type]
            #   The type object from {TYPES}.
            #
            # @raise [ArgumentError]
            #   The type name was unknown.
            #
            def self.[](name)
              TYPES.fetch(name) do
                raise(ArgumentError,"unknown ARM type: #{name.inspect}")
              end
            end
          end
        end
      end
    end
  end
end
