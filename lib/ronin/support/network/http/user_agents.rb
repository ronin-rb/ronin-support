# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Support
    module Network
      class HTTP
        #
        # Contains built-in `User-Agent` strings for {HTTP}.
        #
        # @api semipublic
        #
        # @since 1.0.0
        #
        module UserAgents
          # Built-in `User-Agent` strings for impersonating various browsers.
          ALIASES = {
            chrome_linux: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36',
            chrome_macos: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36',
            chrome_windows: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36',
            chrome_iphone: 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/102.0.5005.87 Mobile/15E148 Safari/604.1',
            chrome_ipad: 'Mozilla/5.0 (iPad; CPU OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/102.0.5005.87 Mobile/15E148 Safari/604.1',
            chrome_android: 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.99 Mobile Safari/537.36',

            firefox_linux: 'Mozilla/5.0 (Linux x86_64; rv:101.0) Gecko/20100101 Firefox/101.0',
            firefox_macos: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 12.4; rv:101.0) Gecko/20100101 Firefox/101.0',
            firefox_windows: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0',
            firefox_iphone: 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/101.0 Mobile/15E148 Safari/605.1.15',
            firefox_ipad: 'Mozilla/5.0 (iPad; CPU OS 12_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/101.0 Mobile/15E148 Safari/605.1.15',

            firefox_android: 'Mozilla/5.0 (Android 12; Mobile; rv:68.0) Gecko/68.0 Firefox/101.0',

            safari_macos: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15',
            safari_iphone: 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1',
            safari_ipad: 'Mozilla/5.0 (iPad; CPU OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1',

            edge: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36 Edg/102.0.1245.33'
          }

          #
          # Returns a `User-Agent` string for the given ID.
          #
          # @param [:random, :chrome, :chrome_linux, :chrome_macos,
          #         :chrome_windows, :chrome_iphone, :chrome_ipad,
          #         :chrome_android, :firefox, :firefox_linux, :firefox_macos,
          #         :firefox_windows, :firefox_iphone, :firefox_ipad,
          #         :firefox_android, :safari, :safari_macos, :safari_iphone,
          #         :safari_ipad, :edge, :linux, :macos, :windows, :iphone,
          #         :ipad, :android] id
          #   The new `User-Agent` string to use. The acceptable values are:
          #   * `:random` - a random value from {ALIASES} will be returned.
          #   * `:chrome` - a random Chrome `User-Agent` from {ALIASES} will be
          #     returned.
          #   * `:firefox` - a random Firefox `User-Agent` from {ALIASES} will
          #     be returned.
          #   * `:safari` - a random Safari `User-Agent` from {ALIASES} will be
          #     returned.
          #   * `:linux` - a random Linux `User-Agent` from {ALIASES} will be
          #     returned.
          #   * `:macos` - a random macOS `User-Agent` from {ALIASES} will be
          #     returned.
          #   * `:windows` - a random Windows `User-Agent` from {ALIASES} will
          #     be returned.
          #   * `:iphone` - a random iPhone `User-Agent` from {ALIASES} will
          #     be returned.
          #   * `:ipad` - a random iPad `User-Agent` from {ALIASES} will
          #     be returned.
          #   * `:android` - a random Android `User-Agent` from {ALIASES} will
          #     be returned.
          #   * Otherwise, the `User-Agent` String in {ALIASES} with the
          #     matching ID will be returned.
          #
          # @return [String]
          #   The `User-Agent` string for the given `id`.
          #
          # @raise [ArgumentError]
          #   The given `User-Agent` ID was not a known ID or wasn't a Symbol.
          #
          def self.[](id)
            case id
            when :random
              ALIASES.values.sample
            when :chrome, :firefox, :safari # prefix
              ALIASES.select { |k,v| k =~ /^#{id}_/ }.values.sample
            when :linux, :macos, :windows,
                 :iphone, :ipad, :android # suffix
              ALIASES.select { |k,v| k =~ /_#{id}$/ }.values.sample
            when Symbol
              ALIASES.fetch(id) do
                raise(ArgumentError,"unknown user agent alias: #{id.inspect}")
              end
            else
              raise(ArgumentError,"User-Agent ID must be a Symbol")
            end
          end
        end
      end
    end
  end
end
