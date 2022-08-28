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

require 'pathname'

module Ronin
  module Support
    #
    # The {Path} class extends `Pathname` to allow representing directory
    # traversal paths.
    #
    # @api public
    #
    class Path < Pathname

      # The separator to join paths together with
      #
      # @return [String]
      attr_accessor :separator

      #
      # Initializes a new Path.
      #
      # @param [String] path
      #   The path.
      #
      # @param [String] separator
      #   The directory separator to use.
      #
      def initialize(path,separator=File::SEPARATOR)
        @separator = separator

        super(path)
      end

      #
      # The root path.
      #
      # @return [Path]
      #   The root path.
      #
      def Path.root
        Path.new('/')
      end

      #
      # Creates a new path object for upward directory traversal.
      #
      # @param [Integer, Array, Range] n
      #   The number of directories to go up.
      #
      # @param [String] separator
      #   Path separator.
      #
      # @return [Path]
      #   The new path object.
      #
      # @raise [ArgumentError]
      #   A negative number was given as the first argument.
      #
      # @example Generate a relative path that goes up 7 directories:
      #   Path.up(7)
      #   # => #<Ronin::Support::Path:../../../../../../..>
      #
      # @example Generate multiple relative paths, going up 1 to 3 directories:
      #   Path.up(1..3)
      #   # => [#<Ronin::Support::Path:..>, #<Ronin::Support::Path:../..>,
      #   #<Ronin::Support::Path:../../..>]
      #
      def self.up(n,separator=File::SEPARATOR)
        case n
        when Integer
          if n == 0
            separator
          elsif n > 0
            path = new('..',separator)
            path.join(*(['..'] * (n-1)))
          else
            raise(ArgumentError,"negative argument")
          end
        when Enumerable
          n.map { |i| up(i) }
        else
          raise(ArgumentError,"The first argument of Path.up must be either an Integer or Enumerable")
        end
      end

      #
      # Joins directory names together with the path, but does not resolve
      # the resulting path.
      #
      # @param [Array] names
      #   The names to join together.
      #
      # @return [Path]
      #   The joined path.
      #
      # @example
      #   Path.up(7).join('etc/passwd')
      #   # => #<Ronin::Support::Path:../../../../../../../etc/passwd>
      #
      def join(*names)
        joined_path = if root? then ''
                      else          self.to_s
                      end

        names.each do |name|
          name = name.to_s

          joined_path << @separator unless name.start_with?(@separator)
          joined_path << name       unless name == @separator
        end

        return self.class.new(joined_path,@separator)
      end

      alias / join

    end
  end
end
