#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/extensions/resolv'

#
# @since 0.3.0
#
class Regexp

  # Regular expression for finding words
  #
  # @since 0.5.0
  WORD = /[A-Za-z][A-Za-z'\-\.]*[A-Za-z]/

  # Regular expression for finding a decimal octet (0 - 255)
  #
  # @since 0.4.0
  OCTET = /25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9]/

  # Regular expression for finding MAC addresses in text
  MAC = /[0-9a-fA-F]{2}(?::[0-9a-fA-F]{2}){5}/

  # A regular expression for matching IPv4 Addresses.
  IPv4 = /#{OCTET}(?:\.#{OCTET}){3}(?:\/\d{1,2})?/

  # A regular expression for matching IPv6 Addresses.
  IPv6 = union(
    /(?:[0-9a-f]{1,4}:){6}#{IPv4}/,
    /(?:[0-9a-f]{1,4}:){5}[0-9a-f]{1,4}:#{IPv4}/,
    /(?:[0-9a-f]{1,4}:){5}:[0-9a-f]{1,4}:#{IPv4}/,
    /(?:[0-9a-f]{1,4}:){1,1}(?::[0-9a-f]{1,4}){1,4}:#{IPv4}/,
    /(?:[0-9a-f]{1,4}:){1,2}(?::[0-9a-f]{1,4}){1,3}:#{IPv4}/,
    /(?:[0-9a-f]{1,4}:){1,3}(?::[0-9a-f]{1,4}){1,2}:#{IPv4}/,
    /(?:[0-9a-f]{1,4}:){1,4}(?::[0-9a-f]{1,4}){1,1}:#{IPv4}/,
    /:(?::[0-9a-f]{1,4}){1,5}:#{IPv4}/,
    /(?:(?:[0-9a-f]{1,4}:){1,5}|:):#{IPv4}/,
    /(?:[0-9a-f]{1,4}:){1,1}(?::[0-9a-f]{1,4}){1,6}(?:\/\d{1,3})?/,
    /(?:[0-9a-f]{1,4}:){1,2}(?::[0-9a-f]{1,4}){1,5}(?:\/\d{1,3})?/,
    /(?:[0-9a-f]{1,4}:){1,3}(?::[0-9a-f]{1,4}){1,4}(?:\/\d{1,3})?/,
    /(?:[0-9a-f]{1,4}:){1,4}(?::[0-9a-f]{1,4}){1,3}(?:\/\d{1,3})?/,
    /(?:[0-9a-f]{1,4}:){1,5}(?::[0-9a-f]{1,4}){1,2}(?:\/\d{1,3})?/,
    /(?:[0-9a-f]{1,4}:){1,6}(?::[0-9a-f]{1,4}){1,1}(?:\/\d{1,3})?/,
    /[0-9a-f]{1,4}(?::[0-9a-f]{1,4}){7}(?:\/\d{1,3})?/,
    /:(?::[0-9a-f]{1,4}){1,7}(?:\/\d{1,3})?/,
    /(?:(?:[0-9a-f]{1,4}:){1,7}|:):(?:\/\d{1,3})?/
  )

  # A regular expression for matching IP Addresses.
  IP = /#{IPv4}|#{IPv6}/

  # Regular expression used to find host-names in text
  HOST_NAME = /(?:[a-zA-Z0-9]+(?:[_-][a-zA-Z0-9]+)*\.)+(?:#{union(Resolv::TLDS)})/i

  # Regular expression to match a word in the username of an email address
  USER_NAME = /[A-Za-z](?:[A-Za-z0-9]*[\._-])*[A-Za-z0-9]+/

  # Regular expression to find email addresses in text
  EMAIL_ADDR = /#{USER_NAME}\@#{HOST_NAME}/

  # Regular expression to find phone numbers in text
  #
  # @since 0.5.0
  PHONE_NUMBER = /(?:\d[ \-\.]?)?(?:\d{3}[ \-\.]?)?\d{3}[ \-\.]?\d{4}(?:x\d+)?/

  # Regular expression to find deliminators in text
  #
  # @since 0.4.0
  DELIM = /[;&\n\r]/

  # Regular expression to find identifier in text
  #
  # @since 0.4.0
  IDENTIFIER = /[_]*[a-zA-Z]+[a-zA-Z0-9_-]*/

  # Regular expression to find File extensions in text
  #
  # @since 0.4.0
  FILE_EXT = /(?:\.[A-Za-z0-9]+)+/

  # Regular expression to find File names in text
  #
  # @since 0.4.0
  FILE_NAME = /(?:[^\/\\\. ]|\\[\/\\ ])+/

  # Regular expression to find Files in text
  #
  # @since 0.4.0
  FILE = /#{FILE_NAME}(?:#{FILE_EXT})?/

  # Regular expression to find Directory names in text
  #
  # @since 0.4.0
  DIRECTORY = /(?:\.\.|\.|#{FILE})/

  # Regular expression to find local UNIX Paths in text
  #
  # @since 0.4.0
  RELATIVE_UNIX_PATH = /(?:#{DIRECTORY}\/)+#{DIRECTORY}\/?/

  # Regular expression to find absolute UNIX Paths in text
  #
  # @since 0.4.0
  ABSOLUTE_UNIX_PATH = /(?:\/#{FILE})+\/?/

  # Regular expression to find UNIX Paths in text
  #
  # @since 0.4.0
  UNIX_PATH = /#{ABSOLUTE_UNIX_PATH}|#{RELATIVE_UNIX_PATH}/

  # Regular expression to find local Windows Paths in text
  #
  # @since 0.4.0
  RELATIVE_WINDOWS_PATH = /(?:#{DIRECTORY}\\)+#{DIRECTORY}\\?/

  # Regular expression to find absolute Windows Paths in text
  #
  # @since 0.4.0
  ABSOLUTE_WINDOWS_PATH = /[A-Za-z]:(?:\\#{FILE})+\\?/

  # Regular expression to find Windows Paths in text
  #
  # @since 0.4.0
  WINDOWS_PATH = /#{ABSOLUTE_WINDOWS_PATH}|#{RELATIVE_WINDOWS_PATH}/

  # Regular expression to find local Paths in text
  #
  # @since 0.4.0
  RELATIVE_PATH = /#{RELATIVE_UNIX_PATH}|#{RELATIVE_WINDOWS_PATH}/

  # Regular expression to find absolute Paths in text
  #
  # @since 0.4.0
  ABSOLUTE_PATH = /#{ABSOLUTE_UNIX_PATH}|#{ABSOLUTE_WINDOWS_PATH}/

  # Regular expression to find Paths in text
  #
  # @since 0.4.0
  PATH = /#{UNIX_PATH}|#{WINDOWS_PATH}/

end
