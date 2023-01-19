# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/compression/zlib'

require 'stringio'

module Ronin
  module Support
    module Compression
      module Gzip
        #
        # Handles writing gzip compressed data.
        #
        # @see https://rubydoc.info/stdlib/zlib/Zlib/GzipWriter
        #
        # @api public
        #
        # @since 1.0.0
        #
        class Writer < ::Zlib::GzipWriter

          #
          # Initializes the gzip writer.
          #
          # @param [IO, StringIO, String] io_or_buffer
          #   The IO object or buffer to write to. If a `String` is given, then
          #   it will be wrapped in a `StringIO` object using the optional
          #   `mode` argument.
          #
          # @param [String] mode
          #   The optional mode to initialize the `StringIO` object to wrap
          #   around the given buffer `String`.
          #
          # @example Initializing with an IO object:
          #   gzip = Compression::Gzip::Writer.new(io)
          #
          # @example Initializing with a buffer:
          #   buffer = ""
          #   gzip   = Compression::Gzip::Writer.new(buffer)
          #
          # @example Initializin with a buffer and append mode:
          #   buffer = "foo"
          #   gzip   = Compression::Gzip::Writer.new(buffer, mode: 'a')
          #
          def initialize(io_or_buffer, mode: 'w')
            io = case io_or_buffer
                 when String then StringIO.new(io_or_buffer,mode)
                 else             io_or_buffer
                 end

            super(io)
          end

        end
      end
    end
  end
end
