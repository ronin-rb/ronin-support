#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/network/extensions/ssl'

begin
  require 'openssl'
rescue ::LoadError
end

module Ronin
  module Network
    #
    # SSL helper methods.
    #
    module SSL
      # Maps SSL verify modes to `OpenSSL::SSL::VERIFY_*` constants.
      #
      # @return [Hash{Symbol => Integer}]
      #
      # @since 1.3.0
      #
      # @api private
      #
      VERIFY = Hash.new do |hash,key|
        verify_const = if key
                         "VERIFY_#{key.to_s.upcase}"
                       else
                         'VERIFY_NONE'
                       end

        unless OpenSSL::SSL.const_defined?(verify_const)
          raise(RuntimeError,"unknown verify mode #{key}")
        end

        hash[key] = OpenSSL::SSL.const_get(verify_const)
      end
    end
  end
end
