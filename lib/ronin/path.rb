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

        path = self.new('..')
        path.separator = separator

        dirs = (['..'] * (n-1))

        return Path.new(path.join(*dirs))
      elsif n.kind_of?(Enumerable)
        return n.map { |i| self.up(i) }
      else
        raise(ArgumentError,"The first argument of Path.up must be either an Integer or Enumerable",caller)
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
      sub_dirs = names.map { |name| name.to_s }

      # filter out errant directory separators
      sub_dirs.reject! { |dir| dir == @separator }

      # join the path
      sub_path = sub_dirs.join(@separator)

      path = if self.root?
               # prefix the root dir
               self.to_s + sub_path
             else
               # join the path with the sub-path
               [self.to_s, sub_path].join(@separator)
             end

      return self.class.new(path)
    end

    alias / join

  end
end
