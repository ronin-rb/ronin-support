# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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
        #
        # The DES3 cipher.
        #
        # @since 1.2.0
        #
        class DES3 < Cipher

          # The DES3 cipher mode.
          #
          # @return [:wrap, Symbol, nil]
          attr_reader :mode

          #
          # Initializes the DES3 cipher.
          #
          # @param [:wrap, Symbol, nil] mode
          #   The desired DES3 cipher mode.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for {Cipher#initialize}.
          #
          def initialize(mode: nil, **kwargs)
            name = if mode then "des3-#{mode}"
                   else         "des3"
                   end

            super(name, **kwargs)

            @mode = mode
          end

          #
          # The list of supported DES3 ciphers.
          #
          # @return [Array<String>]
          #   The list of supported DES3 cipher names.
          #
          def self.supported
            super().grep(/^des3/)
          end

        end
      end
    end
  end
end
