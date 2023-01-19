# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/support/crypto/cipher'

module Ronin
  module Support
    module Crypto
      class Cipher < OpenSSL::Cipher
        class AES < Cipher

          # The AES cipher key size.
          #
          # @return [Integer]
          #   The key size in bits.
          attr_reader :key_size

          # The AES cipher mode.
          #
          # @return [:cbc, :cfb, :ofb, :ctr, Symbol]
          attr_reader :mode

          #
          # Initializes the AES cipher.
          #
          # @param [Integer] key_size
          #   The desired key size in bits.
          #
          # @param [:cbc, :cfb, :ofb, :ctr, Symbol] mode
          #   The desired AES cipher mode.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {Cipher#initialize}.
          #
          def initialize(key_size: , mode: :cbc, **kwargs)
            super("aes-#{key_size}-#{mode}", **kwargs)

            @key_size = key_size
            @mode     = mode
          end

          #
          # The list of supported AES ciphers.
          #
          # @return [Array<String>]
          #   The list of supported AES cipher names.
          #
          def self.supported
            super().grep(/^aes/)
          end

        end
      end
    end
  end
end
