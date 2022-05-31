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

require 'ronin/support/compression/zip/reader/entry'
require 'ronin/support/compression/zip/reader/statistics'

require 'date'

module Ronin
  module Support
    module Compression
      module Zip
        #
        # Handles reading zip archives.
        #
        # @note
        #   This provides a simple interface for reading zip archives using
        #   the `unzip` command. If you need something more powerful, use the
        #   [archive-zip] gem instead.
        #
        # [archive-zip]: https://github.com/javanthropus/archive-zip
        #
        # @api public
        #
        # @since 1.0.0
        #
        class Reader

          include Enumerable

          # The path to the zip archive that will be read.
          #
          # @return [String]
          attr_reader :path

          # The optional password to use when reading the zip archive.
          #
          # @return [String, nil]
          attr_reader :password

          #
          # Initializes the zip archive reader.
          #
          # @param [String] path
          #   The path to the zip archive file.
          #
          # @param [String, nil] password
          #   Optional password to use when reading the zip archive.
          #
          # @yield [zip]
          #   If a block is given, it will be yielded the new zip reader.
          #
          # @yieldparam [Reader] zip
          #   The new zip reacher.
          #
          def initialize(path, password: nil)
            @path     = File.expand_path(path)
            @password = password

            yield self if block_given?
          end

          #
          # Alias to `new`.
          #
          # @see #initialize
          #
          def self.open(path,&block)
            new(path,&block)
          end

          #
          # Lists the contents of the zip archive.
          #
          # @yield [entry]
          #   If a block is given it will be passed each parsed entry in the
          #   zip archive.
          #
          # @yieldparam [Entry] entry
          #   An entry in the zip archive.
          #
          # @return [Enumerator, Statistics]
          #   If no block is given an enumerator will be returned.
          #   If a block was given, then a statistics object will be returned.
          #
          # @note
          #   This method actually executes the `unzip -v -l ZIP` command
          #   and parses it's output.
          #
          def each
            return enum_for(__method__) unless block_given?

            io = IO.popen(command_argv('-v','-l',@path))

            # skip lines until the "---------  ---------- -----   ----" line
            until io.eof?
              break if io.readline.start_with?('-')
            end

            until io.eof?
              line = io.readline(chomp: true)

              unless line.start_with?('-')
                yield parse_entry_line(line)
              else
                # reached the "---------                     -------" line
                break
              end
            end

            last_line = io.readline(chomp: true)
            return parse_statistics_line(last_line)
          end

          alias list each
          alias entries to_a

          #
          # Finds the entry with the given name.
          #
          # @param [String]
          #   The file name to search for.
          #
          # @return [Entry, nil]
          #   The matching entry or `nil` if no entry could be found.
          #
          def [](name)
            find { |entry| entry.name == name }
          end

          #
          # Reads the contents of an entry from the zip archive.
          #
          # @param [String] name
          #   The name of the entry to read.
          #
          # @param [Integer, nil] length
          #   Optional number of bytes to read.
          #
          # @return [String]
          #   The read data.
          #
          # @note
          #   This method actually executes the `unzip -p ZIP FILE` command
          #   and reads it's output.
          #
          def read(name, length: nil)
            io = IO.popen(command_argv('-p', @path, name))

            if length then io.read(length)
            else           io.read
            end
          end

          private
          
          #
          # Creates an `unzip` command with the additional arguments.
          #
          # @param [Array<String>] arguments
          #   Additional arguments for the `unzip` command.
          #
          # @return [Array<String>]
          #   The `unzip` command argv.
          #
          def command_argv(*arguments)
            argv = ['unzip']

            if @password
              argv << '-P' << @password
            end

            argv.concat(arguments)
          end

          # Translates the Method column in `unzip -v -l` output to Symbols.
          METHODS = {
            'Stored' => :stored,
            'Defl:N' => :deflate
          }

          #
          # Parses a entry line from the output of `unzip -v -l ZIP`.
          #
          # @param [String] line
          #   The line to parse.
          #
          # @return [Entry]
          #   The parsed entry.
          #
          def parse_entry_line(line)
            length, method, size, compression, date, time, crc32, name =
              line.lstrip.split(/\s+/,8)

            length      = length.to_i
            method      = METHODS.fetch(method)
            size        = size.to_i
            compression = compression.chomp('%').to_i
            date        = Date.strptime(date,"%m-%d-%Y")
            time        = DateTime.parse("#{date} #{time}")

            return Entry.new(self, length:      length.to_i,
                                   method:      method,
                                   size:        size,
                                   compression: compression,
                                   date:        date,
                                   time:        time,
                                   crc32:       crc32,
                                   name:        name)
          end

          #
          # Parses the last line from the output of `unzip -v -l ZIP`.
          #
          # @param [String] line
          #   The line to parse.
          #
          # @return [Statistics]
          #   The parsed statistics.
          #
          def parse_statistics_line(line)
            length, size, compression, files, _ = line.lstrip.split(/\s+/,5)

            return Statistics.new(
              length:      length.to_i,
              size:        size.to_i,
              compression: compression.chomp('%').to_i,
              files:       files.to_i
            )
          end

        end
      end
    end
  end
end
