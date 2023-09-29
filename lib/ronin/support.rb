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

require 'ronin/support/binary'
require 'ronin/support/cli'
require 'ronin/support/core_ext'
require 'ronin/support/crypto'
require 'ronin/support/encoding'
require 'ronin/support/mixin'
require 'ronin/support/network'
require 'ronin/support/path'
require 'ronin/support/text'
require 'ronin/support/version'

module Ronin
  #
  # Top-level namespace for `ronin-support`.
  #
  # ## Example
  #
  #     require 'ronin/support'
  #     include Ronin::Support
  #
  #     "hello world".base64_encode
  #     # => "aGVsbG8gd29ybGQ=\n"
  #
  #     http_get 'https://example.com/'
  #     # => #<Net::HTTPOK 200 OK readbody=true>
  #
  module Support
    include Mixin
  end
end
