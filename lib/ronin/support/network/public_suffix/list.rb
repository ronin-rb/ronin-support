#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      module PublicSuffix
        #
        # Represents the [public suffix list].
        #
        # [public suffix list]: https://publicsuffix.org/
        #
        # @api public
        #
        # @since 1.0.0
        #
        class List

          include Enumerable

          # File name of the public suffix list.
          FILE_NAME = 'public_suffix_list.dat'

          # The `https://publicsuffix.org/list/public_suffix_list.dat` URL.
          URL = "https://publicsuffix.org/list/#{FILE_NAME}"

          # The path to `~/.local/share/ronin/ronin-support/public_suffix_list.dat` list file.
          PATH = File.join(Home::LOCAL_SHARE_DIR,'ronin','ronin-support',FILE_NAME)

          # The path to the list file.
          #
          # @return [String]
          attr_reader :path

          # The list of all public suffixes.
          #
          # @return [Array<String>]
          attr_reader :list

          # The tree of all public suffix TLDs.
          #
          # @return [Hash{String => Hash}]
          attr_reader :tree

          #
          # Initializes the public suffix list.
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
              end
            end
          end

          #
          # Loads the public suffix list from the given file.
          #
          # @param [String] path
          #   The path to the public suffix list file.
          #
          # @return [List]
          #   The parsed public suffix list file.
          #
          def self.load_file(path=PATH)
            list = new(path)

            File.open(path) do |file|
              file.each_line(chomp: true) do |line|
                next if (line.empty? || line.start_with?('//'))

                list << line
              end
            end

            return list
          end

          #
          # Adds a public suffix to the list.
          #
          # @param [String] suffix
          #   The suffix String to add.
          #
          # @return [self]
          #
          # @api private
          #
          def <<(suffix)
            @list << suffix

            if suffix.include?('.')
              tree = @tree

              suffix.split('.').reverse_each.each_cons(2) do |parent,child|
                subtree = tree[parent] ||= {}
                subtree[child] ||= nil

                tree = subtree
              end
            else
              @tree[suffix] ||= nil
            end

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
          # Splits a hostname into it's name and tld components.
          #
          # @param [String] host_name
          #   The host name to split.
          #
          # @return [(String, String)]
          #   The host name's name and tld components.
          #
          # @raise [InvalidHostname]
          #   The given hostname does not end with a valid suffix.
          #
          def split(host_name)
            host_name = host_name.dup
            suffix    = ""

            tree = @tree

            while tree
              name = if (index = host_name.rindex('.')) then host_name[index..]
                     else                                    host_name
                     end

              tld, subtree = tree.find do |tld,subtree|
                tld == '*' || name == ".#{tld}"
              end

              if tld
                host_name.chomp!(name)
                suffix.prepend(name)
              end

              tree = subtree
            end

            if suffix.empty?
              raise(InvalidHostname,"hostname does not have a valid suffix: #{host_name.inspect}")
            end

            return host_name, suffix
          end

          #
          # Creates a regular expression that can match every domain suffix in
          # the list.
          #
          # @return [Regexp]
          #
          def to_regexp
            regexp = Regexp.union(@tree.map { |tld,subtree|
              tld_regexp(tld,subtree)
            })

            return /(?<=[^a-zA-Z0-9_-]|^)#{regexp}(?=[^\.a-z0-9-]|$)/
          end

          #
          # Inspects the public suffix list.
          #
          # @return [String]
          #   The inspected list object.
          #
          def inspect
            "#<#{self.class}: #{@path}>"
          end

          private

          #
          # Create a regexp to match the given Top-Level-Domain (TLD) and all
          # sub-TLDs below it.
          #
          # @param [String] tld
          #   The Top-Level-Domain (TLD).
          #
          # @param [Hash{String => Hash}] subtree
          #   The other TLDs below the given TLD.
          #
          # @return [Regexp]
          #   The compiled regular expression.
          #
          def tld_regexp(tld,subtree)
            if subtree
              subtree_regexp = if subtree.length == 1
                                  tld_regexp(subtree.keys[0],subtree.values[0])
                                else
                                  Regexp.union(
                                    subtree.map { |sub_tld,sub_subtree|
                                      tld_regexp(sub_tld,sub_subtree)
                                    }
                                  )
                                end

              /(?:#{subtree_regexp}\.)?#{tld}/
            else
              if tld == '*'
                /[a-z0-9]+(?:-[a-z0-9]+)*/
              else
                tld
              end
            end
          end

        end
      end
    end
  end
end
