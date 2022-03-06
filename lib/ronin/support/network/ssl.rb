#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
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


require 'ronin/support/network/ssl/proxy'

begin
  require 'openssl'
rescue ::LoadError
  warn "WARNING: Ruby was not compiled with OpenSSL support"
end

module Ronin
  module Support
    module Network
      module SSL
        # SSL verify modes
        VERIFY = {
          none:                 OpenSSL::SSL::VERIFY_NONE,
          peer:                 OpenSSL::SSL::VERIFY_PEER,
          fail_if_no_peer_cert: OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT,
          client_once:          OpenSSL::SSL::VERIFY_CLIENT_ONCE,
          true               => OpenSSL::SSL::VERIFY_PEER,
          false              => OpenSSL::SSL::VERIFY_NONE
        }

        # Default SSL key file
        DEFAULT_KEY_FILE = File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','data','ronin','network','ssl','ssl.key'))

        # Default SSL cert file
        DEFAULT_CERT_FILE = File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','data','ronin','network','ssl','ssl.pem'))
      end
    end
  end
end
