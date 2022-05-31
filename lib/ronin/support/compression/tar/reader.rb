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

require 'rubygems/package'
require 'stringio'

module Ronin
  module Support
    module Compression
      module Tar
        #
        # Handling reading tar encoded archive data.
        #
        # @see https://rubydoc.info/stdlib/rubygems/Gem/Package/TarReader
        #
        # @api public
        #
        # @since 1.0.0
        #
        class Reader < Gem::Package::TarReader

          #
          # Initializes the tar writer.
          #
          # @param [IO, StringIO, String] io_or_buffer
          #   The IO object or buffer to read from. If a `String` is given, then
          #   it will be wrapped in a `StringIO` object using the optional
          #   `mode` argument.
          #
          # @param [String] mode
          #   The optional mode to initialize the `StringIO` object to wrap
          #   around the given buffer `String`.
          #
          # @example Initializing with an IO object:
          #   tar = Compression::Tar::Reader.new(io)
          #
          # @example Initializing with a buffer:
          #   buffer = "..."
          #   tar   = Compression::Tar::Reader.new(buffer)
          #
          def self.new(io_or_buffer, mode: 'r')
            io = case io_or_buffer
                 when String then StringIO.new(io_or_buffer,mode)
                 else             io_or_buffer
                 end

            return super(io)
          end

          #
          # Finds an entry in the tar archive with the matching name.
          #
          # @param [String] name
          #   The entry name to search for.
          #
          # @return [Entry, nil]
          #   The matching entry or `nil` if none could be found.
          #
          def [](name)
            find { |entry| entry.full_name == name }
          end

        end
      end
    end
  end
end
