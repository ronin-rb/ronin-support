#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
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

module Ronin
  module Support
    module Crypto
      module Key
        #
        # @api private
        #
        # @since 1.0.0
        #
        module ClassMethods
          #
          # Parses an PEM encoded key.
          #
          # @param [String] key
          #   The key text.
          #
          # @return [OpenSSL::PKey]
          #   The parsed key.
          #
          # @api public
          #
          def parse(key)
            new(key)
          end

          #
          # @see parse
          #
          # @api public
          #
          def load(key)
            parse(key)
          end

          #
          # Loads a key from a file.
          #
          # @param [String] path
          #   The path to the key file.
          #
          # @return [OpenSSL::PKey]
          #   The parsed key.
          #
          # @api public
          #
          def load_file(path)
            parse(File.read(path))
          end
        end
      end
    end
  end
end
