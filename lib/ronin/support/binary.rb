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

require 'ronin/support/binary/core_ext'
require 'ronin/support/binary/template'
require 'ronin/support/binary/buffer'
require 'ronin/support/binary/cstring'
require 'ronin/support/binary/array'
require 'ronin/support/binary/stack'
require 'ronin/support/binary/struct'
require 'ronin/support/binary/union'
require 'ronin/support/binary/unhexdump'

module Ronin
  module Support
    #
    # Modules and classes for working with binary data.
    #
    # ## Core-Ext Methods
    #
    # * {::Array#pack}
    # * {::Float#pack}
    # * {::Integer#pack}
    # * {::Integer#to_uint8}
    # * {::Integer#to_uint16}
    # * {::Integer#to_uint32}
    # * {::Integer#to_uint64}
    # * {::Integer#to_int8}
    # * {::Integer#to_int16}
    # * {::Integer#to_int32}
    # * {::Integer#to_int64}
    # * {::String#unpack}
    # * {::String#unpack1}
    #
    module Binary
    end
  end
end
