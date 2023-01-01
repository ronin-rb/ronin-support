# frozen_string_literal: true
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

require 'ronin/support/home'
require 'ronin/support/crypto/key/rsa'

require 'fileutils'

module Ronin
  module Support
    module Network
      module SSL
        #
        # Represents the RSA signing key used for local SSL server sockets.
        #
        # @api private
        #
        module LocalKey
          # The cached `~/.local/share/ronin/ssl.key` file.
          PATH = File.join(Home::LOCAL_SHARE_DIR,'ronin','ronin-support','ssl.key')

          #
          # Generates a new RSA key and saves it to
          # `~/.local/share/ronin/ssl.key`.
          #
          # @return [Crypto::Key::RSA]
          #   The newly generated key.
          #
          # @note
          #   The file will be created with a chmod umask of `0640`
          #   (aka `-rw-r-----`).
          #
          def self.generate
            key = Crypto::Key::RSA.generate

            FileUtils.mkdir_p(File.dirname(PATH))
            FileUtils.touch(PATH)
            FileUtils.chmod(0640,PATH)

            key.save(PATH)
            return key
          end

          #
          # Loads the RSA key from `~/.local/share/ronin/ssl.key`.
          #
          # @return [Crypto::Key::RSA]
          #   The loaded RSA key.
          #
          def self.load
            Crypto::Key::RSA.load_file(PATH)
          end

          #
          # The default RSA key used for all SSL server sockets.
          #
          # @return [Crypto::Key::RSA]
          #   The default RSA key.
          #
          def self.fetch
            if File.file?(PATH) then load
            else                     generate
            end
          end
        end
      end
    end
  end
end
