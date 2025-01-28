# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/exceptions'
require 'ronin/support/home'

require 'net/https'
require 'fileutils'

module Ronin
  module Support
    module Network
      module TLD
        #
        # Represents the [Top-Level Domains list].
        #
        # [Top-Level Domains list]: https://www.icann.org/resources/pages/tlds-2012-02-25-en
        #
        # @api public
        #
        # @since 1.0.0
        #
        class List

          include Enumerable

          # File name of the TLD list.
          FILE_NAME = 'tlds-alpha-by-domain.txt'

          # The `https://data.iana.org/TLD/tlds-alpha-by-domain.txt`
          URL = "https://data.iana.org/TLD/#{FILE_NAME}"

          # The path to `~/.cache/ronin/ronin-support/tlds-alpha-by-domain.txt` list file.
          PATH = File.join(Home::CACHE_DIR,'ronin','ronin-support',FILE_NAME)

          # The path to the list file.
          #
          # @return [String]
          attr_reader :path

          # The list of all TLDs.
          #
          # @return [Array<String>]
          attr_reader :list

          # The tree of all TLD TLDs.
          #
          # @return [Hash{String => Hash}]
          attr_reader :tree

          #
          # Initializes the TLD list.
          #
          # @param [String] path
          #   The path to the list file.
          #
          # @api private
          #
          def initialize(path=PATH)
            @path = path

            @list = []
            @tree = {}
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
          # Loads the TLD list from the given file.
          #
          # @param [String] path
          #   The path to the TLD list file.
          #
          # @return [List]
          #   The parsed TLD list file.
          #
          def self.load_file(path=PATH)
            list = new(path)

            File.open(path) do |file|
              file.each_line(chomp: true) do |line|
                next if line.start_with?('#')

                list << line.downcase
              end
            end

            return list
          end

          #
          # Adds a TLD to the list.
          #
          # @param [String] tld
          #   The TLD String to add.
          #
          # @return [self]
          #
          # @api private
          #
          def <<(tld)
            @list << tld
            return self
          end

          #
          # Enumerates over each suffix in the list.
          #
          # @yield [suffix]
          #   If a block is given, it will be passed each suffix in the list.
          #
          # @yieldparam [String] suffix
          #   A domain suffix in the list.
          #
          # @return [Enumerator]
          #   If no block is given, an Enumerator object will be returned.
          #
          def each(&block)
            @list.each(&block)
          end

          #
          # Splits a hostname into it's name and TLD components.
          #
          # @param [String] host_name
          #   The host name to split.
          #
          # @return [(String, String)]
          #   The host name's name and TLD components.
          #
          # @raise [InvalidHostname]
          #   The given hostname does not end with a valid TLD.
          #
          def split(host_name)
            unless (index = host_name.rindex('.'))
              raise(InvalidHostname,"hostname does not have a TLD: #{host_name.inspect}")
            end

            name = host_name[0...index]
            tld  = host_name[(index + 1)..]

            unless @list.include?(tld)
              raise(InvalidHostname,"hostname does not have a valid TLD: #{host_name.inspect}")
            end

            return name, tld
          end

          #
          # Creates a regular expression that can match every domain suffix in
          # the list.
          #
          # @return [Regexp]
          #
          def to_regexp
            regexp = Regexp.union(@list)

            return /(?<=[^a-zA-Z0-9_-]|^)#{regexp}(?=[^\.a-z0-9-]|$)/
          end

          #
          # Inspects the TLD list.
          #
          # @return [String]
          #   The inspected list object.
          #
          def inspect
            "#<#{self.class}: #{@path}>"
          end

        end
      end
    end
  end
end
