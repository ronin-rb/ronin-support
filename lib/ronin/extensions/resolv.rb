#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'resolv'

class Resolv

  #
  # Creates a new resolver.
  #
  # @param [String, Array<String>, nil] nameserver
  #   The nameserver(s) to query.
  #
  # @return [Resolv::DNS]
  #   A new resolver for the given nameservers, or the default resolver.
  #
  # @example
  #   Resolv.resolver('4.2.2.1')
  #
  # @since 0.3.0
  #
  # @api public
  #
  def Resolv.resolver(nameserver=nil)
    if nameserver
      DNS.new(:nameserver => nameserver)
    else
      self
    end
  end

end
