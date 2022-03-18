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
          # Creates an Array type around the aggregate type.
          #
          # @param [Integer, nil] length
          #   The length of the Array.
          #
          # @return [ArrayType, UnboundedArrayType]
          #   The new Array type or an unbounded Array type if `length` was not
          #   given.
          #
          def [](length=nil)
            if length then ArrayType.new(self,length)
            else           UnboundedArrayType.new(self)
            end
          end

        end
      end
    end
  end
end

require 'ronin/support/binary/types/array_type'
require 'ronin/support/binary/types/unbounded_array_type'
