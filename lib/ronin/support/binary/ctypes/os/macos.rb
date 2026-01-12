# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/support/binary/ctypes/array_type'

module Ronin
  module Support
    module Binary
      module CTypes
        class OS
          #
          # Contains additional types available on macOS (aka Darwin).
          #
          # @api semipublic
          #
          # @since 1.0.0
          #
          class MacOS < BSD

            #
            # Initializes the macOS types object.
            #
            # @param [#[]] types
            #   The base types module.
            #
            def initialize(types)
              super(types)

              typedef :long_long, :blkcnt_t
              typedef :int, :blksize_t
              typedef :ulong, :clock_t
              typedef :int, :daddr_t
              typedef :long_long, :__darwin_blkcnt_t
              typedef :int, :__darwin_blksize_t
              typedef :ulong, :__darwin_clock_t
              typedef :int, :__darwin_ct_rune_t
              typedef :int, :__darwin_dev_t
              typedef :uint, :__darwin_fsblkcnt_t
              typedef :uint, :__darwin_fsfilcnt_t
              typedef :uint, :__darwin_gid_t
              typedef :uint, :__darwin_id_t
              typedef :ulong_long, :__darwin_ino64_t
              typedef :ulong_long, :__darwin_ino_t
              typedef :long, :__darwin_intptr_t
              typedef :uint, :__darwin_mach_port_name_t
              typedef :uint, :__darwin_mach_port_t
              typedef :ushort, :__darwin_mode_t
              typedef :uint, :__darwin_natural_t
              typedef :long_long, :__darwin_off_t
              typedef :int, :__darwin_pid_t
              typedef :ulong, :__darwin_pthread_key_t
              typedef :int, :__darwin_rune_t
              typedef :uint, :__darwin_sigset_t
              typedef :ulong, :__darwin_size_t
              typedef :uint, :__darwin_socklen_t
              typedef :long, :__darwin_ssize_t
              typedef :int, :__darwin_suseconds_t
              typedef :long, :__darwin_time_t
              typedef :uint, :__darwin_uid_t
              typedef :uint, :__darwin_useconds_t
              typedef ArrayType.new(types::UCHAR,16), :__darwin_uuid_t
              typedef :int, :__darwin_wchar_t
              typedef :int, :__darwin_wint_t
              typedef :int, :dev_t
              typedef :int, :fd_mask
              typedef :uint, :fsblkcnt_t
              typedef :uint, :fsfilcnt_t
              typedef :uint, :id_t
              typedef :ulong_long, :ino64_t
              typedef :ulong_long, :ino_t
              typedef :long, :intptr_t
              typedef :int, :key_t
              typedef :ushort, :mode_t
              typedef :ushort, :nlink_t
              typedef :ulong, :pthread_key_t
              typedef :ulong_long, :rlim_t
              typedef :ulong, :size_t
              typedef :long, :ssize_t
              typedef :int, :suseconds_t
              typedef :int, :swblk_t
              typedef :ulong_long, :syscall_arg_t
              typedef :long, :time_t
              typedef :ulong, :uintptr_t
              typedef :ulong_long, :user_addr_t
              typedef :long_long, :user_long_t
              typedef :ulong_long, :user_size_t
              typedef :long_long, :user_ssize_t
              typedef :long_long, :user_time_t
              typedef :ulong_long, :user_ulong_t

              if types::ADDRESS_SIZE == 8
                typedef :long, :__darwin_ptrdiff_t
                typedef ArrayType.new(types::CHAR,37), :__darwin_uuid_string_t
                typedef :int, :errno_t
                typedef :short, :int_fast16_t
                typedef :int, :int_fast32_t
                typedef :long_long, :int_fast64_t
                typedef :char, :int_fast8_t
                typedef :short, :int_least16_t
                typedef :int, :int_least32_t
                typedef :long_long, :int_least64_t
                typedef :char, :int_least8_t
                typedef :long, :intmax_t
                typedef :long, :ptrdiff_t
                typedef :long_long, :register_t
                typedef :ulong, :rsize_t
                typedef :uint, :sae_associd_t
                typedef :uint, :sae_connid_t
                typedef :ushort, :uint16_t
                typedef :uint, :uint32_t
                typedef :ulong_long, :uint64_t
                typedef :uchar, :uint8_t
                typedef :ushort, :uint_fast16_t
                typedef :uint, :uint_fast32_t
                typedef :ulong_long, :uint_fast64_t
                typedef :uchar, :uint_fast8_t
                typedef :ushort, :uint_least16_t
                typedef :uint, :uint_least32_t
                typedef :ulong_long, :uint_least64_t
                typedef :uchar, :uint_least8_t
                typedef :ulong, :uintmax_t
                typedef :long_long, :user_off_t
                typedef :int, :wchar_t
              else
                typedef :int, :__darwin_ptrdiff_t
                typedef :int, :register_t
              end
            end

          end
        end
      end
    end
  end
end
