# frozen_string_literal: true
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/ctypes/os'

module Ronin
  module Support
    module Binary
      module CTypes
        class OS
          #
          # Contains additional types available on Windows.
          #
          # @api semipublic
          #
          # @since 1.0.0
          #
          class Windows < OS

            #
            # Initializes the Windows types object.
            #
            # @param [#[]] types
            #   The base types module.
            #
            def initialize(types)
              super(types)

              if types::ADDRESS_SIZE == 8
                # NOTE: `long` and `unsigne long` are actually 4 bytes on
                # 64bit Windows systems.
                #
                # https://www.intel.com/content/www/us/en/developer/articles/technical/size-of-long-integer-type-on-different-architecture-and-os.html
                typedef types::INT32, :long
                typedef types::UINT32, :ulong
              end

              typedef :uint, :_dev_t
              typedef :uint, :dev_t
              typedef :int, :errno_t
              typedef :ushort, :_ino_t
              typedef :ushort, :ino_t
              typedef :short, :int16_t
              typedef :int, :int32_t
              typedef :long_long, :int64_t
              typedef :char, :int8_t
              typedef :short, :int_fast16_t
              typedef :int, :int_fast32_t
              typedef :long_long, :int_fast64_t
              typedef :char, :int_fast8_t
              typedef :short, :int_least16_t
              typedef :int, :int_least32_t
              typedef :long_long, :int_least64_t
              typedef :char, :int_least8_t
              typedef :long_long, :intmax_t
              typedef :ushort, :_mode_t
              typedef :ushort, :mode_t
              typedef :long, :off32_t
              typedef :long_long, :_off64_t
              typedef :long_long, :off64_t
              typedef :long, :_off_t
              typedef :long_long, :off_t
              typedef :long, :__time32_t
              typedef :long_long, :__time64_t
              typedef :ushort, :uint16_t
              typedef :ulong_long, :uint64_t
              typedef :uchar, :uint8_t
              typedef :ushort, :uint_fast16_t
              typedef :uint, :uint_fast32_t
              typedef :ulong_long, :uint_fast64_t
              typedef :uchar, :uint_fast8_t
              typedef :ushort, :uint_least16_t
              typedef :ulong_long, :uint_least64_t
              typedef :uchar, :uint_least8_t
              typedef :ulong_long, :uintmax_t
              typedef :uint, :useconds_t
              typedef :ushort, :wchar_t
              typedef :ushort, :wctype_t
              typedef :ushort, :wint_t

              if types::ADDRESS_SIZE == 8
                typedef :long_long, :intptr_t
                typedef :long_long, :_pid_t
                typedef :long_long, :pid_t
                typedef :long_long, :ptrdiff_t
                typedef :ulong_long, :rsize_t
                typedef :ulong_long, :_sigset_t
                typedef :ulong_long, :size_t
                typedef :long_long, :ssize_t
                typedef :long_long, :time_t
                typedef :ulong_long, :uintptr_t
              else
                typedef :int, :intptr_t
                typedef :int, :_pid_t
                typedef :int, :pid_t
                typedef :int, :ptrdiff_t
                typedef :uint, :rsize_t
                typedef :ulong, :_sigset_t
                typedef :uint, :size_t
                typedef :int, :ssize_t
                typedef :long, :time_t
                typedef :uint, :uintptr_t
              end
            end
          end
        end
      end
    end
  end
end
