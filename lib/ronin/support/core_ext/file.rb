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

class File

  #
  # Reads each line from the file.
  #
  # @param [String] path
  #   The path of the file.
  #
  # @yield [line]
  #   The given block will be passed each line.
  #
  # @yieldparam [String] line
  #   A line from the file, with the trailing newline characters removed.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator will be returned.
  #
  # @example
  #   File.each_line('passwords.txt') do |line|
  #     # ...
  #   end
  #
  # @since 0.3.0
  #
  # @api public
  #
  def self.each_line(path)
    return enum_for(__method__,path) unless block_given?

    foreach(path) { |line| yield line.chomp }
  end

  #
  # Reads each row from the file.
  #
  # @param [String] path
  #   The path of the file.
  #
  # @param [Regexp, String] separator
  #   The pattern to split the line by.
  #
  # @yield [row]
  #   The given block will be passed each row.
  #
  # @yieldparam [Array<String>] row
  #   A row from the file.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator will be returned.
  #
  # @example
  #   File.each_row('db_dump.txt', '|') do |row|
  #     # ...
  #   end
  #
  # @since 0.3.0
  #
  # @api public
  #
  def self.each_row(path,separator=/\s+/)
    return enum_for(__method__,path,separator) unless block_given?

    each_line(path) { |line| yield line.split(separator) }
  end

  #
  # Escapes a path.
  #
  # @param [String] path
  #   Unescaped path.
  #
  # @return [String]
  #   The escaped path.
  #
  # @api public
  #
  def self.escape_path(path)
    path = path.to_s

    # remove any \0 characters first
    path.tr!("\0",'')

    # remove any home-dir expansions
    path.gsub!('~',"\\~")

    path = expand_path(File.join('/',path))

    # remove the leading slash
    return path[1..-1]
  end

end
