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

require 'ronin/extensions/resolv'

class Regexp

  # Regular expression for finding a decimal octet (0 - 255)
  OCTET = /25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9]/

  # Regular expression for finding MAC addresses in text
  MAC = /[0-9a-fA-F]{2}(?::[0-9a-fA-F]{2}){5}/

  # A regular expression for matching IPv4 Addresses.
  IPv4 = /#{OCTET}(?:\.#{OCTET}){3}(?:\/\d{1,2})?/

  # A regular expression for matching IPv6 Addresses.
  IPv6 = /::ffff:#{IPv4}|(?:::)?[0-9a-f]{1,4}(::?[0-9a-f]{1,4}){,7}(?:::)?(?:\/\d{1,3})?/

  # A regular expression for matching IP Addresses.
  IP = /#{IPv4}|#{IPv6}/

  # Regular expression used to find host-names in text
  HOST_NAME = /(?:[a-zA-Z0-9]+(?:[_-][a-zA-Z0-9]+)*\.)+(?:#{union(Resolv::TLDS)})/i

  # Regular expression to match a word in the username of an email address
  USER_NAME = /[A-Za-z](?:[A-Za-z0-9]*[\._-])*[A-Za-z0-9]+/

  # Regular expression to find email addresses in text
  EMAIL_ADDR = /#{USER_NAME}\@#{HOST_NAME}/

  # Regular expression to find deliminators in text
  DELIM = /[;&\n\r]/

  # Regular expression to find identifier in text
  IDENTIFIER = /[_]*[a-zA-Z]+[a-zA-Z0-9_-]*/

  # Regular expression to find File extensions in text
  FILE_EXT = /(?:\.[A-Za-z0-9]+)+/

  # Regular expression to find File names in text
  FILE_NAME = /(?:[^\/\\\. ]|\\[\/\\ ])+/

  # Regular expression to find Files in text
  FILE = /#{FILE_NAME}(?:#{FILE_EXT})?/

  # Regular expression to find Directory names in text
  DIRECTORY = /(?:\.\.|\.|#{FILE})/

  # Regular expression to find local UNIX Paths in text
  LOCAL_UNIX_PATH = /(?:#{DIRECTORY}\/)+#{DIRECTORY}\/?/

  # Regular expression to find absolute UNIX Paths in text
  ABSOLUTE_UNIX_PATH = /(?:\/#{FILE})+\/?/

  # Regular expression to find UNIX Paths in text
  UNIX_PATH = /#{ABSOLUTE_UNIX_PATH}|#{LOCAL_UNIX_PATH}/

  # Regular expression to find local Windows Paths in text
  LOCAL_WINDOWS_PATH = /(?:#{DIRECTORY}\\)+#{DIRECTORY}\\?/

  # Regular expression to find absolute Windows Paths in text
  ABSOLUTE_WINDOWS_PATH = /[A-Za-z]:(?:\\#{DIRECTORY})+\\?/

  # Regular expression to find Windows Paths in text
  WINDOWS_PATH = /#{ABSOLUTE_WINDOWS_PATH}|#{LOCAL_WINDOWS_PATH}/

  # Regular expression to find local Paths in text
  LOCAL_PATH = /#{LOCAL_UNIX_PATH}|#{LOCAL_WINDOWS_PATH}/

  # Regular expression to find absolute Paths in text
  ABSOLUTE_PATH = /#{ABSOLUTE_UNIX_PATH}|#{ABSOLUTE_WINDOWS_PATH}/

  # Regular expression to find Paths in text
  PATH = /#{UNIX_PATH}|#{WINDOWS_PATH}/

end
