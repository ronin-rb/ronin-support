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

require 'ronin/support/archive/zip/reader'
require 'ronin/support/archive/zip/writer'

module Ronin
  module Support
    module Archive
      #
      # Handles zip archive reading/writing.
      #
      # @api public
      #
      # @since 1.0.0
      #
      module Zip
        #
        # Creates a zip archive reader or writer object.
        #
        # @param [String] path
        #   The path of the zip archive.
        #
        # @param [String] mode
        #   The mode to open the zip archive in.
        #
        # @yield [zip]
        #   If a block is given, it will be passed the zip stream object.
        #
        # @yieldparam [Reader, Writer] zip
        #   The zip reader or writer object.
        #
        # @return [Reader, Writer]
        #   The zip reader or writer object.
        #
        # @raise [ArgumentError]
        #   The mode must include either `r`, `w`, or `a`.
        #
        # @api public
        #
        def self.new(path, mode: 'r', &block)
          zip_class = if mode.include?('w') || mode.include?('a')
                        Writer
                      elsif mode.include?('r')
                        Reader
                      else
                        raise(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
                      end

          return zip_class.new(path,&block)
        end

        #
        # Opens a zip file for reading or writing.
        #
        # @param [String] path
        #   The path to the zip file.
        #
        # @param [String] mode
        #   The mode to open the zip file in.
        #
        # @yield [gz]
        #   If a block is given, it will be passed the zip writer object.
        #
        # @yieldparam [Reader, Writer] gz
        #   The zip writer object.
        #
        # @return [Reader, Writer]
        #   The zip writer object.
        #
        # @raise [ArgumentError]
        #   The mode must include either `r`, `w`, or `a`.
        #
        # @api public
        #
        def self.open(path, mode: 'r', &block)
          zip_class = if mode.include?('w') || mode.include?('a')
                        Writer
                      elsif mode.include?('r')
                        Reader
                      else
                        raise(ArgumentError,"mode argument must include either 'r', 'w', or 'a'")
                      end

          return zip_class.open(path,&block)
        end
      end
    end
  end
end
