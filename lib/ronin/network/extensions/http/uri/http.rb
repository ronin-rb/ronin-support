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

require 'ronin/network/extensions/http/net'

require 'uri/http'

module URI
  class HTTP < Generic

    #
    # @see Ronin::Network::HTTP#http_request
    #
    # @since 0.3.0
    #
    def request(options={},&block)
      Net.http_request(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_status
    #
    # @since 0.3.0
    #
    def status(options={})
      Net.http_status(options.merge(:url => self))
    end

    #
    # @see Ronin::Network::HTTP#http_ok?
    #
    # @since 0.3.0
    #
    def ok?(options={})
      Net.http_ok?(options.merge(:url => self))
    end

    #
    # @see Ronin::Network::HTTP#http_server
    #
    # @since 0.3.0
    #
    def server(options={})
      Net.http_server(options.merge(:url => self))
    end

    #
    # @see Ronin::Network::HTTP#http_powered_by
    #
    # @since 0.3.0
    #
    def powered_by(options={})
      Net.http_powered_by(options.merge(:url => self))
    end

    #
    # @see Ronin::Network::HTTP#http_copy
    #
    # @since 0.3.0
    #
    def copy(options={},&block)
      Net.http_copy(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_delete
    #
    # @since 0.3.0
    #
    def delete(options={},&block)
      Net.http_delete(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_get
    #
    # @since 0.3.0
    #
    def get(options={},&block)
      Net.http_get(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_get_headers
    #
    # @since 0.3.0
    #
    def get_headers(options={},&block)
      Net.http_get_headers(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_get_body
    #
    # @since 0.3.0
    #
    def get_body(options={},&block)
      Net.http_get_body(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_head
    #
    # @since 0.3.0
    #
    def head(options={},&block)
      Net.http_head(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_lock
    #
    # @since 0.3.0
    #
    def lock(options={},&block)
      Net.http_lock(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_mkcol
    #
    # @since 0.3.0
    #
    def mkcol(options={},&block)
      Net.http_mkcol(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_move
    #
    # @since 0.3.0
    #
    def move(options={},&block)
      Net.http_move(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_options
    #
    # @since 0.3.0
    #
    def options(options={},&block)
      Net.http_options(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_post
    #
    # @since 0.3.0
    #
    def post(options={},&block)
      Net.http_post(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_post_headers
    #
    # @since 0.3.0
    #
    def post_headers(options={},&block)
      Net.http_post_headers(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_post_body
    #
    # @since 0.3.0
    #
    def post_body(options={},&block)
      Net.http_post_body(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_prop_find
    #
    # @since 0.3.0
    #
    def prop_find(options={},&block)
      Net.http_prop_find(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_prop_match
    #
    # @since 0.3.0
    #
    def prop_match(options={},&block)
      Net.http_prop_match(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_trace
    #
    # @since 0.3.0
    #
    def trace(options={},&block)
      Net.http_trace(options.merge(:url => self),&block)
    end

    #
    # @see Ronin::Network::HTTP#http_unlock
    #
    # @since 0.3.0
    #
    def unlock(options={},&block)
      Net.http_unlock(options.merge(:url => self),&block)
    end

  end
end
