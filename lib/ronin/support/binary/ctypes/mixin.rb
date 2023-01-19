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

require 'ronin/support/binary/ctypes'

module Ronin
  module Support
    module Binary
      module CTypes
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

          # The desired Operating System (OS) of the binary format.
          #
          # @return [:linux, :macos, :windows,
          #          :bsd, :freebsd, :openbsd, :netbsd, nil]
          #
          # @api public
          attr_reader :os

          # The type system module or object to lookup type names in.
          #
          # @return [Native, LittleEndian, BigEndian, Network,
          #          Arch::ARM, Arch::ARM::BigEndian,
          #          Arch::ARM64, Arch::ARM64::BigEndian,
          #          Arch::MIPS, Arch::MIPS::LittleEndian,
          #          Arch::MIPS64, Arch::MIPS64::LittleEndian,
          #          Arch::PPC64, Arch::PPC, Arch::X86_64, Arch::X86,
          #          OS::FreeBSD,
          #          OS::NetBSD,
          #          OS::OpenBSD,
          #          OS::Linux,
          #          OS::MacOS,
          #          OS::Windows]
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
          # @param [Native, LittleEndian, BigEndian, Network,
          #         Arch::ARM, Arch::ARM::BigEndian,
          #         Arch::ARM64, Arch::ARM64::BigEndian,
          #         Arch::MIPS, Arch::MIPS::LittleEndian,
          #         Arch::MIPS64, Arch::MIPS64::LittleEndian,
          #         Arch::PPC64, Arch::PPC, Arch::X86_64, Arch::X86,
          #         OS::FreeBSD,
          #         OS::NetBSD,
          #         OS::OpenBSD,
          #         OS::Linux,
          #         OS::MacOS,
          #         OS::Windows, nil] type_system
          #   Optional type system to use instead.
          #
          # @param [:little, :big, :net, nil] endian
          #   The desired endianness to use.
          #
          # @param [:x86, :x86_64,
          #         :ppc, :ppc64,
          #         :mips, :mips_le, :mips_be,
          #         :mips64, :mips64_le, :mips64_be,
          #         :arm, :arm_le, :arm_be,
          #         :arm64, :arm64_le, :arm64_be] arch
          #   The desired architecture to use.
          #
          # @param [:linux, :macos, :windows,
          #         :bsd, :freebsd, :openbsd, :netbsd] os
          #   The Operating System (OS) to use.
          #
          def initialize_type_system(type_system: nil,
                                     endian:      nil,
                                     arch:        nil,
                                     os:          nil)
            @endian = endian
            @arch   = arch
            @os     = os

            @type_system = type_system || CTypes.platform(
                                            endian: endian,
                                            arch:   arch,
                                            os:     os
                                          )

            @type_resolver = CTypes::TypeResolver.new(@type_system)
          end
        end
      end
    end
  end
end

require 'ronin/support/binary/ctypes/type_resolver'
