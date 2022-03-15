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

require 'ronin/support/binary/types/arch/x86'
require 'ronin/support/binary/types/arch/x86_64'
require 'ronin/support/binary/types/arch/ppc'
require 'ronin/support/binary/types/arch/ppc64'
require 'ronin/support/binary/types/arch/mips'
require 'ronin/support/binary/types/arch/mips/little_endian'
require 'ronin/support/binary/types/arch/mips64'
require 'ronin/support/binary/types/arch/mips64/little_endian'
require 'ronin/support/binary/types/arch/arm'
require 'ronin/support/binary/types/arch/arm/big_endian'
require 'ronin/support/binary/types/arch/arm64'
require 'ronin/support/binary/types/arch/arm64/big_endian'

module Ronin
  module Support
    module Binary
      module Types
        module Arch
          # The supported architectures.
          ARCHES = {
            x86: X86,

            x86_64: X86_64,
            ia64:   X86_64,
            amd64:  X86_64,

            ppc:   PPC,
            ppc64: PPC64,

            mips:    MIPS,
            mips_le: MIPS::LittleEndian,
            mips_be: MIPS, # MIPS is big-endian by default

            mips64:    MIPS64,
            mips64_le: MIPS64::LittleEndian,
            mips64_be: MIPS64, # MIPS is big-endian by default

            arm:      ARM,
            arm_le:   ARM,
            arm_be:   ARM::BigEndian,

            arm64:    ARM64,
            arm64_le: ARM64, # ARM is little-endian by default
            arm64_be: ARM64::BigEndian
          }

          #
          # Fetches the arch from {ARCHES}.
          #
          # @param [:x86, :x86_64,
          #         :ppc, :ppc64,
          #         :mips, :mips_le, :mips_be,
          #         :mips64, :mips64_le, :mips64_be,
          #         :arm, :arm_le, :arm_be,
          #         :arm64, :arm64_le, :arm64_be] name
          #   The architecture name to lookup.
          #
          # @return [Module]
          #   The arch module from {ARCHES}.
          #
          # @raise [ArgumentError]
          #   The architecture name was unknown.
          #
          def self.[](name)
            ARCHES.fetch(name) do
              raise(ArgumentError,"unknown arch: #{name.inspect}")
            end
          end
        end
      end
    end
  end
end
