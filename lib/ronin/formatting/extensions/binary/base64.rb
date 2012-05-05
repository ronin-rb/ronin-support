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

require 'base64'

module Base64
  if RUBY_VERSION < '1.9'
    module_function

    # Returns the Base64-encoded version of +bin+.
    # This method complies with RFC 4648.
    # No line feeds are added.
    def strict_encode64(bin)
      encode64(bin).tr("\n",'')
    end

    # Returns the Base64-decoded version of +str+.
    # This method complies with RFC 4648.
    # ArgumentError is raised if +str+ is incorrectly padded or contains
    # non-alphabet characters.  Note that CR or LF are also rejected.
    def strict_decode64(str)
      unless str.include?("\n")
        decode64(str)
      else
        raise(ArgumentError,"invalid base64")
      end
    end

    # Returns the Base64-encoded version of +bin+.
    # This method complies with ``Base 64 Encoding with URL and Filename Safe
    # Alphabet'' in RFC 4648.
    # The alphabet uses '-' instead of '+' and '_' instead of '/'.
    #
    # @note Backported from Ruby 1.9.3
    #
    def urlsafe_encode64(bin)
      strict_encode64(bin).tr("+/", "-_")
    end

    # Returns the Base64-decoded version of +str+.
    # This method complies with ``Base 64 Encoding with URL and Filename Safe
    # Alphabet'' in RFC 4648.
    # The alphabet uses '-' instead of '+' and '_' instead of '/'.
    #
    # @note Backported from Ruby 1.9.3
    #
    def urlsafe_decode64(str)
      strict_decode64(str.tr("-_", "+/"))
    end
  end
end
