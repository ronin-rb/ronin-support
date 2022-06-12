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

require 'ronin/support/core_ext/resolv'

module Ronin
  module Support
    module Text
      #
      # @since 0.3.0
      #
      module Patterns
        # Regular expression for finding all numbers in text.
        #
        # @since 1.0.0
        NUMBER = /[0-9]+/

        # Regular expression for finding all hexadecimal numbers in text.
        #
        # @since 1.0.0
        HEX_NUMBER = /(?:0x)?[0-9a-fA-F]+/

        # Regular expression for finding all MD5 hashes in text.
        #
        # @since 1.0.0
        MD5 = /[0-9a-fA-F]{32}/

        # Regular expression for finding all SHA1 hashes in text.
        #
        # @since 1.0.0
        SHA1 = /[0-9a-fA-F]{40}/

        # Regular expression for finding all SHA256 hashes in text.
        #
        # @since 1.0.0
        SHA256 = /[0-9a-fA-F]{64}/

        # Regular expression for finding all SHA512 hashes in text.
        #
        # @since 1.0.0
        SHA512 = /[0-9a-fA-F]{128}/

        # Regular expression for finding all hashes in text.
        #
        # @since 1.0.0
        HASH = /#{SHA512}|#{SHA256}|#{SHA1}|#{MD5}/

        # Regular expression for finding words
        #
        # @since 0.5.0
        WORD = /[A-Za-z][A-Za-z'\-\.]*[A-Za-z]/

        # Regular expression for finding a decimal octet (0 - 255)
        #
        # @since 0.4.0
        DECIMAL_OCTET = /25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9]/

        # Regular expression for finding MAC addresses in text
        #
        # @since 1.0.0
        MAC_ADDR = /[0-9a-fA-F]{2}(?::[0-9a-fA-F]{2}){5}/

        # A regular expression for matching IPv4 Addresses.
        #
        # @since 1.0.0
        IPV4_ADDR = /#{DECIMAL_OCTET}(?:\.#{DECIMAL_OCTET}){3}(?:\/\d{1,2})?/

        # A regular expression for matching IPv6 Addresses.
        #
        # @since 1.0.0
        IPV6_ADDR = Regexp.union(
          /(?:[0-9a-f]{1,4}:){6}#{IPV4_ADDR}/,
          /(?:[0-9a-f]{1,4}:){5}[0-9a-f]{1,4}:#{IPV4_ADDR}/,
          /(?:[0-9a-f]{1,4}:){5}:[0-9a-f]{1,4}:#{IPV4_ADDR}/,
          /(?:[0-9a-f]{1,4}:){1,1}(?::[0-9a-f]{1,4}){1,4}:#{IPV4_ADDR}/,
          /(?:[0-9a-f]{1,4}:){1,2}(?::[0-9a-f]{1,4}){1,3}:#{IPV4_ADDR}/,
          /(?:[0-9a-f]{1,4}:){1,3}(?::[0-9a-f]{1,4}){1,2}:#{IPV4_ADDR}/,
          /(?:[0-9a-f]{1,4}:){1,4}(?::[0-9a-f]{1,4}){1,1}:#{IPV4_ADDR}/,
          /:(?::[0-9a-f]{1,4}){1,5}:#{IPV4_ADDR}/,
          /(?:(?:[0-9a-f]{1,4}:){1,5}|:):#{IPV4_ADDR}/,
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
        #
        # @since 1.0.0
        IP_ADDR = /#{IPV4_ADDR}|#{IPV6_ADDR}/

        # @see IP_ADDR
        IP = IP_ADDR

        # Regular expression used to find domain names in text
        #
        # @since 1.0.0
        DOMAIN = /(?:[a-zA-Z0-9]+(?:[_-][a-zA-Z0-9]+)*)+\.(?:#{Regexp.union(Resolv::TLDS)}(?=\s|$))/i

        # Regular expression used to find host-names in text
        HOST_NAME = /(?:[a-zA-Z0-9]+(?:[_-][a-zA-Z0-9]+)*\.)*#{DOMAIN}/i

        # Regular expression to match a word in the username of an email address
        USER_NAME = /[A-Za-z](?:[A-Za-z0-9]*[\._-])*[A-Za-z0-9]+/

        # Regular expression to find email addresses in text
        #
        # @since 1.0.0
        EMAIL_ADDRESS = /#{USER_NAME}\@#{HOST_NAME}/

        # @see EMAIL_ADDRESS
        EMAIL_ADDR = EMAIL_ADDRESS

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

        # Regular expression to find all variable names in text.
        #
        # @see IDENTIFIER
        #
        # @since 1.0.0
        VARIABLE_NAME = /#{IDENTIFIER}(?=\s*=\s*[^;\n]+)/

        # Regular expression to find all variable assignments in text.
        #
        # @see VARIABLE_NAME
        #
        # @since 1.0.0
        VARIABLE_ASSIGNMENT = /#{IDENTIFIER}\s*=\s*[^;\n]+/

        # Regular expression to find all function names in text.
        #
        # @see IDENTIFIER
        #
        # @since 1.0.0
        FUNCTION_NAME = /#{IDENTIFIER}(?=\()/

        # Regular expression to find all double quoted strings in text.
        #
        # @since 1.0.0
        DOUBLE_QUOTED_STRING = /"(\\.|[^"])*"/

        # Regular expression to find all single quoted strings in text.
        #
        # @since 1.0.0
        SINGLE_QUOTED_STRING = /'(\\[\\']|[^'])*'/

        # Regular expression to find all single or double quoted strings in
        # text.
        #
        # @since 1.0.0
        STRING = /#{DOUBLE_QUOTED_STRING}|#{SINGLE_QUOTED_STRING}/

        # Regular expression to find all Base64 encoded strings in the text.
        #
        # @since 1.0.0
        BASE64 = /(?:[A-Za-z0-9+\/]{4}\n?)+(?:[A-Za-z0-9+\/]{2}==\n?|[A-Za-z0-9+\/]{3}=\n?)?|[A-Za-z0-9+\/]{2}==\n?|[A-Za-z0-9+\/]{3}=\n?/

        # Regular expression to find File extensions in text
        #
        # @since 0.4.0
        FILE_EXT = /(?:\.[A-Za-z0-9]+)+/

        # Regular expression to find file names in text
        #
        # @since 0.4.0
        FILE_NAME = /(?:[^\/\\\. ]|\\[\/\\ ])+(?:#{FILE_EXT})?/

        # Regular expression to find Directory names in text
        #
        # @since 1.0.0
        DIR_NAME = /(?:\.\.|\.|#{FILE_NAME})/

        # Regular expression to find local UNIX Paths in text
        #
        # @since 0.4.0
        RELATIVE_UNIX_PATH = /(?:#{DIR_NAME}\/)+#{DIR_NAME}\/?/

        # Regular expression to find absolute UNIX Paths in text
        #
        # @since 0.4.0
        ABSOLUTE_UNIX_PATH = /(?:\/#{FILE_NAME})+\/?/

        # Regular expression to find UNIX Paths in text
        #
        # @since 0.4.0
        UNIX_PATH = /#{ABSOLUTE_UNIX_PATH}|#{RELATIVE_UNIX_PATH}/

        # Regular expression to find local Windows Paths in text
        #
        # @since 0.4.0
        RELATIVE_WINDOWS_PATH = /(?:#{DIR_NAME}\\)+#{DIR_NAME}\\?/

        # Regular expression to find absolute Windows Paths in text
        #
        # @since 0.4.0
        ABSOLUTE_WINDOWS_PATH = /[A-Za-z]:(?:\\#{FILE_NAME})+\\?/

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
    end
  end
end
