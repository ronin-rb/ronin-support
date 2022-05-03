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

require 'ronin/support/binary/types/os'

module Ronin
  module Support
    module Binary
      module Types
        class OS
          #
          # Contains additional types available on NetBSD.
          #
          # @api semipublic
          #
          # @since 1.0.0
          #
          class NetBSD < OS

            #
            # Initializes the NetBSD types object.
            #
            # @param [#[]] types
            #   The base types module.
            #
            def initialize(types)
              super(types)

              typedef :string, :caddr_t
              typedef :int, :__clockid_t
              typedef :int, :clockid_t
              typedef :int, :__clock_t
              typedef :int, :clock_t
              typedef :ulong, :__cpuid_t
              typedef :ulong, :cpuid_t
              typedef :int, :daddr32_t
              typedef :long_long, :daddr64_t
              typedef :int, :daddr_t
              typedef :int, :__dev_t
              typedef :int, :dev_t
              typedef :int, :__fd_mask
              typedef :uint, :__fixpt_t
              typedef :uint, :fixpt_t
              typedef :uint, :__gid_t
              typedef :uint, :gid_t
              typedef :uint, :__id_t
              typedef :uint, :id_t
              typedef :uint, :__in_addr_t
              typedef :uint, :in_addr_t
              typedef :uint, :__ino_t
              typedef :uint, :ino_t
              typedef :ushort, :__in_port_t
              typedef :ushort, :in_port_t
              typedef :short, :__int16_t
              typedef :short, :int16_t
              typedef :int, :__int32_t
              typedef :int, :int32_t
              typedef :long_long, :__int64_t
              typedef :long_long, :int64_t
              typedef :char, :__int8_t
              typedef :char, :int8_t
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
              typedef :long_long, :off_t
              typedef :ulong, :__paddr_t
              typedef :ulong, :paddr_t
              typedef :int, :__pid_t
              typedef :int, :pid_t
              typedef :ulong, :__psize_t
              typedef :ulong, :psize_t
              typedef :long, :__ptrdiff_t
              typedef :pointer, :qaddr_t
              typedef :long_long, :quad_t
              typedef :int, :__register_t
              typedef :int, :register_t
              typedef :ulong_long, :__rlim_t
              typedef :ulong_long, :rlim_t
              typedef :int, :__rune_t
              typedef :uchar, :__sa_family_t
              typedef :uchar, :sa_family_t
              typedef :int, :__segsz_t
              typedef :int, :segsz_t
              typedef :ulong, :__size_t
              typedef :ulong, :size_t
              typedef :uint, :__socklen_t
              typedef :uint, :socklen_t
              typedef :long, :__ssize_t
              typedef :long, :ssize_t
              typedef :int, :__suseconds_t
              typedef :int, :suseconds_t
              typedef :int, :__swblk_t
              typedef :int, :swblk_t
              typedef :int, :__timer_t
              typedef :int, :timer_t
              typedef :int, :__time_t
              typedef :int, :time_t
              typedef :uchar, :u_char
              typedef :uint, :__uid_t
              typedef :uint, :uid_t
              typedef :ushort, :__uint16_t
              typedef :ushort, :u_int16_t
              typedef :ushort, :uint16_t
              typedef :uint, :__uint32_t
              typedef :uint, :u_int32_t
              typedef :uint, :uint32_t
              typedef :ulong_long, :__uint64_t
              typedef :ulong_long, :u_int64_t
              typedef :ulong_long, :uint64_t
              typedef :uchar, :__uint8_t
              typedef :uchar, :u_int8_t
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
              typedef :uint, :u_int
              typedef :uint, :uint
              typedef :ulong, :u_long
              typedef :ulong, :ulong
              typedef :uchar, :unchar
              typedef :ulong_long, :u_quad_t
              typedef :uint, :__useconds_t
              typedef :uint, :useconds_t
              typedef :ushort, :u_short
              typedef :ushort, :ushort
              typedef :ulong, :__vaddr_t
              typedef :ulong, :vaddr_t
              typedef :ulong, :__vsize_t
              typedef :ulong, :vsize_t
              typedef :int, :__wchar_t
              typedef :pointer, :__wctrans_t
              typedef :pointer, :__wctype_t
              typedef :int, :__wint_t

              if types::ADDRESS_SIZE == 8
                typedef :long, :intptr_t
                typedef :ulong, :uintptr_t
              end
            end

          end
        end
      end
    end
  end
end
