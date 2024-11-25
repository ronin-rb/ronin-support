# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/defang'

module Ronin
  module Support
    module Network
      module Defang
        #
        # Provides helper methods for defanging or refanging URLs, IP addresses,
        # or host names.
        #
        # @api public
        #
        # @since 1.2.0
        #
        module Mixin
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
          #   defang_ip("192.168.1.1")
          #   # => "192[.]168[.]1[.]1"
          #
          def defang_ip(ip)
            Defang.defang_ip(ip)
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
          #   refang_ip("192[.]168[.]1[.]1")
          #   # => "192.168.1.1"
          #
          def refang_ip(ip)
            Defang.refang_ip(ip)
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
          #   defang_host("www.example.com")
          #   # => "www[.]example[.]com"
          #
          def defang_host(host)
            Defang.defang_host(host)
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
          #   refang_host("www[.]example[.]com")
          #   # => "www.example.com"
          #
          def refang_host(host)
            Defang.refang_host(host)
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
          #   defang_url("https://www.example.com:8080/foo?q=1")
          #   # => "hxxps[://]www[.]example[.]com[:]8080/foo?q=1"
          #
          def defang_url(url)
            Defang.defang_url(url)
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
          #   refang_url("hxxps[://]www[.]example[.]com[:]8080/foo?q=1")
          #   # => "https://www.example.com:8080/foo?q=1"
          #
          def refang_url(url)
            Defang.refang_url(url)
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
          #   defang("https://www.example.com:8080/foo?q=1")
          #   # => "hxxps[://]www[.]example[.]com[:]8080/foo?q=1"
          #   defang("192.168.1.1")
          #   # => "192[.]168[.]1[.]1"
          #   defang("www.example.com")
          #   # => "www[.]example[.]com"
          #
          def defang(string)
            Defang.defang(string)
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
          #   refang("hxxps[://]www[.]example[.]com[:]8080/foo?q=1")
          #   # => "https://www.example.com:8080/foo?q=1"
          #   refang("192[.]168[.]1[.]1")
          #   # => "192.168.1.1"
          #   refang("www[.]example[.]com")
          #   # => "www.example.com"
          #
          def refang(string)
            Defang.refang(string)
          end
        end
      end
    end
  end
end
