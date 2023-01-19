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

require 'ipaddr'

class IPAddr

  include Enumerable

  # Socket families and IP address masks
  #
  # @api private
  MASKS = {
    Socket::AF_INET  => IN4MASK,
    Socket::AF_INET6 => IN6MASK
  }

  #
  # Iterates over each IP address that is included in the addresses
  # netmask. Supports both IPv4 and IPv6 addresses.
  #
  # @yield [ip]
  #   The block which will be passed every IP address covered be the
  #   netmask of the IPAddr object.
  #
  # @yieldparam [String] ip
  #   An IP address.
  #
  # @example
  #   netblock = IPAddr.new('10.1.1.1/24')
  #
  #   netblock.each do |ip|
  #     puts ip
  #   end
  #
  # @api public
  #
  def each
    return enum_for(__method__) unless block_given?

    family_mask = MASKS[@family]

    (0..((~@mask_addr) & family_mask)).each do |i|
      yield _to_string(@addr | i)
    end

    return self
  end

end
