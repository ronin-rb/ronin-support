#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301  USA
#

require 'pathname'

module Ronin
  #
  # The {Path} class extends `Pathname` to allow representing directory
  # traversal paths.
  #
  class Path < Pathname

    # The separator to join paths together with
    attr_accessor :separator

    def initialize(path)
      @separator = File::SEPARATOR

      super(path)
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
    # @example Generate a relative path that goes up 7 directories.
    #   Path.up(7)
    #   # => #<Ronin::Path:../../../../../../..>
    #
    # @example Generate multiple relative paths, going up 1 to 3 directories.
    #   Path.up(1..3)
    #   # => [#<Ronin::Path:..>, #<Ronin::Path:../..>,
    #   #<Ronin::Path:../../..>]
    #
    def self.up(n,separator=File::SEPARATOR)
      if n.kind_of?(Integer)
        if n == 0
          return separator
        elsif n < 0
          raise(ArgumentError,"negative argument")
        end

        dirs = (['..'] * n)

        path = self.new('..')
        path.separator = separator

        return Path.new(path.join(*(['..'] * (n-1))))
      else
        return n.map { |i| self.up(i) }
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
    #   # => #<Ronin::Path:../../../../../../../etc/passwd>
    #
    def join(*names)
      names = names.map { |name| name.to_s }

      return self.class.new([self,*names].join(@separator))
    end

    #
    # Joins a directory name to the path, but does not resolve the resulting
    # path.
    #
    # @param [String] name
    #   A directory name.
    #
    # @example
    #   Path.up(7) / 'etc' / 'passwd'
    #   # => #<Ronin::Path:../../../../../../../etc/passwd>
    #
    # @see join
    #
    def /(name)
      join(name)
    end

  end
end
