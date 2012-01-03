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

class String

  #
  # Escapes an String for SQL.
  #
  # @param [Symbol] quotes (:single)
  #   Specifies whether to create a single or double quoted string.
  #   May be either `:single` or `:double`.
  #
  # @return [String]
  #   The escaped String.
  #
  # @raise [ArgumentError]
  #   The quotes argument was neither `:single` nor `:double`.
  #
  # @example
  #   "O'Brian".sql_escape
  #   # => "'O''Brian'"
  #
  # @since 0.3.0
  #
  def sql_escape(quotes=:single)
    case quotes
    when :single
      "'#{gsub(/'/,"''")}'"
    when :double
      "\"#{gsub(/"/,'""')}\""
    else
      raise(ArgumentError,"invalid quoting style #{quotes.inspect}")
    end
  end

  #
  # Returns the SQL hex-string encoded form of the String.
  #
  # @example
  #   "/etc/passwd".sql_encode
  #   # => "0x2f6574632f706173737764"
  #
  def sql_encode
    return '' if empty?

    hex_string = '0x'

    each_byte do |b|
      hex_string << ('%.2x' % b)
    end

    return hex_string
  end

  #
  # Returns the SQL decoded form of the String.
  #
  # @example
  #   "'Conan O''Brian'".sql_decode
  #   # => "Conan O'Brian"
  #
  # @example
  #  "0x2f6574632f706173737764".sql_decode
  #  # => "/etc/passwd"
  #
  def sql_decode
    if ((self[0...2] == '0x') && (length % 2 == 0))
      raw = ''

      self[2..-1].scan(/[0-9a-fA-F]{2}/).each do |hex_char|
        raw << hex_char.hex.chr
      end

      return raw
    elsif (self[0..0] == "'" && self[-1..-1] == "'")
      self[1..-2].gsub("\\'","'").gsub("''","'")
    else
      return self
    end
  end

  #
  # Prepares the String for injection into a SQL expression.
  #
  # @return [String]
  #   The SQL injection ready String.
  #
  # @example
  #   "'1' OR '1'='1'".sql_inject
  #   # => "1' OR '1'='1"
  #
  # @example
  #   "'1' OR 1=1".sql_inject
  #   # => "1' OR 1=1 OR '"
  #
  # @example
  #   "'1' OR 1=1".sql_inject(:terminate => true)
  #   # => "1' OR 1=1 --"
  #
  # @api public
  #
  # @since 0.4.0
  #
  def sql_inject
    if (start_with?("'") || start_with?('"') || start_with?('`'))
      if self[0,1] == self[-1,1]
        self[1..-2]
      else
        "#{self[1..-1]}--"
      end
    else
      self
    end
  end

end
