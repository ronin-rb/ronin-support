# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/js'

module Ronin
  module Support
    class Encoding < ::Encoding
      #
      # Contains methods for encoding/decoding escaping/unescaping Node.js
      # data.
      #
      # ## Core-Ext Methods
      #
      # * {Integer#node_js_escape}
      # * {Integer#node_js_encode}
      # * {String#node_js_escape}
      # * {String#node_js_unescape}
      # * {String#node_js_encode}
      # * {String#node_js_decode}
      # * {String#node_js_string}
      # * {String#node_js_unquote}
      #
      # @api public
      #
      # @since 1.2.0
      #
      NodeJS = JS
    end
  end
end

require 'ronin/support/encoding/node_js/core_ext'
