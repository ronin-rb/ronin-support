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

require 'ronin/support/binary/types/os/unix'

module Ronin
  module Support
    module Binary
      module Types
        class OS
          #
          # Common types shared by all BSD OSes.
          #
          # @api private
          #
          # @since 1.0.0
          #
          class BSD < UNIX

            #
            # Initializes the FreeBSD types object.
            #
            # @param [#[]] types
            #   The base types module.
            #
            def initialize(types)
              super(types)

              typedef :string, :caddr_t
              typedef :uint, :fixpt_t
              typedef :long_long, :__int64_t
              typedef :long_long, :int64_t
              typedef :long_long, :off_t
              typedef :pointer, :qaddr_t
              typedef :long_long, :quad_t
              typedef :uchar, :sa_family_t
              typedef :int, :segsz_t
              typedef :ulong_long, :__uint64_t
              typedef :ulong_long, :u_quad_t
              typedef :uint, :useconds_t
            end

          end
        end
      end
    end
  end
end
