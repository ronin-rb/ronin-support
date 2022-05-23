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

require 'ronin/support/compression'

module Ronin
  module Support
    module Compression
      #
      # Provides helper methods for compression algorithms/formats.
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Mixin
        #
        # Zlib inflate a string.
        #
        # @param [String] string
        #   The Zlib compressed input.
        #
        # @return [String]
        #   The Zlib inflated form of the input.
        #
        # @example
        #   zlib_inflate("x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15")
        #   # => "hello"
        #
        # @api public
        #
        def zlib_inflate(string)
          Compression.zlib_inflate(string)
        end

        #
        # Zlib deflate a string.
        #
        # @param [String] string
        #   The uncompressed input.
        #
        # @return [String]
        #   The Zlib deflated form of the input.
        #
        # @example
        #   zlib_deflate("hello")
        #   # => "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15"
        #
        # @api public
        #
        def zlib_deflate(string)
          Compression.zlib_deflate(string)
        end
      end
    end
  end
end
