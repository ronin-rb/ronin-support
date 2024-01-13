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

module Ronin
  module Support
    module Network
      module SMTP
        #
        # Represents an Email to be sent over {SMTP}.
        #
        class Email

          # The CR-LF String
          CRLF = "\n\r"

          # Sender of the email
          #
          # @return [String]
          attr_accessor :from

          # Recipient of the email
          #
          # @return [Array<#to_s>, String]
          attr_accessor :to

          # Subject of the email
          #
          # @return [String]
          attr_accessor :subject

          # Date of the email
          #
          # @return [String, Time]
          attr_accessor :date

          # Unique message-id string
          #
          # @return [String]
          attr_accessor :message_id

          # Additional headers
          #
          # @return [Hash{String => String}]
          attr_reader :headers

          # Body of the email
          #
          # @return [String, Array<String>]
          attr_accessor :body

          #
          # Creates a new Email object.
          #
          # @param [String] from
          #   The address the email is from.
          #
          # @param [Array<#to_s>, String] to
          #   The address that the email should be sent to.
          #
          # @param [String] subject
          #   The subject of the email.
          #
          # @param [String] message_id
          #   Message-ID of the email.
          #
          # @param [String, Time] date
          #   The date the email was sent on.
          #
          # @param [Hash<String => String}] headers
          #   Additional headers.
          #
          # @param [String, Array<String>] body
          #   The body of the email.
          #
          # @yield [email]
          #   If a block is given, it will be passed the newly created email
          #   object.
          #
          # @yieldparam [Email] email
          #   The newly created email object.
          #
          # @api public
          #
          def initialize(from:       nil,
                         to:         nil,
                         subject:    nil,
                         date:       Time.now,
                         message_id: nil,
                         headers:    nil,
                         body:       nil)
            @from       = from
            @to         = to
            @subject    = subject
            @date       = date
            @message_id = message_id

            @headers = {}
            @headers.merge!(headers) if headers

            @body = []

            if body
              case body
              when Array
                @body += body
              else
                @body << body
              end
            end

            yield self if block_given?
          end

          #
          # Formats the email into a SMTP message.
          #
          # @return [String]
          #   Properly formatted SMTP message.
          #
          # @see https://rubydoc.info/stdlib/net/Net/SMTP
          #
          # @api public
          #
          def to_s
            message = []

            if @from
              message << "From: #{@from}"
            end

            if @to
              message << case @to
                         when Array
                           "To: #{@to.join(', ')}"
                         else
                           "To: #{@to}"
                         end
            end

            if @subject
              message << "Subject: #{@subject}"
            end

            if @date
              message << "Date: #{@date}"
            end

            if @message_id
              message << "Message-Id: <#{@message_id}>"
            end

            @headers.each do |name,value|
              message << "#{name}: #{value}"
            end

            message << ''
            message += @body

            return message.join(CRLF)
          end

        end
      end
    end
  end
end
