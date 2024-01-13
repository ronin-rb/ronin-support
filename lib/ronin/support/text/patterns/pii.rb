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

require 'ronin/support/text/patterns/network'

module Ronin
  module Support
    module Text
      #
      # @since 0.3.0
      #
      module Patterns
        #
        # @group PII Patterns
        #

        # Regular expression to match a word in the username of an email address
        USER_NAME = /[A-Za-z](?:[A-Za-z0-9]*[\._-])*[A-Za-z0-9]+/

        # Regular expression to find email addresses in text
        #
        # @since 1.0.0
        EMAIL_ADDRESS = /#{USER_NAME}\@#{HOST_NAME}/

        # @see EMAIL_ADDRESS
        EMAIL_ADDR = EMAIL_ADDRESS

        # Regular expression to match `.`, ` AT `, ` at `, `[AT]`, `[at]`,
        # `<AT>`, `<at>`, `{AT}`, `{at}`, `(AT)`, `(at)`.
        #
        # @since 1.0.0
        OBFUSCATED_EMAIL_AT = /\@|\s+(?:AT|at)\s+|\s*\[(?:AT|at)\]\s*|\s*\<(?:AT|at)\>\s*|\s*\{(?:AT|at)\}\s*|\s*\((?:AT|at)\)\s*/

        # Regular expression to match `.`, ` DOT `, ` dot `, `[DOT]`, `[dot]`,
        # `<DOT>`, `<dot>`, `{DOT}`, `{dot}`, `(DOT)`, `(dot)`.
        #
        # @since 1.0.0
        OBFUSCATED_EMAIL_DOT = /\.|\s+(?:DOT|dot)\s+|\s*\[(?:DOT|dot)\]\s*|\s*\<(?:DOT|dot)\>\s*|\s*\{(?:DOT|dot)\}\s*|\s*\((?:DOT|dot)\)\s*/

        # Regular expression to find obfuscated email addresses in text.
        #
        # @since 1.0.0
        OBFUSCATED_EMAIL_ADDRESS = /[a-zA-Z][a-zA-Z0-9_-]*(?:#{OBFUSCATED_EMAIL_DOT}[a-zA-Z][a-zA-Z0-9_-]*)*#{OBFUSCATED_EMAIL_AT}(?:[a-zA-Z0-9_-]{1,63}#{OBFUSCATED_EMAIL_DOT})*[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*#{OBFUSCATED_EMAIL_DOT}#{PUBLIC_SUFFIX}(?=[^a-zA-Z0-9\._-]|$)/

        # @see OBFUSCATED_EMAIL_ADDRESS
        OBFUSCATED_EMAIL_ADDR = OBFUSCATED_EMAIL_ADDRESS

        # Regular expression to find phone numbers in text
        #
        # @since 0.5.0
        PHONE_NUMBER = /(?:\d[ \-\.]?)?(?:\d{3}[ \-\.]?)?\d{3}[ \-\.]?\d{4}(?:x\d+)?/

        # Regular expression to find Social Security Numbers (SSNs) in text
        #
        # @since 1.0.0
        SSN = /(?<=[^\d]|^)\d{3}-\d{2}-\d{4}(?=[^\d]|$)/

        # Regular expression to find AMEX card numbers in text
        #
        # @since 1.0.0
        AMEX_CC = /(?<=[^\d]|^)3[47][0-9]{13}(?=[^\d]|$)/

        # Regular expression to find Discord card numbers in text
        #
        # @since 1.0.0
        DISCOVER_CC = /(?<=[^\d]|^)(?:65[4-9][0-9]{13}|64[4-9][0-9]{13}|6011[0-9]{12}|(?:622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10}))(?=[^\d]|$)/

        # Regular expression to find Masterdard numbers in text
        #
        # @since 1.0.0
        MASTERCARD_CC = /(?<=[^\d]|^)(?:5[1-5][0-9]{14}|2(?:22[1-9][0-9]{12}|2[3-9][0-9]{13}|[3-6][0-9]{14}|7[0-1][0-9]{13}|720[0-9]{12}))(?=[^\d]|$)/

        # Regular expression to find VISA numbers in text
        #
        # @since 1.0.0
        VISA_CC = /(?<=[^\d]|^)4[0-9]{12}(?:[0-9]{3})?(?=[^\d]|$)/

        # Regular expression to find VISA Masterdard numbers in text
        #
        # @since 1.0.0
        VISA_MASTERCARD_CC = /(?<=[^\d]|^)(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14})(?=[^\d]|$)/

        # Regular expression to find Credit Card (CC) numbers in text
        #
        # @since 1.0.0
        CC = /#{VISA_CC}|#{VISA_MASTERCARD_CC}|#{MASTERCARD_CC}|#{DISCOVER_CC}|#{AMEX_CC}/
      end
    end
  end
end
