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

module Kernel
  #
  # Calls the given block and ignores any raised exceptions.
  #
  # @yield []
  #   The block to be called.
  #
  # @return [Object, nil]
  #   The return-value of the given block. If `nil` is returned, an
  #   exception occurred and was ignored.
  #
  # @example
  #   try do
  #     Resolv.getaddress('might.not.exist.com')
  #   end
  #
  # @api public
  #
  def try
    yield() if block_given?
  rescue SyntaxError => error
    # re-raise syntax errors
    raise(error)
  rescue StandardError
    # ignore any exceptions
  end
end
