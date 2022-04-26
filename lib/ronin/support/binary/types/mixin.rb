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

require 'ronin/support/binary/types'
require 'ronin/support/binary/types/resolver'

module Ronin
  module Support
    module Binary
      module Types
        #
        # Adds a type system that can be used by {Memory} objects.
        #
        # @api semipublic
        #
        module Mixin
          # The endianness of the binary format.
          #
          # @return [:little, :big, :net, nil]
          #
          # @api public
          attr_reader :endian

          # The desired architecture of the binary format.
          #
          # @return [:x86, :x86_64, :ppc, :ppc64, :arm, :arm_be, :arm64,
          #          :arm64_be, :mips, :mips_le, :mips64, :mips64_le, nil]
          #
          # @api public
          attr_reader :arch

          # The type system module or object to lookup type names in.
          #
          # @return [#[]]
          #
          # @api semipublic
          attr_reader :type_system

          # The type resolver.
          #
          # @return [Resolver]
          #
          # @api semipublic
          attr_reader :type_resolver

          protected

          #
          # Initializes the type system.
          #
          # @param [#[]] types
          #   The type system.
          #
          # @param [:little, :big, :net, nil] endian
          #   The desired endianness of the binary format.
          #
          # @param [:x86, :x86_64,
          #         :ppc, :ppc64,
          #         :mips, :mips_le, :mips_be,
          #         :mips64, :mips64_le, :mips64_be,
          #         :arm, :arm_le, :arm_be,
          #         :arm64, :arm64_le, :arm64_be] arch
          #   The desired architecture of the binary format.
          #
          def initialize_type_system(types=nil, endian: nil, arch: nil)
            @endian = endian
            @arch   = arch

            @type_system = if    types  then types
                           elsif arch   then Types.arch(arch)
                           elsif endian then Types.endian(endian)
                           else              Types
                           end
            @type_resolver = Types::Resolver.new(@type_system)
          end
        end
      end
    end
  end
end
