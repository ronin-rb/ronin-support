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

require 'ronin/support/binary/types/type'

module Ronin
  module Support
    module Binary
      module Types
        #
        # Base class for all aggregate types.
        #
        # @api private
        #
        # @since 1.0.0
        #
        class AggregateType < Type

          #
          # The size of the aggregate type.
          #
          # @abstract
          #
          def size
            raise(NotImplementedError,"#{self.class}##{__method__} was not implemented")
          end

          #
          # The number of elements within the aggregate type.
          #
          # @return [Integer, Float::INFINITY]
          #
          # @abstract
          #
          def length
            raise(NotImplementedError,"#{self.class}##{__method__} was not implemented")
          end

          #
          # Packs the value into the aggregate type's binary format.
          #
          # @param [Integer, Float, String] value
          #   The value to pack.
          #
          # @return [String]
          #   The packed binary data.
          #
          # @raise [NotImplementedError]
          #   {#pack_string} was not set.
          #
          # @api public
          #
          def pack(value)
            if @pack_string
              values = []
              enqueue_value(values,value)

              return values.pack(@pack_string)
            else
              raise(NotImplementedError,"#{self.class} does not define a #pack_string")
            end
          end

          #
          # Unpacks the binary data.
          #
          # @param [String] data
          #   The binary data to unpack.
          #
          # @return [Integer, Float, String, nil]
          #   The unpacked value.
          #
          # @raise [NotImplementedError]
          #   {#pack_string} was not set.
          #
          # @api public
          #
          def unpack(data)
            if @pack_string
              values = data.unpack(@pack_string)

              return dequeue_value(values)
            else
              raise(NotImplementedError,"#{self.class} does not define a #pack_string")
            end
          end

        end
      end
    end
  end
end
