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

module Enumerable

  #
  # Maps the elements to a Hash.
  #
  # @yield [element]
  #   The given block will be passed each element.
  #   The return value from the block will be stored in the hash.
  #
  # @yieldparam [Object] element
  #   An element.
  #
  # @return [Hash{Object => Object}]
  #   The hash of elements and their mappings.
  #
  # @example
  #   host_names = %w[www.wired.com www.google.com]
  #   host_names.map_hash { |name| Resolv.getaddresses(name) }
  #   # {"www.wired.com"=>["184.84.183.17", "184.84.183.91"],
  #   #  "www.google.com"=>["173.194.33.18", "173.194.33.17", "173.194.33.19", "173.194.33.20", "173.194.33.16"]}
  #
  # @since 0.3.0
  #
  # @api public
  #
  def map_hash
    new_hash = Hash.new do |hash,key|
      hash[key] = yield(key)
    end

    each { |element| new_hash[element] }
    return new_hash
  end

end
