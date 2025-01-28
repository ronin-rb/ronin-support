# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes/os/unix'

module Ronin
  module Support
    module Binary
      module CTypes
        class OS
          #
          # Contains additional types available on GNU/Linux.
          #
          # @api semipublic
          #
          # @since 1.0.0
          #
          class Linux < UNIX

            #
            # Initializes the GNU/Linux types object.
            #
            # @param [#[]] types
            #   The base types module.
            #
            def initialize(types)
              super(types)

              typedef :long, :__blkcnt_t
              typedef :long, :__blksize_t
              typedef :long, :blksize_t
              typedef :pointer, :__caddr_t
              typedef :int, :__clockid_t
              typedef :int, :clockid_t
              typedef :long, :__clock_t
              typedef :int, :__daddr_t
              typedef :int, :daddr_t
              typedef :long, :__fd_mask
              typedef :long, :fd_mask
              typedef :ulong, :__fsblkcnt_t
              typedef :ulong, :__fsfilcnt_t
              typedef :uint, :__gid_t
              typedef :uint, :__id_t
              typedef :uint, :id_t
              typedef :ulong, :__ino_t
              typedef :int, :__key_t
              typedef :int, :key_t
              typedef :uint, :__mode_t
              typedef :uint, :mode_t
              typedef :long, :__off_t
              typedef :int, :__pid_t
              typedef :int, :__priority_which_t
              typedef :uint, :pthread_key_t
              typedef :int, :pthread_once_t
              typedef :ulong, :pthread_t
              typedef :long, :register_t
              typedef :int, :__rlimit_resource_t
              typedef :ulong, :__rlim_t
              typedef :int, :__rusage_who_t
              typedef :ushort, :sa_family_t
              typedef :int, :__sig_atomic_t
              typedef :uint, :__socklen_t
              typedef :long, :__suseconds_t
              typedef :long, :suseconds_t
              typedef :pointer, :__timer_t
              typedef :pointer, :timer_t
              typedef :long, :__time_t
              typedef :long, :time_t
              typedef :uchar, :__u_char
              typedef :uint, :__uid_t
              typedef :uint, :uid_t
              typedef :uint, :__u_int
              typedef :ulong, :__u_long
              typedef :uint, :__useconds_t
              typedef :ushort, :__u_short

              if types::ADDRESS_SIZE == 8
                typedef :long, :__blkcnt64_t
                typedef :long, :blkcnt_t
                typedef :long, :clock_t
                typedef :ulong, :__dev_t
                typedef :ulong, :dev_t
                typedef :ulong, :__fsblkcnt64_t
                typedef :ulong, :fsblkcnt_t
                typedef :ulong, :__fsfilcnt64_t
                typedef :ulong, :fsfilcnt_t
                typedef :long, :__fsword_t
                typedef :ulong, :__ino64_t
                typedef :ulong, :ino_t
                typedef :long, :__int64_t
                typedef :long, :int64_t
                typedef :long, :int_fast16_t
                typedef :long, :int_fast32_t
                typedef :long, :int_fast64_t
                typedef :char, :int_fast8_t
                typedef :int, :int_least32_t
                typedef :long, :int_least64_t
                typedef :char, :int_least8_t
                typedef :long, :__intmax_t
                typedef :long, :intmax_t
                typedef :long, :__intptr_t
                typedef :long, :intptr_t
                typedef :long, :__loff_t
                typedef :long, :loff_t
                typedef :ulong, :__nlink_t
                typedef :ulong, :nlink_t
                typedef :long, :__off64_t
                typedef :long, :off_t
                typedef :long, :ptrdiff_t
                typedef :long, :__quad_t
                typedef :long, :quad_t
                typedef :ulong, :__rlim64_t
                typedef :ulong, :rlim_t
                typedef :ulong, :size_t
                typedef :long, :__ssize_t
                typedef :long, :ssize_t
                typedef :long, :__syscall_slong_t
                typedef :ulong, :__syscall_ulong_t
                typedef :ushort, :uint16_t
                typedef :uint, :uint32_t
                typedef :ulong, :__uint64_t
                typedef :ulong, :uint64_t
                typedef :uchar, :uint8_t
                typedef :ulong, :uint_fast16_t
                typedef :ulong, :uint_fast32_t
                typedef :ulong, :uint_fast64_t
                typedef :uchar, :uint_fast8_t
                typedef :ushort, :uint_least16_t
                typedef :uint, :uint_least32_t
                typedef :ulong, :uint_least64_t
                typedef :uchar, :uint_least8_t
                typedef :ulong, :__uintmax_t
                typedef :ulong, :uintmax_t
                typedef :ulong, :uintptr_t
                typedef :ulong, :__u_quad_t
                typedef :ulong, :u_quad_t
                typedef :int, :wchar_t
              else
                typedef :long_long, :__blkcnt64_t
                typedef :long_long, :blkcnt_t
                typedef :ulong_long, :__dev_t
                typedef :ulong_long, :dev_t
                typedef :ulong_long, :__fsblkcnt64_t
                typedef :ulong_long, :fsblkcnt_t
                typedef :ulong_long, :__fsfilcnt64_t
                typedef :ulong_long, :fsfilcnt_t
                typedef :ulong_long, :__ino64_t
                typedef :ulong_long, :ino_t
                typedef :long_long, :__int64_t
                typedef :long_long, :int64_t
                typedef :int, :__intptr_t
                typedef :long_long, :__loff_t
                typedef :long_long, :loff_t
                typedef :uint, :__nlink_t
                typedef :uint, :nlink_t
                typedef :long_long, :__off64_t
                typedef :long_long, :off_t
                typedef :pointer, :__qaddr_t
                typedef :long_long, :__quad_t
                typedef :long_long, :quad_t
                typedef :ulong_long, :__rlim64_t
                typedef :ulong_long, :rlim_t
                typedef :uint, :size_t
                typedef :int, :__ssize_t
                typedef :int, :ssize_t
                typedef :long, :__swblk_t
                typedef :ulong_long, :__uint64_t
                typedef :ulong_long, :__u_quad_t
                typedef :ulong_long, :u_quad_t
              end
            end

          end
        end
      end
    end
  end
end
