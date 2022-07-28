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

require 'ronin/support/format/text/core_ext/string'
require 'ronin/support/format/powershell/core_ext/integer'

class String

  # PowerShell characters that must be grave-accent escaped.
  #
  # @see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
  POWERSHELL_BACKSLASHED_CHARS = {
    '0'  => "\0",
    'a'  => "\a",
    'b'  => "\b",
    't'  => "\t",
    'n'  => "\n",
    'v'  => "\v",
    'f'  => "\f",
    'r'  => "\r",
    '"'  => '"',
    '#'  => '#',
    "'"  => "'",
    "`"  => "`"
  }

  #
  # [PowerShell escapes][1] the characters in the String.
  #
  # [1]: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
  #
  # @return [String]
  #   The PowerShell escaped string.
  #
  # @example
  #   "hello\nworld".powershell_escape
  #   # => "hello`nworld"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def powershell_escape
    format_chars { |c| c.ord.powershell_escape }
  end

  alias psh_escape powershell_escape

  #
  # [PowerShell unescapes][1] the characters in the String.
  #
  # [1]: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
  #
  # @return [String]
  #   The PowerShell unescaped string.
  #
  # @example
  #   "hello`nworld".powershell_unescape
  #   # => "hello\nworld"
  #
  # @api public
  #
  # @since 1.0.0
  #
  def powershell_unescape
    unescaped = String.new
    scanner   = StringScanner.new(self)

    until scanner.eos?
      if (backslash_char = scanner.scan(/`[0abetnvfr]/)) # `c
        unescaped << POWERSHELL_BACKSLASHED_CHARS[backslash_char[1,1]]
      elsif (hex_char = scanner.scan(/\$\(\[char\]0x[0-9a-fA-F]{1,2}\)/)) # [char]0xXX
        unescaped << hex_char[10..-2].to_i(16).chr
      elsif (hex_char = scanner.scan(/\$\(\[char\]0x[0-9a-fA-F]{3,}\)/)) # [char]0xXX
        unescaped << hex_char[10..-2].to_i(16).chr(Encoding::UTF_8)
      elsif (unicode_char = scanner.scan(/`u\{[0-9a-fA-F]+\}/)) # `u{XXXX}'
        unescaped << unicode_char[3..-2].to_i(16).chr(Encoding::UTF_8)
      else
        unescaped << scanner.getch
      end
    end

    return unescaped
  end

  alias psh_unescape powershell_unescape

  #
  # [PowerShell encodes][1] every character in the String.
  #
  # [1]: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.2
  #
  # @return [String]
  #   The PowerShell encoded String.
  #
  # @example
  #   "hello world".shell_encode
  #   # => 
  #
  # @api public
  #
  # @since 1.0.0
  #
  def powershell_encode
    format_chars { |c| c.ord.powershell_encode }
  end

  alias psh_encode powershell_encode

  alias powershell_decode powershell_unescape
  alias psh_decode powershell_decode

  #
  # Converts the String into a double-quoted PowerShell escaped String.
  #
  # @return [String]
  #   The quoted and escaped PowerShell string.
  #
  # @example
  #   "hello\nworld".powershell_string
  #   # => "\"hello`nworld\""
  #
  # @api public
  #
  # @since 1.0.0
  #
  def powershell_string
    "\"#{powershell_escape}\""
  end

  alias psh_string powershell_string

  #
  # Removes the quotes an unescapes a PowerShell string.
  #
  # @return [String]
  #   The un-quoted String if the String begins and ends with quotes, or the
  #   same String if it is not quoted.
  #
  # @example
  #   "\"hello`nworld\"".powershell_unquote
  #   # => "hello\nworld"
  #   "'hello''world'".powershell_unquote
  #   # => "hello'world"
  #
  # @since 1.0.0
  #
  # @api public
  #
  def powershell_unquote
    if (self[0] == '"' && self[-1] == '"')
      self[1..-2].powershell_unescape
    elsif (self[0] == "'" && self[-1] == "'")
      self[1..-2].gsub("''","'")
    else
      self
    end
  end

  alias psh_unquote powershell_unquote

end
