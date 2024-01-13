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
    module Text
      #
      # @since 0.3.0
      #
      module Patterns
        #
        # @group Cryptography Patterns
        #

        # Regular expression for finding all MD5 hashes in text.
        #
        # @since 1.0.0
        MD5 = /(?<=[^0-9a-fA-F]|^)[0-9a-fA-F]{32}(?=[^0-9a-fA-F]|$)/

        # Regular expression for finding all SHA1 hashes in text.
        #
        # @since 1.0.0
        SHA1 = /(?<=[^0-9a-fA-F]|^)[0-9a-fA-F]{40}(?=[^0-9a-fA-F]|$)/

        # Regular expression for finding all SHA256 hashes in text.
        #
        # @since 1.0.0
        SHA256 = /(?<=[^0-9a-fA-F]|^)[0-9a-fA-F]{64}(?=[^0-9a-fA-F]|$)/

        # Regular expression for finding all SHA512 hashes in text.
        #
        # @since 1.0.0
        SHA512 = /(?<=[^0-9a-fA-F]|^)[0-9a-fA-F]{128}(?=[^0-9a-fA-F]|$)/

        # Regular expression for finding all hashes in text.
        #
        # @since 1.0.0
        HASH = /#{SHA512}|#{SHA256}|#{SHA1}|#{MD5}/

        # Regular expression for finding all public keys in text.
        #
        # @since 1.0.0
        PUBLIC_KEY = /-----BEGIN PUBLIC KEY-----\n(?:.+)\n-----END PUBLIC KEY-----/m

        # Regular expression for finding all SSH public keys in text.
        #
        # @since 1.0.0
        SSH_PUBLIC_KEY = %r{(?:ssh-(?:rsa|dss|ed25519(?:@openssh.com)?)|ecdsa-sha2-nistp(?:256|384|521)(?:@openssh.com)?) AAAA[A-Za-z0-9+/]+(?:=){0,3} [^@\s]+@[^@\s]+}
      end
    end
  end
end
