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

begin
  require 'zlib'
rescue LoadError
  warn "WARNING: Ruby was not compiled with zlib support"
end

module Ronin
  module Support
    module Compression
      #
      # Methods for zlib compression.
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Zlib
        include ::Zlib

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
        #   Compression::Zlib.inflate("x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15")
        #   # => "hello"
        #
        # @api public
        #
        def self.inflate(string)
          ::Zlib::Inflate.inflate(string)
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
        #   Compression::Zlib.deflate("hello")
        #   # => "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15"
        #
        # @api public
        #
        def self.deflate(string)
          ::Zlib::Deflate.deflate(string)
        end
      end
    end
  end
end
