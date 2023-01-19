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

require 'ronin/support/network/exceptions'

module Ronin
  module Support
    module Network
      #
      # Represents an email address.
      #
      # ## Features
      #
      # * Supports normalizing tagged emails.
      # * Supports {EmailAddress.deobfuscate deobfuscating} email addresses.
      # * Supports {EmailAddress#obfuscate obfuscating} email addresses.
      #
      # ## Examples
      #
      # Builds a new email address:
      #
      #     email = EmailAddress.new(mailbox: 'john.smith', domain: 'example.com')
      #
      # Parses an email address:
      #
      #     email = EmailAddress.parse("John Smith <john.smith@example.com>")
      #     # => #<Ronin::Support::Network::EmailAddress:0x00007f49586d6a20
      #           @address=nil,
      #           @domain="example.com",
      #           @mailbox="john.smith",
      #           @name="John Smith",
      #           @routing=nil,
      #           @tag=nil>
      #
      # Deobfuscate an obfuscated email address:
      #
      #     EmailAddress.deobfuscate("john[dot]smith [at] example[dot]com")
      #     # => "john.smith@example.com"
      #
      # Obfuscate an email address:
      #
      #     email = EmailAddress.parse("john.smith@example.com")
      #     email.obfuscate
      #     # => "john <dot> smith <at> example <dot> com"
      #
      # Get every obfuscation of an email address:
      #
      #      email.obfuscations
      #      # => ["john.smith AT example.com",
      #      #     "john.smith at example.com",
      #      #     "john.smith[AT]example.com",
      #      #     "john.smith[at]example.com",
      #      #     "john.smith [AT] example.com",
      #      #     "john.smith [at] example.com",
      #      #     "john.smith<AT>example.com",
      #      #     "john.smith<at>example.com",
      #      #     "john.smith <AT> example.com",
      #      #     "john.smith <at> example.com",
      #      #     "john.smith{AT}example.com",
      #      #     "john.smith{at}example.com",
      #      #     "john.smith {AT} example.com",
      #      #     "john.smith {at} example.com",
      #      #     "john.smith(AT)example.com",
      #      #     "john.smith(at)example.com",
      #      #     "john.smith (AT) example.com",
      #      #     "john.smith (at) example.com",
      #      #     "john DOT smith AT example DOT com",
      #      #     "john dot smith at example dot com",
      #      #     "john[DOT]smith[AT]example[DOT]com",
      #      #     "john[dot]smith[at]example[dot]com",
      #      #     "john [DOT] smith [AT] example [DOT] com",
      #      #     "john [dot] smith [at] example [dot] com",
      #      #     "john<DOT>smith<AT>example<DOT>com",
      #      #     "john<dot>smith<at>example<dot>com",
      #      #     "john <DOT> smith <AT> example <DOT> com",
      #      #     "john <dot> smith <at> example <dot> com",
      #      #     "john{DOT}smith{AT}example{DOT}com",
      #      #     "john{dot}smith{at}example{dot}com",
      #      #     "john {DOT} smith {AT} example {DOT} com",
      #      #     "john {dot} smith {at} example {dot} com",
      #      #     "john(DOT)smith(AT)example(DOT)com",
      #      #     "john(dot)smith(at)example(dot)com",
      #      #     "john (DOT) smith (AT) example (DOT) com",
      #      #     "john (dot) smith (at) example (dot) com"]
      #
      # @see https://datatracker.ietf.org/doc/html/rfc2822#section-3.4
      #
      # @api public
      #
      # @since 1.0.0
      #
      class EmailAddress

        # The optional name associated with the email address
        # (ex: `John Smith <john.smith@example.com`).
        #
        # @return [String, nil]
        attr_reader :name

        # The mailbox or username of the email address.
        #
        # @return [String]
        attr_reader :mailbox

        alias username mailbox

        # The optional sorting tag of the email address
        # (ex: `john.smith+tag@example.com`).
        #
        # @return [String, nil]
        attr_reader :tag

        # Additional hosts to route sent emails through; aka the "percent hack"
        # (ex: `john.smith%host3.com%host2.com@host1.com`).
        #
        # @return [Array<String>, nil]
        attr_reader :routing

        # The domain of the email address (ex: `john.smith@example.com`).
        #
        # @return [String, nil]
        attr_reader :domain

        # The IP address of the email address (ex: `john.smith@[1.2.3.4]`).
        #
        # @return [String, nil]
        attr_reader :address

        #
        # Initializes the email address.
        #
        # @param [String, nil] name
        #   The optional name associated with the email address
        #   (ex: `John Smith <john.smith@example.com`).
        #
        # @param [String] mailbox
        #   The mailbox or username of the email address.
        #
        # @param [String, nil] tag
        #   The optional sorting tag of the email address
        #   (ex: `john.smith+tag@example.com`).
        #
        # @param [Array<String>, nil] routing
        #   Additional hosts to route sent emails through; aka the
        #   "percent hack" (ex: `john.smith%host3.com%host2.com@host1.com`).
        #
        # @param [String, nil] domain
        #   The domain of the email address (ex: `john.smith@example.com`).
        #
        # @param [String, nil] address
        #   The IP address of the email address (ex: `john.smith@[1.2.3.4]`).
        #
        # @raise [ArgumentError]
        #   Must specify either the `domain:` or `address:` keyword arguments.
        #
        # @example Initializing a basic email address.
        #   email = EmailAddress.new(mailbox: 'john.smith', domain: 'example.com')
        #
        # @example Initializing an email address with a name:
        #   email = EmailAddress.new(name: 'John Smith', mailbox: 'john.smith', domain: 'example.com')
        #
        # @example Initializing an email address with a sorting tag:
        #   email = EmailAddress.new(mailbox: 'john.smith', tag: 'spam', domain: 'example.com')
        #
        def initialize(name: nil, mailbox: , tag: nil, routing: nil, domain: nil, address: nil)
          @name    = name
          @mailbox = mailbox
          @tag     = tag
          @routing = routing

          unless (domain.nil? ^ address.nil?)
            raise(ArgumentError,"must specify domain: or address: keyword arguments")
          end

          @domain  = domain
          @address = address
        end

        #
        # Parses an email address.
        #
        # @param [String] string
        #   The email string to parse.
        #
        # @return [EmailAddress]
        #   The parsed email address.
        #
        # @raise [InvalidEmailAddress]
        #   The string is not a valid formatted email address.
        #
        # @example
        #   email = EmailAddress.parse("John Smith <john.smith@example.com>")
        #   # => #<Ronin::Support::Network::EmailAddress:0x00007f49586d6a20
        #         @address=nil,
        #         @domain="example.com",
        #         @mailbox="john.smith",
        #         @name="John Smith",
        #         @routing=nil,
        #         @tag=nil>
        #
        # @see https://datatracker.ietf.org/doc/html/rfc2822#section-3.4
        #
        def self.parse(string)
          if string.include?('<') && string.end_with?('>')
            # Name <local-part@domain.com>
            if (match = string.match(/^([^<]+)\s+<([^>]+)>$/))
              name    = match[1]
              address = match[2]
            else
              raise(InvalidEmailAddress,"invalid email address: #{string.inspect}")
            end
          else
            name    = nil
            address = string
          end

          return new(name: name, **parse_address(address))
        end

        private

        #
        # Parses the address portion of an email address.
        #
        # @param [String] string
        #   the email address string to parse.
        #
        # @return [Hash{Symbol => Object}]
        #   Keyword arguments for {#initialize}.
        #
        # @raise [InvalidEmailAddress]
        #   The string did not contain a `@` character.
        #
        # @api private
        #
        def self.parse_address(string)
          unless string.include?('@')
            raise(InvalidEmailAddress,"invalid email address: #{string.inspect}")
          end

          # local-part@domain.com
          local_part, domain = string.split('@',2)

          return {**parse_local_part(local_part), **parse_domain(domain)}
        end

        #
        # Parses the local-part portion of an email address.
        #
        # @param [String] string
        #   the local-part string to parse.
        #
        # @return [Hash{Symbol => Object}]
        #   Keyword arguments for {#initialize}.
        #
        # @api private
        #
        def self.parse_local_part(string)
          routing = nil

          if string.include?('%')
            mailbox, *routing = string.split('%')
          else
            mailbox = string
            routing = nil
          end

          return {routing: routing, **parse_mailbox(mailbox)}
        end

        #
        # Parses the mailbox portion of an email address.
        #
        # @param [String] string
        #   The mailbox string to parse.
        #
        # @return [Hash{Symbol => Object}]
        #   Keyword arguments for {#initialize}.
        #
        # @api private
        #
        def self.parse_mailbox(string)
          # extract any sorting-tags (ex: `user+service@domain.com`)
          mailbox, tag = string.split('+',2)

          return {mailbox: mailbox, tag: tag}
        end

        #
        # Parses the domain portion of an email address.
        #
        # @param [String] string
        #   The domain portion to parse.
        #
        # @return [Hash{Symbol => Object}]
        #   Keyword arguments for {#initialize}.
        #
        # @api private
        #
        def self.parse_domain(string)
          domain  = nil
          address = nil

          # extract IP addresses from the domain part (ex: `user@[1.2.3.4]`)
          if string.start_with?('[') && string.end_with?(']')
            address = string[1..-2]
          else
            domain  = string
          end

          return {domain: domain, address: address}
        end

        public

        # Email address de-obfuscation rules.
        DEOBFUSCATIONS = {
          /\s+@\s+/                 => '@',
          /\s+(?:at|AT)\s+/         => '@',
          /\s+(?:dot|DOT)\s+/       => '.',
          /\s*\[(?:at|AT)\]\s*/     => '@',
          /\s*\[(?:dot|DOT)\]\s*/   => '.',
          /\s*\<(?:at|AT)\>\s*/     => '@',
          /\s*\<(?:dot|DOT)\>\s*/   => '.',
          /\s*\{(?:at|AT)\}\s*/     => '@',
          /\s*\{(?:dot|DOT)\}\s*/   => '.',
          /\s*\((?:at|AT)\)\s*/     => '@',
          /\s*\((?:dot|DOT)\)\s*/   => '.'
        }

        #
        # Deobfuscates an obfuscated email address.
        #
        # @param [String] string
        #   The obfuscated email address to deobfuscate.
        #
        # @return [String]
        #   The deobfuscated email address.
        #
        # @example
        #   EmailAddress.deobfuscate("john[dot]smith [at] example[dot]com")
        #   # => "john.smith@example.com"
        #
        def self.deobfuscate(string)
          DEOBFUSCATIONS.each do |pattern,replace|
            string = string.gsub(pattern,replace)
          end

          return string
        end

        #
        # Creates a new email address without the {#tag} or {#routing}
        # attribute.
        #
        # @return [EmailAddress]
        #   The new normalized email address object.
        #
        # @example
        #   email = EmailAddress.parse("John Smith <john.smith+spam@example.com>")
        #   email.normalize.to_s
        #   # => "john.smith@example.com"
        #
        def normalize
          EmailAddress.new(
            mailbox: mailbox,
            domain:  domain,
            address: address
          )
        end

        #
        # The hostname to connect to.
        #
        # @return [String]
        #   The {#domain} or {#address}.
        #
        def hostname
          @domain || @address
        end

        #
        # Converts the email address back into a string.
        #
        # @return [String]
        #   The string representation of the email address.
        #
        # @example
        #   email = EmailAddress.parse("John Smith <john.smith+spam@example.com>")
        #   email.to_s
        #   # => "John Smith <john.smith+spam@example.com>"
        #
        def to_s
          string = "#{@mailbox}"
          string << "+#{@tag}"               if @tag
          string << "%#{@routing.join('%')}" if @routing
          string << "@"
          string << if @address then "[#{@address}]"
                    else             @domain
                    end
          string = "#{@name} <#{string}>" if @name
          return string
        end

        alias to_str to_s

        #
        # @group Obfuscation Methods
        #

        # Email address obfuscation rules.
        OBFUSCATIONS = [
          [/\@/, {'@' => ' @ '  }],
          [/\@/, {'@' => ' AT '  }],
          [/\@/, {'@' => ' at '  }],
          [/\@/, {'@' => '[AT]'  }],
          [/\@/, {'@' => '[at]'  }],
          [/\@/, {'@' => ' [AT] '}],
          [/\@/, {'@' => ' [at] '}],
          [/\@/, {'@' => '<AT>'  }],
          [/\@/, {'@' => '<at>'  }],
          [/\@/, {'@' => ' <AT> '}],
          [/\@/, {'@' => ' <at> '}],
          [/\@/, {'@' => '{AT}'  }],
          [/\@/, {'@' => '{at}'  }],
          [/\@/, {'@' => ' {AT} '}],
          [/\@/, {'@' => ' {at} '}],
          [/\@/, {'@' => '(AT)'  }],
          [/\@/, {'@' => '(at)'  }],
          [/\@/, {'@' => ' (AT) '}],
          [/\@/, {'@' => ' (at) '}],
          [/[\.\@]/, {'.' => ' DOT ',   '@' => ' AT '  }],
          [/[\.\@]/, {'.' => ' dot ',   '@' => ' at '  }],
          [/[\.\@]/, {'.' => '[DOT]',   '@' => '[AT]'  }],
          [/[\.\@]/, {'.' => '[dot]',   '@' => '[at]'  }],
          [/[\.\@]/, {'.' => ' [DOT] ', '@' => ' [AT] '}],
          [/[\.\@]/, {'.' => ' [dot] ', '@' => ' [at] '}],
          [/[\.\@]/, {'.' => '<DOT>',   '@' => '<AT>'  }],
          [/[\.\@]/, {'.' => '<dot>',   '@' => '<at>'  }],
          [/[\.\@]/, {'.' => ' <DOT> ', '@' => ' <AT> '}],
          [/[\.\@]/, {'.' => ' <dot> ', '@' => ' <at> '}],
          [/[\.\@]/, {'.' => '{DOT}',   '@' => '{AT}'  }],
          [/[\.\@]/, {'.' => '{dot}',   '@' => '{at}'  }],
          [/[\.\@]/, {'.' => ' {DOT} ', '@' => ' {AT} '}],
          [/[\.\@]/, {'.' => ' {dot} ', '@' => ' {at} '}],
          [/[\.\@]/, {'.' => '(DOT)',   '@' => '(AT)'  }],
          [/[\.\@]/, {'.' => '(dot)',   '@' => '(at)'  }],
          [/[\.\@]/, {'.' => ' (DOT) ', '@' => ' (AT) '}],
          [/[\.\@]/, {'.' => ' (dot) ', '@' => ' (at) '}]
        ]

        #
        # Obfuscates the email address.
        #
        # @return [String]
        #   A randomly obfuscated version of the email address.
        #
        # @see OBFUSCATIONS
        #
        # @example
        #   email = EmailAddress.parse("john.smith@example.com")
        #   email.obfuscate
        #   # => "john.smith [AT] example.com"
        #   email.obfuscate
        #   # => "john <dot> smith <at> example <dot> com"
        #
        def obfuscate
          string = to_s
          string.gsub!(*OBFUSCATIONS.sample)
          return string
        end

        #
        # Enumerates over each obfuscation of the email address.
        #
        # @yield [obfuscated]
        #   If a block is given, it will be passed every obfuscation of the
        #   email address.
        #
        # @yieldparam [String] obfuscated
        #   An obfuscated version of the email address.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator will be returned.
        #
        # @example
        #   email = EmailAddress.parse("john.smith@example.com")
        #   email.each_obfuscation { |obfuscated_email| ... }
        #
        # @see OBFUSCATIONS
        #
        def each_obfuscation
          return enum_for(__method__) unless block_given?

          string = to_s

          OBFUSCATIONS.each do |gsub_args|
            yield string.gsub(*gsub_args)
          end

          return nil
        end

        #
        # Returns every obfuscation of the email address.
        #
        # @return [Array<String>]
        #   The Array containing every obfuscation of the email address.
        #
        # @example
        #   email = EmailAddress.parse("john.smith@example.com")
        #   email.obfuscations
        #   # => ["john.smith AT example.com",
        #   #     "john.smith at example.com",
        #   #     "john.smith[AT]example.com",
        #   #     "john.smith[at]example.com",
        #   #     "john.smith [AT] example.com",
        #   #     "john.smith [at] example.com",
        #   #     "john.smith<AT>example.com",
        #   #     "john.smith<at>example.com",
        #   #     "john.smith <AT> example.com",
        #   #     "john.smith <at> example.com",
        #   #     "john.smith{AT}example.com",
        #   #     "john.smith{at}example.com",
        #   #     "john.smith {AT} example.com",
        #   #     "john.smith {at} example.com",
        #   #     "john.smith(AT)example.com",
        #   #     "john.smith(at)example.com",
        #   #     "john.smith (AT) example.com",
        #   #     "john.smith (at) example.com",
        #   #     "john DOT smith AT example DOT com",
        #   #     "john dot smith at example dot com",
        #   #     "john[DOT]smith[AT]example[DOT]com",
        #   #     "john[dot]smith[at]example[dot]com",
        #   #     "john [DOT] smith [AT] example [DOT] com",
        #   #     "john [dot] smith [at] example [dot] com",
        #   #     "john<DOT>smith<AT>example<DOT>com",
        #   #     "john<dot>smith<at>example<dot>com",
        #   #     "john <DOT> smith <AT> example <DOT> com",
        #   #     "john <dot> smith <at> example <dot> com",
        #   #     "john{DOT}smith{AT}example{DOT}com",
        #   #     "john{dot}smith{at}example{dot}com",
        #   #     "john {DOT} smith {AT} example {DOT} com",
        #   #     "john {dot} smith {at} example {dot} com",
        #   #     "john(DOT)smith(AT)example(DOT)com",
        #   #     "john(dot)smith(at)example(dot)com",
        #   #     "john (DOT) smith (AT) example (DOT) com",
        #   #     "john (dot) smith (at) example (dot) com"]
        #
        # @see #each_obfuscation
        #
        def obfuscations
          each_obfuscation.to_a
        end

      end
    end
  end
end
