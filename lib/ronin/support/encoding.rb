# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/encoding/base16'
require 'ronin/support/encoding/base32'
require 'ronin/support/encoding/base36'
require 'ronin/support/encoding/base62'
require 'ronin/support/encoding/base64'
require 'ronin/support/encoding/hex'
require 'ronin/support/encoding/c'
require 'ronin/support/encoding/shell'
require 'ronin/support/encoding/powershell'
require 'ronin/support/encoding/http'
require 'ronin/support/encoding/xml'
require 'ronin/support/encoding/html'
require 'ronin/support/encoding/js'
require 'ronin/support/encoding/sql'
require 'ronin/support/encoding/quoted_printable'
require 'ronin/support/encoding/smtp'
require 'ronin/support/encoding/ruby'
require 'ronin/support/encoding/uri'
require 'ronin/support/encoding/punycode'

module Ronin
  module Support
    #
    # Contains additional encoding/decoding modules.
    #
    # ## Core-Ext Methods
    #
    # * {Integer#c_encode}
    # * {Integer#c_escape}
    # * {Integer#hex_encode}
    # * {Integer#hex_escape}
    # * {Integer#hex_int}
    # * {Integer#html_encode}
    # * {Integer#html_escape}
    # * {Integer#http_encode}
    # * {Integer#http_escape}
    # * {Integer#js_encode}
    # * {Integer#js_escape}
    # * {Integer#powershell_encode}
    # * {Integer#powershell_escape}
    # * {Integer#shell_encode}
    # * {Integer#shell_escape}
    # * {Integer#uri_encode}
    # * {Integer#uri_escape}
    # * {Integer#uri_form_encode}
    # * {Integer#uri_form_escape}
    # * {Integer#xml_encode}
    # * {Integer#xml_escape}
    # * {String#base16_decode}
    # * {String#base16_encode}
    # * {String#base32_decode}
    # * {String#base32_encode}
    # * {Integer#base36_encode}
    # * {String#base36_decode}
    # * {String#base62_decode}
    # * {Integer#base62_encode}
    # * {String#base64_decode}
    # * {String#base64_encode}
    # * {String#c_encode}
    # * {String#c_escape}
    # * {String#c_string}
    # * {String#c_unescape}
    # * {String#c_unquote}
    # * {String#hex_decode}
    # * {String#hex_encode}
    # * {String#hex_escape}
    # * {String#hex_string}
    # * {String#hex_unescape}
    # * {String#hex_unquote}
    # * {String#html_decode}
    # * {String#html_encode}
    # * {String#html_escape}
    # * {String#html_unescape}
    # * {String#http_decode}
    # * {String#http_encode}
    # * {String#http_escape}
    # * {String#http_unescape}
    # * {String#js_decode}
    # * {String#js_encode}
    # * {String#js_escape}
    # * {String#js_string}
    # * {String#js_unescape}
    # * {String#js_unquote}
    # * {String#powershell_decode}
    # * {String#powershell_encode}
    # * {String#powershell_escape}
    # * {String#powershell_string}
    # * {String#powershell_unescape}
    # * {String#powershell_unquote}
    # * {String#punycode_decode}
    # * {String#punycode_encode}
    # * {String#quoted_printable_escape}
    # * {String#quoted_printable_unescape}
    # * {String#smtp_escape}
    # * {String#smtp_unescape}
    # * {String#ruby_decode}
    # * {String#ruby_encode}
    # * {String#ruby_escape}
    # * {String#ruby_string}
    # * {String#ruby_unescape}
    # * {String#ruby_unquote}
    # * {String#shell_decode}
    # * {String#shell_encode}
    # * {String#shell_escape}
    # * {String#shell_string}
    # * {String#shell_unescape}
    # * {String#shell_unquote}
    # * {String#sql_decode}
    # * {String#sql_encode}
    # * {String#sql_escape}
    # * {String#sql_unescape}
    # * {String#uri_decode}
    # * {String#uri_encode}
    # * {String#uri_escape}
    # * {String#uri_form_decode}
    # * {String#uri_form_encode}
    # * {String#uri_form_escape}
    # * {String#uri_form_unescape}
    # * {String#uri_unescape}
    # * {String#uu_decode}
    # * {String#uu_encode}
    # * {String#xml_decode}
    # * {String#xml_encode}
    # * {String#xml_escape}
    # * {String#xml_unescape}
    #
    # @since 1.0.0
    #
    class Encoding < ::Encoding
    end
  end
end
