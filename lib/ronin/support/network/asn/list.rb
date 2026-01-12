# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/asn/record'
require 'ronin/support/network/asn/record_set'
require 'ronin/support/network/ip_range/range'
require 'ronin/support/home'

require 'fileutils'
require 'net/https'
require 'zlib'

module Ronin
  module Support
    module Network
      module ASN
        #
        # Represents the entire list of all IPv4 and IPv6 ASNs.
        #
        # @api public
        #
        # @since 1.0.0
        #
        class List < RecordSet

          include Enumerable

          # File name of the combined IPv4 and IPv6 ASN list file.
          FILE_NAME = 'ip2asn-combined.tsv.gz'

          # The `https://iptoasn.com/data/ip2asn-combined.tsv.gz` URL.
          URL = "https://iptoasn.com/data/#{FILE_NAME}"

          # The path to `~/.local/share/ronin/ronin-support/ip2asn-combined.tsv.gz` list file.
          PATH = File.join(Home::CACHE_DIR,'ronin','ronin-support',FILE_NAME)

          # The path to the list file.
          #
          # @return [String]
          attr_reader :path

          #
          # Initializes the list file.
          #
          # @param [String] path
          #   The path to the list file.
          #
          # @api private
          #
          def initialize(path)
            super()

            @path = path

            @ipv4_prefixes = {}
            @ipv6_prefixes = {}
          end

          #
          # Determines whether the list file has been previously downloaded.
          #
          # @param [String] path
          #   An optional alternate path to the list file.
          #
          # @return [Boolean]
          #
          def self.downloaded?(path=PATH)
            File.file?(path)
          end

          # One day in seconds.
          ONE_DAY = 60 * 60 * 24

          #
          # Determines if the downloaded list file is older than one day.
          #
          # @param [String] path
          #   An optional alternate path to the list file.
          #
          # @return [Boolean]
          #
          def self.stale?(path=PATH)
            !File.file?(path) || File.stat(path).mtime < (Time.now - ONE_DAY)
          end

          #
          # Downloads the list file.
          #
          # @param [String] url
          #   An optional alternate URL to download the `ip2asn-combined.tsv.gz`
          #   file.
          #
          # @param [String] path
          #   An optional alternate path to the list file.
          #
          def self.download(url: URL, path: PATH)
            uri = URI(url)

            Net::HTTP.start(uri.host,uri.port, use_ssl: true) do |http|
              request  = Net::HTTP::Get.new(uri.path)

              http.request(request) do |response|
                FileUtils.mkdir_p(File.dirname(path))

                File.open("#{path}.part",'wb') do |file|
                  response.read_body do |chunk|
                    file.write(chunk)
                  end
                end

                FileUtils.mv("#{path}.part",path)
              end
            end
          end

          #
          # Optionally update the cached list file if it is older than one day.
          #
          # @param [String] url
          #   An optional alternate URL to download the `ip2asn-combined.tsv.gz`
          #   file.
          #
          # @param [String] path
          #   An optional alternate path to the list file.
          #
          def self.update(url: URL, path: PATH)
            if !downloaded?(path)
              download(url: url, path: path)
            elsif stale?(path)
              begin
                download(url: url, path: path)
              rescue
                # ignore any network failures
              end
            end
          end

          #
          # Parses the contents of the list file.
          #
          # @param [String] path
          #   An optional alternate path to the list file.
          #
          # @yield [record]
          #   If a block is given, it will be passed each parsed record from the
          #   list file.
          #
          # @yieldparam [Record] record
          #   A parsed record in the list file.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumerator object will be returned.
          #
          def self.parse(path=PATH)
            return enum_for(__method__,path) unless block_given?

            io = if File.extname(path) == '.gz' then Zlib::GzipReader.open(path)
                 else                                File.new(path)
                 end

            io.each_line do |line|
              line.chomp!

              first, last, number, country_code, name = line.split("\t",5)

              range  = IPRange::Range.new(first,last)
              number = number.to_i

              country_code = nil if country_code == 'None'
              name         = nil if name         == 'Not routed'

              yield Record.new(number,range,country_code,name)
            end
          end

          #
          # Loads the contents of the list file into memory.
          #
          # @param [String] path
          #   An optional alternate path to the list file.
          #
          # @return [List]
          #   The loaded list.
          #
          def self.load_file(path=PATH)
            list = new(path)

            parse(path) do |record|
              list << record
            end

            return list
          end

          #
          # Adds a record to the list.
          #
          # @param [Record] record
          #
          # @return [self]
          #
          # @api private
          #
          def <<(record)
            super(record)

            prefixes = if record.range.ipv6? then @ipv6_prefixes
                       else                       @ipv4_prefixes
                       end

            records = (prefixes[record.range.prefix] ||= [])
            records << record
            return self
          end

          #
          # Finds the ASN record for the given IP address.
          #
          # @param [IP, IPaddr, String] ip
          #   The IP address to search for.
          #
          # @return [Record, nil]
          #   The ASN record for the IP address or `nil` if none could be found.
          #
          def ip(ip)
            address = ip.to_s
            ip      = IPAddr.new(ip) unless ip.kind_of?(IPAddr)

            prefixes = if ip.ipv6? then @ipv6_prefixes
                       else             @ipv4_prefixes
                       end

            prefixes.each do |prefix,records|
              if address.start_with?(prefix)
                records.each do |record|
                  if record.include?(ip)
                    return record
                  end
                end
              end
            end

            return nil
          end

          #
          # Inspects the list.
          #
          # @return [String]
          #
          def inspect
            "#<#{self.class}: #{@path}>"
          end

        end
      end
    end
  end
end
