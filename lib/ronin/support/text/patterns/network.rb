# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/text/patterns/numeric'
require 'ronin/support/text/patterns/network/public_suffix'

module Ronin
  module Support
    module Text
      #
      # @since 0.3.0
      #
      module Patterns
        #
        # @group Networking Patterns
        #

        # Regular expression for finding MAC addresses in text
        #
        # @since 1.0.0
        MAC_ADDR = /[0-9a-fA-F]{2}(?::[0-9a-fA-F]{2}){5}/

        decimal_octet = /(?<=[^\d]|^)(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])(?=[^\d]|$)/

        # A regular expression for matching IPv4 Addresses.
        #
        # @since 1.0.0
        IPV4_ADDR = %r{#{decimal_octet}(?:\.#{decimal_octet}){3}(?:/\d{1,2})?}

        # A regular expression for matching IPv6 Addresses.
        #
        # @since 1.0.0
        IPV6_ADDR = %r{
          (?:[0-9a-f]{1,4}:){6}#{IPV4_ADDR}|
          (?:[0-9a-f]{1,4}:){5}[0-9a-f]{1,4}:#{IPV4_ADDR}|
          (?:[0-9a-f]{1,4}:){5}:[0-9a-f]{1,4}:#{IPV4_ADDR}|
          (?:[0-9a-f]{1,4}:){1,1}(?::[0-9a-f]{1,4}){1,4}:#{IPV4_ADDR}|
          (?:[0-9a-f]{1,4}:){1,2}(?::[0-9a-f]{1,4}){1,3}:#{IPV4_ADDR}|
          (?:[0-9a-f]{1,4}:){1,3}(?::[0-9a-f]{1,4}){1,2}:#{IPV4_ADDR}|
          (?:[0-9a-f]{1,4}:){1,4}(?::[0-9a-f]{1,4}){1,1}:#{IPV4_ADDR}|
          :(?::[0-9a-f]{1,4}){1,5}:#{IPV4_ADDR}|
          (?:(?:[0-9a-f]{1,4}:){1,5}|:):#{IPV4_ADDR}|
          (?:[0-9a-f]{1,4}:){1,1}(?::[0-9a-f]{1,4}){1,6}(?:/\d{1,3})?|
          (?:[0-9a-f]{1,4}:){1,2}(?::[0-9a-f]{1,4}){1,5}(?:/\d{1,3})?|
          (?:[0-9a-f]{1,4}:){1,3}(?::[0-9a-f]{1,4}){1,4}(?:/\d{1,3})?|
          (?:[0-9a-f]{1,4}:){1,4}(?::[0-9a-f]{1,4}){1,3}(?:/\d{1,3})?|
          (?:[0-9a-f]{1,4}:){1,5}(?::[0-9a-f]{1,4}){1,2}(?:/\d{1,3})?|
          (?:[0-9a-f]{1,4}:){1,6}(?::[0-9a-f]{1,4}){1,1}(?:/\d{1,3})?|
          [0-9a-f]{1,4}(?::[0-9a-f]{1,4}){7}(?:/\d{1,3})?|
          :(?::[0-9a-f]{1,4}){1,7}(?:/\d{1,3})?|
          (?:(?:[0-9a-f]{1,4}:){1,7}|:):(?:/\d{1,3})?
        }x

        # A regular expression for matching IP Addresses.
        #
        # @since 1.0.0
        IP_ADDR = /#{IPV4_ADDR}|#{IPV6_ADDR}/

        # @see IP_ADDR
        IP = IP_ADDR

        # Regular expression used to find domain names in text
        #
        # @since 1.0.0
        DOMAIN = /(?<=[^a-zA-Z0-9_-]|^)[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*\.#{PUBLIC_SUFFIX}(?=[^a-zA-Z0-9\._-]|$)/

        # Regular expression used to find host-names in text
        HOST_NAME = /(?<=[^a-zA-Z0-9\._-]|^)(?:[a-zA-Z0-9_-]{1,63}\.)*#{DOMAIN}/

        scheme           = "[a-zA-Z][\\-+.a-zA-Z\\d]*"
        reserved_chars   = ";/?:@&=+$,\\[\\]"
        unreserved_chars = "\\-_.!~*'()a-zA-Z\\d"
        escaped_char     = "%[a-fA-F\\d]{2}"
        user_info        = "(?:[#{unreserved_chars};:&=+$,]|#{escaped_char})*"
        reg_name         = "(?:[#{unreserved_chars}$,;:@&=+]|#{escaped_char})+"
        pchar            = "(?:[#{unreserved_chars}:@&=+$,]|#{escaped_char})"
        param            = "#{pchar}*"
        path_segment     = "#{pchar}*(?:;#{param})*"
        path_segments    = "#{path_segment}(?:/#{path_segment})*"
        abs_path         = "/#{path_segments}"
        char             = "(?:[#{unreserved_chars}#{reserved_chars}]|#{escaped_char})"
        query            = "#{char}*"
        fragment         = "#{char}*"

        # Regular expression to match URIs in text
        #
        # @since 1.0.0
        URI = %r{
          #{scheme}:                                         (?# 1: scheme)
          (?:
            //
            (?:
              (?:#{user_info}@)?                             (?# 1: userinfo)
              (?:#{HOST_NAME}|#{IPV4_ADDR}|\[#{IPV6_ADDR}\]) (?# 2: host)
              (?::\d*)?                                      (?# 3: port)
              |#{reg_name}                                   (?# 4: registry)
            )
          )?
          (?:#{abs_path})?                                   (?# 6: abs_path)
          (?:\?#{query})?                                    (?# 7: query)
          (?:\##{fragment})?                                 (?# 8: fragment)
        }x

        # Regular expression to match URLs in text
        #
        # @since 1.0.0
        URL = %r{
          #{scheme}:                                         (?# 1: scheme)
          (?:
            //
            (?:
              (?:#{user_info}@)?                             (?# 1: userinfo)
              (?:#{HOST_NAME}|#{IPV4_ADDR}|\[#{IPV6_ADDR}\]) (?# 2: host)
              (?::\d*)?                                      (?# 3: port)
              |#{reg_name}                                   (?# 4: registry)
            )
          )
          (?:#{abs_path})?                                   (?# 6: abs_path)
          (?:\?#{query})?                                    (?# 7: query)
          (?:\##{fragment})?                                 (?# 8: fragment)
        }x
      end
    end
  end
end
