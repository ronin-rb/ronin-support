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

require 'ronin/network/http'

require 'uri/http'

module URI
  class HTTP < Generic

    include Ronin::Network::HTTP

    #
    # @see Ronin::Network::HTTP#http_request
    #
    # @since 0.3.0
    #
    def request(options={},&block)
      http_request(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_status
    #
    # @since 0.3.0
    #
    def status(options={})
      http_status(options.merge(url: self))
    end

    #
    # @see Ronin::Network::HTTP#http_ok?
    #
    # @since 0.3.0
    #
    def ok?(options={})
      http_ok?(options.merge(url: self))
    end

    #
    # @see Ronin::Network::HTTP#http_server
    #
    # @since 0.3.0
    #
    def server(options={})
      http_server(options.merge(url: self))
    end

    #
    # @see Ronin::Network::HTTP#http_powered_by
    #
    # @since 0.3.0
    #
    def powered_by(options={})
      http_powered_by(options.merge(url: self))
    end

    #
    # @see Ronin::Network::HTTP#http_copy
    #
    # @since 0.3.0
    #
    def copy(options={},&block)
      http_copy(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_delete
    #
    # @since 0.3.0
    #
    def delete(options={},&block)
      http_delete(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_get
    #
    # @since 0.3.0
    #
    def get(options={},&block)
      http_get(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_get_headers
    #
    # @since 0.3.0
    #
    def get_headers(options={},&block)
      http_get_headers(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_get_body
    #
    # @since 0.3.0
    #
    def get_body(options={},&block)
      http_get_body(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_head
    #
    # @since 0.3.0
    #
    def head(options={},&block)
      http_head(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_lock
    #
    # @since 0.3.0
    #
    def lock(options={},&block)
      http_lock(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_mkcol
    #
    # @since 0.3.0
    #
    def mkcol(options={},&block)
      http_mkcol(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_move
    #
    # @since 0.3.0
    #
    def move(options={},&block)
      http_move(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_options
    #
    # @since 0.3.0
    #
    def options(options={},&block)
      http_options(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_post
    #
    # @since 0.3.0
    #
    def post(options={},&block)
      http_post(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_post_headers
    #
    # @since 0.3.0
    #
    def post_headers(options={},&block)
      http_post_headers(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_post_body
    #
    # @since 0.3.0
    #
    def post_body(options={},&block)
      http_post_body(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_prop_find
    #
    # @since 0.3.0
    #
    def prop_find(options={},&block)
      http_prop_find(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_prop_match
    #
    # @since 0.3.0
    #
    def prop_match(options={},&block)
      http_prop_match(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_trace
    #
    # @since 0.3.0
    #
    def trace(options={},&block)
      http_trace(options.merge(url: self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_unlock
    #
    # @since 0.3.0
    #
    def unlock(options={},&block)
      http_unlock(options.merge(url: self),&block)
    end

  end
end
