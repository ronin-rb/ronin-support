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

require_relative 'url'
require_relative 'ip'

module Ronin
  module Support
    module Network
      #
      # Handles defanging and refanging IP addresses, host names, or URLs.
      #
      # ## Core-Ext Methods
      #
      # * {String#refang}
      # * {IPAddr#defang}
      # * {URI::HTTP#defang}
      #
      # @api public
      #
      # @since 1.2.0
      #
      module Defang
        #
        # Defangs an IP address.
        #
        # @param [#to_s] ip
        #   The IP address to defang.
        #
        # @return [String]
        #   The defanged IP address.
        #
        # @example
        #   Defang.defang_ip("192.168.1.1")
        #   # => "192[.]168[.]1[.]1"
        #
        def self.defang_ip(ip)
          ip.to_s.gsub(/(?:\.|:{1,2})/) do |separator|
            "[#{separator}]"
          end
        end

        #
        # Refangs a de-fanged IP address.
        #
        # @param [String] ip
        #   The de-fanged IP address.
        #
        # @return [String]
        #   The refanged IP address.
        #
        # @example
        #   Defang.refang_ip("192[.]168[.]1[.]1")
        #   # => "192.168.1.1"
        #
        def self.refang_ip(ip)
          ip.gsub(/\[(?:\.|:{1,2})\]/) do |separator|
            separator[1..-2]
          end
        end

        #
        # Defangs the host name.
        #
        # @param [#to_s] host
        #   The host name to defang.
        #
        # @return [String]
        #   The defanged host name.
        #
        # @example
        #   Defang.defang_host("www.example.com")
        #   # => "www[.]example[.]com"
        #
        def self.defang_host(host)
          host.to_s.gsub('.','[.]')
        end

        #
        # Refangs a de-fanged host name.
        #
        # @param [String] host
        #   The de-fanged host name to refang.
        #
        # @return [String]
        #   The refanged host name.
        #
        # @example
        #   Defang.refang_host("www[.]example[.]com")
        #   # => "www.example.com"
        #
        def self.refang_host(host)
          host.gsub('[.]') do |separator|
            separator[1..-2]
          end
        end

        #
        # Defangs a URL.
        #
        # @param [#to_s] url
        #   The URL to defang.
        #
        # @return [String]
        #   The defanged URL.
        #
        # @example
        #   Defang.defang_url("https://www.example.com:8080/foo?q=1")
        #   # => "hxxps[://]www[.]example[.]com[:]8080/foo?q=1"
        #
        def self.defang_url(url)
          url.to_s.sub(%r{^[^:]+://[^/]+}) do |scheme_and_authority|
            scheme, authority = scheme_and_authority.split('://',2)

            scheme.sub!(/^htt/,'hxx')
            authority.gsub!(/(?:\.|:{1,2})/) do |separator|
              "[#{separator}]"
            end

            "#{scheme}[://]#{authority}"
          end
        end

        #
        # Refangs a defanged URL.
        #
        # @param [String] url
        #   The defanged URL.
        #
        # @return [String]
        #   The refanged URL.
        #
        # @example
        #   Defang.refang_url("hxxps[://]www[.]example[.]com[:]8080/foo?q=1")
        #   # => "https://www.example.com:8080/foo?q=1"
        #
        def self.refang_url(url)
          url.sub(%r{^[^:]+(?:\[://\]|://)[^/]+}) do |scheme_and_authority|
            scheme, authority = scheme_and_authority.split(%r{\[://\]|://},2)

            scheme.sub!(/^hxx/,'htt')
            authority.gsub!(/\[(?:\.|:{1,2})\]/) do |separator|
              separator[1..-2]
            end

            "#{scheme}://#{authority}"
          end
        end

        #
        # Defangs a URL, IP address, or host name.
        #
        # @param [String] string
        #   The URL, IP address, or host name.
        #
        # @return [String]
        #   The defanged URL, IP address, or host name.
        #
        # @example
        #   Defang.defang("https://www.example.com:8080/foo?q=1")
        #   # => "hxxps[://]www[.]example[.]com[:]8080/foo?q=1"
        #   Defang.defang("192.168.1.1")
        #   # => "192[.]168[.]1[.]1"
        #   Defang.defang("www.example.com")
        #   # => "www[.]example[.]com"
        #
        def self.defang(string)
          case string
          when IP::REGEX  then defang_ip(string)
          when URL::REGEX then defang_url(string)
          else                 defang_host(string)
          end
        end

        #
        # Refangs a defanged URL, IP address, or host name.
        #
        # @param [String] string
        #   The defanged URL, IP address, or host name.
        #
        # @return [String]
        #   The refanged URL, IP address, or host name.
        #
        # @example
        #   Defang.refang("hxxps[://]www[.]example[.]com[:]8080/foo?q=1")
        #   # => "https://www.example.com:8080/foo?q=1"
        #   Defang.refang("192[.]168[.]1[.]1")
        #   # => "192.168.1.1"
        #   Defang.refang("www[.]example[.]com")
        #   # => "www.example.com"
        #
        def self.refang(string)
          case string
          when %r{^hxxp(s)?(?:://|\[://\])}
            refang_url(string)
          when /^(?:(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\[\.\]|[0-9a-f]{1,4}\[:{1,2}\])/
            refang_ip(string)
          else
            refang_host(string)
          end
        end
      end
    end
  end
end

require 'ronin/support/network/defang/core_ext'
