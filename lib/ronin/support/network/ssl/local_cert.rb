# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/support/network/ip'
require 'ronin/support/crypto/cert'
require 'ronin/support/network/ssl/local_key'

require 'fileutils'

module Ronin
  module Support
    module Network
      module SSL
        #
        # Represents the certificate used for local SSL server sockets.
        #
        # @api private
        #
        module LocalCert
          # The cached `~/.local/share/ronin/ronin-support/ssl.crt`.
          PATH = File.join(Home::LOCAL_SHARE_DIR,'ronin','ronin-support','ssl.crt')

          #
          # Generates a new self-signed SSL certificate using the
          # {LocalKey local key} and saves it to `~/.local/share/ronin/ssl.crt`.
          #
          # @return [Crypto::Cert]
          #   The newly generated certificate.
          #
          # @note
          #   The file will be created with chmod umask of `0644`
          #   (aka `-rw-r--r--`).
          #
          def self.generate
            cert = Crypto::Cert.generate(
              key: LocalKey.fetch,
              subject: {
                common_name:         'localhost',
                organization:        'ronin-rb',
                organizational_unit: 'ronin-support'
              },
              extensions: {
                'subjectAltName' => subject_alt_name
              }
            )

            FileUtils.mkdir_p(File.dirname(PATH))
            FileUtils.touch(PATH)
            FileUtils.chmod(0644,PATH)

            cert.save(PATH)
            return cert
          end

          #
          # Loads the local certificate from `~/.local/share/ronin/ssl.crt`.
          #
          # @return [Crypto::Cert]
          #   The loaded certificate.
          #
          def self.load
            Crypto::Cert.load_file(PATH)
          end

          #
          # Fetches the default SSL certificate used for all SSL server sockets.
          #
          # @return [Crypto::Cert]
          #   The default SSL certificate.
          #
          def self.fetch
            if File.file?(PATH) then load
            else                     generate
            end
          end

          #
          # The value for the `subjectAltName` extension.
          #
          # @return [String]
          #
          def self.subject_alt_name
            string = String.new("DNS: localhost")

            # append the additional local IP addresses
            IP.local_addresses.each do |address|
              string << ", IP: #{address}"
            end

            return string
          end
        end
      end
    end
  end
end
