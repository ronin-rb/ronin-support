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

require 'ronin/support/binary/ctypes/os/bsd'

module Ronin
  module Support
    module Binary
      module CTypes
        class OS
          #
          # Contains additional types available on OpenBSD.
          #
          # @api semipublic
          #
          # @since 1.0.0
          #
          class OpenBSD < BSD

            #
            # Initializes the OpenBSD types object.
            #
            # @param [#[]] types
            #   The base types module.
            #
            def initialize(types)
              super(types)

              typedef :int, :__clockid_t
              typedef :int, :clockid_t
              typedef :ulong, :__cpuid_t
              typedef :ulong, :cpuid_t
              typedef :int, :daddr32_t
              typedef :int, :__dev_t
              typedef :int, :dev_t
              typedef :uint, :__fixpt_t
              typedef :uint, :__gid_t
              typedef :uint, :__id_t
              typedef :uint, :id_t
              typedef :uint, :__in_addr_t
              typedef :ushort, :__in_port_t
              typedef :ushort, :in_port_t
              typedef :int, :__int_fast16_t
              typedef :int, :__int_fast32_t
              typedef :long_long, :__int_fast64_t
              typedef :int, :__int_fast8_t
              typedef :short, :__int_least16_t
              typedef :int, :__int_least32_t
              typedef :long_long, :__int_least64_t
              typedef :char, :__int_least8_t
              typedef :long_long, :__intmax_t
              typedef :long, :__intptr_t
              typedef :long, :__key_t
              typedef :long, :key_t
              typedef :uint, :__mode_t
              typedef :uint, :mode_t
              typedef :uint, :__nlink_t
              typedef :uint, :nlink_t
              typedef :long_long, :__off_t
              typedef :ulong, :__paddr_t
              typedef :ulong, :paddr_t
              typedef :int, :__pid_t
              typedef :ulong, :__psize_t
              typedef :ulong, :psize_t
              typedef :long, :__ptrdiff_t
              typedef :ulong_long, :__rlim_t
              typedef :ulong_long, :rlim_t
              typedef :int, :__rune_t
              typedef :uchar, :__sa_family_t
              typedef :int, :__segsz_t
              typedef :ulong, :__size_t
              typedef :ulong, :size_t
              typedef :uint, :__socklen_t
              typedef :long, :__ssize_t
              typedef :long, :ssize_t
              typedef :int, :__swblk_t
              typedef :int, :swblk_t
              typedef :int, :__timer_t
              typedef :int, :timer_t
              typedef :uint, :__uid_t
              typedef :ushort, :uint16_t
              typedef :uint, :uint32_t
              typedef :ulong_long, :uint64_t
              typedef :uchar, :uint8_t
              typedef :uint, :__uint_fast16_t
              typedef :uint, :__uint_fast32_t
              typedef :ulong_long, :__uint_fast64_t
              typedef :uint, :__uint_fast8_t
              typedef :ushort, :__uint_least16_t
              typedef :uint, :__uint_least32_t
              typedef :ulong_long, :__uint_least64_t
              typedef :uchar, :__uint_least8_t
              typedef :ulong_long, :__uintmax_t
              typedef :ulong, :__uintptr_t
              typedef :ulong, :ulong
              typedef :uchar, :unchar
              typedef :uint, :__useconds_t
              typedef :ulong, :__vaddr_t
              typedef :ulong, :vaddr_t
              typedef :ulong, :__vsize_t
              typedef :ulong, :vsize_t
              typedef :int, :__wchar_t
              typedef :pointer, :__wctrans_t
              typedef :pointer, :__wctype_t
              typedef :int, :__wint_t

              if types::ADDRESS_SIZE == 8
                typedef :long_long, :__blkcnt_t
                typedef :long_long, :blkcnt_t
                typedef :int, :__blksize_t
                typedef :int, :blksize_t
                typedef :long_long, :__clock_t
                typedef :long_long, :clock_t
                typedef :long_long, :daddr_t
                typedef :uint, :__fd_mask
                typedef :ulong_long, :__fsblkcnt_t
                typedef :ulong_long, :fsblkcnt_t
                typedef :ulong_long, :__fsfilcnt_t
                typedef :ulong_long, :fsfilcnt_t
                typedef :ulong_long, :__ino_t
                typedef :ulong_long, :ino_t
                typedef :long, :__register_t
                typedef :long, :register_t
                typedef :uint, :sigset_t
                typedef :long, :__suseconds_t
                typedef :long, :suseconds_t
                typedef :long_long, :__time_t
                typedef :long_long, :time_t
              else
                typedef :int, :__clock_t
                typedef :int, :clock_t
                typedef :long_long, :daddr64_t
                typedef :int, :daddr_t
                typedef :int, :__fd_mask
                typedef :uint, :__ino_t
                typedef :uint, :ino_t
                typedef :long, :intptr_t
                typedef :int, :__register_t
                typedef :int, :register_t
                typedef :int, :__suseconds_t
                typedef :int, :suseconds_t
                typedef :int, :__time_t
                typedef :int, :time_t
                typedef :ulong, :uintptr_t
              end
            end

          end
        end
      end
    end
  end
end
