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

require 'ronin/extensions/resolv'

class Regexp

  # Regular expression for finding MAC addresses in text
  MAC = /[0-9a-fA-F]{2}(?::[0-9a-fA-F]{2}){5}/

  # A regular expression for matching IPv4 Addresses.
  IPv4 = /[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}/

  # A regular expression for matching IPv6 Addresses.
  IPv6 = /:(:[0-9a-f]{1,4}){1,7}|([0-9a-f]{1,4}::?){1,7}[0-9a-f]{1,4}(:#{IPv4})?/

  # A regular expression for matching IP Addresses.
  IP = /#{IPv4}|#{IPv6}/

  # Regular expression used to find host-names in text
  HOST_NAME = /(?:[a-zA-Z0-9]+(?:[_-][a-zA-Z0-9]+)*\.)+(?:#{union(Resolv::TLDS)})/i

  # Regular expression to match a word in the username of an email address
  USER_NAME = /[A-Za-z](?:[A-Za-z0-9]+[\._-])*[A-Za-z0-9]+/

  # Regular expression to find email addresses in text
  EMAIL_ADDR = /#{USER_NAME}(?:\.#{USER_NAME})*\@#{HOST_NAME}/

end
