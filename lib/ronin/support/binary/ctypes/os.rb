# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Represents additional typedefs defined by an Operating System (OS).
        #
        # @api private
        #
        # @since 1.0.0
        #
        class OS

          # The base types that the OS inherits.
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
          #          OS::Windows,
          #          OS::Android,
          #          OS::AppleIOS]
          attr_reader :types

          # The defined typedefs for the OS.
          #
          # @return [Hash{Symbol => Type}]
          attr_reader :typedefs

          #
          # Initializes the OS with the given base types.
          #
          # @param [Native, LittleEndian, BigEndian, Network,
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
          #          OS::Windows,
          #          OS::Android] types
          #   The base types that the OS builds upon.
          #
          def initialize(types)
            @types    = types
            @typedefs = {}
          end

          #
          # Retrieves the type with the given name.
          #
          # @param [Symbol] name
          #
          # @return [Type]
          #
          # @api public
          #
          def [](name)
            @typedefs.fetch(name) { @types[name] }
          end

          #
          # Defines a typedef within the type system.
          #
          # @param [Symbol, Type] type
          #   The original type to point to.
          #
          # @param [Symbol] new_name
          #   The new type name.
          #
          # @raise [ArgumentError]
          #   The given type was not a Symbol or a {Type}.
          #
          # @example
          #   os.typedef :uint, :foo_t
          #
          def typedef(type,new_name)
            case type
            when Type   then @typedefs[new_name] = type
            when Symbol then @typedefs[new_name] = self[type]
            else
              raise(ArgumentError,"type must be either a Symbol or a #{Type}: #{type.inspect}")
            end
          end

        end
      end
    end
  end
end

require 'ronin/support/binary/ctypes/os/unix'
require 'ronin/support/binary/ctypes/os/linux'
require 'ronin/support/binary/ctypes/os/bsd'
require 'ronin/support/binary/ctypes/os/freebsd'
require 'ronin/support/binary/ctypes/os/openbsd'
require 'ronin/support/binary/ctypes/os/netbsd'
require 'ronin/support/binary/ctypes/os/macos'
require 'ronin/support/binary/ctypes/os/windows'
require 'ronin/support/binary/ctypes/os/android'
require 'ronin/support/binary/ctypes/os/apple_ios'
