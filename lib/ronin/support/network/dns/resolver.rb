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

require 'ronin/support/network/dns'

require 'resolv'

module Ronin
  module Support
    module Network
      module DNS
        #
        # Wraps around [Resolv::DNS].
        #
        # [Resolv::DNS]: https://rubydoc.info/stdlib/resolv/Resolv/DNS
        #
        # @api semipublic
        #
        class Resolver

          # The nameserver(s) to query.
          #
          # @return [Array<String>]
          attr_reader :nameservers

          #
          # Initializes the resolver.
          #
          # @param [Array<String>] nameservers
          #   The nameserver(s) to query.
          #
          def initialize(nameservers=self.class.default_nameservers)
            @nameservers = nameservers
            @resolver    = unless @nameservers.empty?
                             Resolv::DNS.new(nameserver: @nameservers)
                           else
                             Resolv::DNS.new
                           end
          end

          #
          # The system's nameserver(s) to use by default.
          #
          # @return [Array<String>]
          #   The nameserver(s) IP addresses.
          #
          def self.default_nameservers
            @default_nameservers ||= Resolv::DNS::Config.default_config_hash[:nameserver]
          end

          #
          # Queries the first IP address for the given host name.
          #
          # @param [String] host
          #   The host name to query.
          #
          # @return [String, nil]
          #   The first IP address for the host name or `nil` if the host name
          #   has no IP addresses.
          #
          def get_address(host)
            @resolver.getaddress(host).to_s
          rescue Resolv::ResolvError
          end

          #
          # Queries all IP addresses for the given host name.
          #
          # @param [String] host
          #   The host name to query.
          #
          # @return [Array<String>]
          #   The IP addresses for the host name.
          #
          def get_addresses(host)
            addresses = @resolver.getaddresses(host)
            addresses.map!(&:to_s)
            addresses
          end

          #
          # Reverse-queries the first host name for the given IP address.
          #
          # @param [String] ip
          #   The IP address to reverse lookup.
          #
          # @return [String, nil]
          #   The first host name associated with the given IP address or `nil`
          #   if no host names could be found for the IP address.
          #
          def get_name(ip)
            @resolver.getname(ip).to_s
          rescue Resolv::ResolvError
          end

          #
          # Reverse-queries all host names for the given IP address.
          #
          # @param [String] ip
          #   The IP address to reverse lookup.
          #
          # @return [Array<String>]
          #   The host names associated with the given IP address.
          #
          def get_names(ip)
            names = @resolver.getnames(ip)
            names.map!(&:to_s)
            names
          end

          #
          # Queries a single matching DNS record for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @param [Class<Resolv::DNS::Resource>] type
          #   The record type class.
          #
          # @return [Resolv::DNS::Resource, nil]
          #   The matching DNS records or `nil` if no matching DNS records
          #   could be found.
          #
          def get_record(name,type)
            @resolver.getresource(name,type)
          rescue Resolv::ResolvError
          end

          #
          # Queries all matching DNS records for the host name.
          #
          # @param [String] name
          #   The host name to query.
          #
          # @param [Class<Resolv::DNS::Resource>] type
          #   The record type class.
          #
          # @return [Array<Resolv::DNS::Resource>]
          #   All matching DNS records.
          #
          def get_records(name,type)
            @resolver.getresources(name,type)
          end

        end
      end
    end
  end
end
