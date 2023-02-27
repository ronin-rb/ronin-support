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

require 'ronin/support/text/patterns/crypto'

module Ronin
  module Support
    module Text
      #
      # @since 0.3.0
      #
      module Patterns
        #
        # @group Credential Patterns
        #

        # Regular expression for finding all SSH private keys in text.
        #
        # @since 1.0.0
        SSH_PRIVATE_KEY = /-----BEGIN OPENSSH PRIVATE KEY-----\n(?:.+)\n-----END OPENSSH PRIVATE KEY-----/m

        # Regular expression for finding all DSA private keys in text.
        #
        # @since 1.0.0
        DSA_PRIVATE_KEY = /-----BEGIN DSA PRIVATE KEY-----\n(?:.+)\n-----END DSA PRIVATE KEY-----/m

        # Regular expression for finding all EC private keys in text.
        #
        # @since 1.0.0
        EC_PRIVATE_KEY = /-----BEGIN EC PRIVATE KEY-----\n(?:.+)\n-----END EC PRIVATE KEY-----/m

        # Regular expression for finding all RSA private keys in text.
        #
        # @since 1.0.0
        RSA_PRIVATE_KEY = /-----BEGIN RSA PRIVATE KEY-----\n(?:.+)\n-----END RSA PRIVATE KEY-----/m

        # Regular expression for finding all private keys in text.
        #
        # @since 1.0.0
        PRIVATE_KEY = /#{RSA_PRIVATE_KEY}|#{DSA_PRIVATE_KEY}|#{EC_PRIVATE_KEY}/

        # Regular expression for finding all AWS access key IDs
        #
        # @since 1.0.0
        AWS_ACCESS_KEY_ID = /(?<=[^A-Z0-9]|^)[A-Z0-9]{20}(?=[^A-Z0-9]|$)/

        # Regular expression for finding all AWS secret access key
        #
        # @since 1.0.0
        AWS_SECRET_ACCESS_KEY = %r{(?<=[^A-Za-z0-9/+=]|^)[A-Za-z0-9/+=]{40}(?=[^A-Za-z0-9/+=]|$)}

        # Regular expression for finding all API keys (md5, sha1, sha256,
        # sha512, AWS access key ID or AWS secret access key).
        #
        # @since 1.0.0
        API_KEY = /#{HASH}|#{AWS_ACCESS_KEY_ID}|#{AWS_SECRET_ACCESS_KEY}/
      end
    end
  end
end
