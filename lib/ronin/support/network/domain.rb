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

require 'ronin/support/network/host'

module Ronin
  module Support
    module Network
      #
      # Represents a domain.
      #
      # ## Examples
      #
      #     domain = Domain.new('github.com')
      #     domain.ips
      #     # => [#<Ronin::Support::Network::IP: 192.30.255.113>]
      #     domain.ip
      #     # => #<Ronin::Support::Network::IP: 192.30.255.113>
      #     domain.mailservers
      #     # => ["aspmx.l.google.com",
      #     #     "alt3.aspmx.l.google.com",
      #     #     "alt4.aspmx.l.google.com",
      #     #     "alt1.aspmx.l.google.com",
      #     #     "alt2.aspmx.l.google.com"]
      #     domain.nameservers
      #     # => ["dns1.p08.nsone.net",
      #     #     "dns2.p08.nsone.net",
      #     #     "dns3.p08.nsone.net",
      #     #     "dns4.p08.nsone.net",
      #     #     "ns-1283.awsdns-32.org",
      #     #     "ns-1707.awsdns-21.co.uk",
      #     #     "ns-421.awsdns-52.com",
      #     #     "ns-520.awsdns-01.net"]
      #     domain.txt_strings
      #     # => ["v=spf1 ip4:192.30.252.0/22 include:_netblocks.google.com include:_netblocks2.google.com include:_netblocks3.google.com include:spf.protection.outlook.com include:mail.zendesk.com include:_spf.salesforce.com include:servers.mcsv.net ip4:166.78.69.169 ip4:1",
      #     #     "66.78.69.170 ip4:166.78.71.131 ip4:167.89.101.2 ip4:167.89.101.192/28 ip4:192.254.112.60 ip4:192.254.112.98/31 ip4:192.254.113.10 ip4:192.254.113.101 ip4:192.254.114.176 ip4:62.253.227.114 ~all",
      #     #     "MS=6BF03E6AF5CB689E315FB6199603BABF2C88D805",
      #     #     "MS=ms44452932",
      #     #     "atlassian-domain-verification=jjgw98AKv2aeoYFxiL/VFaoyPkn3undEssTRuMg6C/3Fp/iqhkV4HVV7WjYlVeF8",
      #     #     "stripe-verification=f88ef17321660a01bab1660454192e014defa29ba7b8de9633c69d6b4912217f",
      #     #     "google-site-verification=UTM-3akMgubp6tQtgEuAkYNYLyYAvpTnnSrDMWoDR3o",
      #     #     "MS=ms58704441",
      #     #     "docusign=087098e3-3d46-47b7-9b4e-8a23028154cd",
      #     #     "adobe-idp-site-verification=b92c9e999aef825edc36e0a3d847d2dbad5b2fc0e05c79ddd7a16139b48ecf4b",
      #     #     "apple-domain-verification=RyQhdzTl6Z6x8ZP4"]
      #
      # @api public
      #
      # @since 1.0.0
      #
      class Domain < Host
      end
    end
  end
end
