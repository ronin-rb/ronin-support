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

require 'ronin/support/encoding/powershell'

class String

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
  # @see Ronin::Support::Encoding::PowerShell.escape
  #
  # @api public
  #
  # @since 1.0.0
  #
  def powershell_escape
    Ronin::Support::Encoding::PowerShell.escape(self)
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
  # @see Ronin::Support::Encoding::PowerShell.unescape
  #
  # @api public
  #
  # @since 1.0.0
  #
  def powershell_unescape
    Ronin::Support::Encoding::PowerShell.unescape(self)
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
  #   "hello world".powershell_encode
  #   # => "$([char]0x68)$([char]0x65)$([char]0x6c)$([char]0x6c)$([char]0x6f)$([char]0x20)$([char]0x77)$([char]0x6f)$([char]0x72)$([char]0x6c)$([char]0x64)"
  #
  # @see Ronin::Support::Encoding::PowerShell.encode
  #
  # @api public
  #
  # @since 1.0.0
  #
  def powershell_encode
    Ronin::Support::Encoding::PowerShell.encode(self)
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
  # @see Ronin::Support::Encoding::PowerShell.quote
  #
  # @api public
  #
  # @since 1.0.0
  #
  def powershell_string
    Ronin::Support::Encoding::PowerShell.quote(self)
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
  # @see Ronin::Support::Encoding::PowerShell.unquote
  #
  # @since 1.0.0
  #
  # @api public
  #
  def powershell_unquote
    Ronin::Support::Encoding::PowerShell.unquote(self)
  end

  alias psh_unquote powershell_unquote

end
