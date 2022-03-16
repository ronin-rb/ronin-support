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

require 'ronin/support/binary/types/little_endian'

module Ronin
  module Support
    module Binary
      module Types
        module Arch
          module X86_64
            include LittleEndian

            # The size of a pointer in bytes on x86-64.
            ADDRESS_SIZE = 8

            # The x86-64 types.
            TYPES = LittleEndian::TYPES.merge(
              long:  LittleEndian::Int64,
              ulong: LittleEndian::UInt64
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
              self::TYPES.fetch(name) do
                raise(ArgumentError,"unknown x86-64 type: #{name.inspect}")
              end
            end
          end
        end
      end
    end
  end
end
