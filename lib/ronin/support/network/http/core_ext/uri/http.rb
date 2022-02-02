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

require 'ronin/support/network/http'

require 'uri/http'

module URI
  class HTTP < Generic

    include Ronin::Support::Network::HTTP

    #
    # @see Ronin::Support::Network::HTTP#http_request
    #
    # @since 0.3.0
    #
    def request(**kwargs,&block)
      http_request(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_status
    #
    # @since 0.3.0
    #
    def status(**kwargs)
      http_status(url: self)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_ok?
    #
    # @since 0.3.0
    #
    def ok?(**kwargs)
      http_ok?(url: self)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_server
    #
    # @since 0.3.0
    #
    def server(**kwargs)
      http_server(url: self)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_powered_by
    #
    # @since 0.3.0
    #
    def powered_by(**kwargs)
      http_powered_by(url: self)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_copy
    #
    # @since 0.3.0
    #
    def copy(**kwargs,&block)
      http_copy(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_delete
    #
    # @since 0.3.0
    #
    def delete(**kwargs,&block)
      http_delete(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_get
    #
    # @since 0.3.0
    #
    def get(**kwargs,&block)
      http_get(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_get_headers
    #
    # @since 0.3.0
    #
    def get_headers(**kwargs,&block)
      http_get_headers(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_get_body
    #
    # @since 0.3.0
    #
    def get_body(**kwargs,&block)
      http_get_body(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_head
    #
    # @since 0.3.0
    #
    def head(**kwargs,&block)
      http_head(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_lock
    #
    # @since 0.3.0
    #
    def lock(**kwargs,&block)
      http_lock(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_mkcol
    #
    # @since 0.3.0
    #
    def mkcol(**kwargs,&block)
      http_mkcol(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_move
    #
    # @since 0.3.0
    #
    def move(**kwargs,&block)
      http_move(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_options
    #
    # @since 0.3.0
    #
    def options(**kwargs,&block)
      http_options(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_post
    #
    # @since 0.3.0
    #
    def post(**kwargs,&block)
      http_post(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_post_headers
    #
    # @since 0.3.0
    #
    def post_headers(**kwargs,&block)
      http_post_headers(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_post_body
    #
    # @since 0.3.0
    #
    def post_body(**kwargs,&block)
      http_post_body(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_prop_find
    #
    # @since 0.3.0
    #
    def prop_find(**kwargs,&block)
      http_prop_find(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_prop_match
    #
    # @since 0.3.0
    #
    def prop_match(**kwargs,&block)
      http_prop_match(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_trace
    #
    # @since 0.3.0
    #
    def trace(**kwargs,&block)
      http_trace(url: self, **kwargs, &block)
    end

    #
    # @see Ronin::Support::Network::HTTP#http_unlock
    #
    # @since 0.3.0
    #
    def unlock(**kwargs,&block)
      http_unlock(url: self, **kwargs, &block)
    end

  end
end
