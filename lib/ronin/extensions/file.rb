#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
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
  def File.each_line(path)
    return enum_for(__method__,path) unless block_given?

    File.open(path) do |file|
      file.each_line { |line| yield line.chomp }
    end
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
  def File.each_row(path,separator=/\s+/)
    return enum_for(__method__,path,separator) unless block_given?

    File.each_line(path) { |line| yield line.split(separator) }
  end

  if RUBY_VERSION < '1.9.'
    #
    # Writes the given data to a specified path.
    #
    # @param [String] path
    #   The path of the file to write to.
    #
    # @param [String] data
    #   The data to write to the file.
    #
    # @param [Integer] offset
    #   Optional offset to write the data to.
    #
    # @return [nil]
    #
    # @example
    #   File.write('dump.txt',data)
    #
    # @api public
    #
    def File.write(path,data,offset=0)
      File.open(path,'w') do |file|
        file.seek(offset)
        file.write(data)
      end
    end
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
  def File.escape_path(path)
    path = path.to_s

    # remove any \0 characters first
    path.tr!("\0",'')

    # remove any home-dir expansions
    path.gsub!('~',"\\~")

    path = File.expand_path(File.join('/',path))

    # remove the leading slash
    return path[1..-1]
  end

end
