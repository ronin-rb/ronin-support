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

require 'ronin/support/encoding/uri'

class Integer

  #
  # URI encodes the byte.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase hexadecimal.
  #   Defaults to uppercase hexadecimal.
  #
  # @return [String]
  #   The URI encoded byte.
  #
  # @example
  #   0x41.uri_encode
  #   # => "%41"
  #
  # @example Lowercase encoding:
  #   0xff.uri_encode(case: :lower)
  #   # => "%ff"
  #
  # @see Ronin::Support::Encoding::URI.encode_byte
  #
  # @api public
  #
  def uri_encode(**kwargs)
    Ronin::Support::Encoding::URI.encode_byte(self,**kwargs)
  end

  #
  # URI escapes the byte.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase hexadecimal.
  #   Defaults to uppercase hexadecimal.
  #
  # @return [String]
  #   The URI escaped byte.
  #
  # @example
  #   0x41.uri_escape
  #   # => "A"
  #   0x3d.uri_escape
  #   # => "%3D"
  #
  # @example Lowercase encoding:
  #   0xff.uri_escape(case: :lower)
  #   # => "%ff"
  #
  # @see Ronin::Support::Encoding::URI.escape_byte
  #
  # @api public
  #
  def uri_escape(**kwargs)
    Ronin::Support::Encoding::URI.escape_byte(self,**kwargs)
  end

  #
  # URI Form escapes the Integer.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase hexadecimal.
  #   Defaults to uppercase hexadecimal.
  #
  # @return [String]
  #   The URI Form escaped Integer.
  #
  # @example
  #   0x41.uri_form_ecape
  #   # => "A"
  #   0x20.uri_form_escape
  #   # => "+"
  #
  # @example Lowercase encoding:
  #   0xff.uri_form_escape(case: :lower)
  #   # => "%ff"
  #
  # @see Ronin::Support::Encoding::URI::Form.escape_byte
  #
  # @api public
  #
  # @since 1.0.0
  #
  def uri_form_escape(**kwargs)
    Ronin::Support::Encoding::URI::Form.escape_byte(self,**kwargs)
  end

  #
  # URI Form encodes the Integer.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments.
  #
  # @option kwargs [:lower, :upper, nil] :case
  #   Controls whether to output lowercase or uppercase hexadecimal.
  #   Defaults to uppercase hexadecimal.
  #
  # @return [String]
  #   The URI Form encoded Integer.
  #
  # @example
  #   0x41.uri_form_encode
  #   # => "%41"
  #   0x20.uri_form_encode
  #   # => "+"
  #
  # @example Lowercase encoding:
  #   0xff.uri_form_encode(case: :lower)
  #   # => "%ff"
  #
  # @see Ronin::Support::Encoding::URI::Form.encode_byte
  #
  # @api public
  #
  # @since 1.0.0
  #
  def uri_form_encode(**kwargs)
    Ronin::Support::Encoding::URI::Form.encode_byte(self,**kwargs)
  end

end
