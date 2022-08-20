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

require 'net/http'
require 'uri/query_params'

module Ronin
  module Support
    module Network
      class HTTP
        #
        # Handles building HTTP request objects.
        #
        # @api private
        #
        # @since 1.0.0
        #
        module Request
          #
          # Builds the [Request-URI], aka path + query string, for a HTTP
          # request.
          #
          # [Request-URI]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html#sec5.1.2
          #
          # @param [String] path
          #   The path of the request.
          #
          # @param [String, nil] query
          #   The optional query string for the request.
          #
          # @param [Hash{Symbol => Object},
          #         Hash{String => Object}, nil] query_params
          #   Additional query params for the request.
          #
          # @return [String]
          #
          def self.request_uri(path, query: nil, query_params: nil)
            if query_params
              query = URI::QueryParams.dump(query_params)
            end

            if query
              # append the query-string onto the path
              path += if path.include?('?') then "&#{query}"
                      else                       "?#{query}"
                      end
            end

            return path
          end

          # Request methods and `Net::HTTP` request classes.
          METHODS = {
            copy:      Net::HTTP::Copy,
            delete:    Net::HTTP::Delete,
            get:       Net::HTTP::Get,
            head:      Net::HTTP::Head,
            lock:      Net::HTTP::Lock,
            mkcol:     Net::HTTP::Mkcol,
            move:      Net::HTTP::Move,
            options:   Net::HTTP::Options,
            patch:     Net::HTTP::Patch,
            post:      Net::HTTP::Post,
            propfind:  Net::HTTP::Propfind,
            proppatch: Net::HTTP::Proppatch,
            put:       Net::HTTP::Put,
            trace:     Net::HTTP::Trace,
            unlock:    Net::HTTP::Unlock
          }

          #
          # Creates a new `Net::HTTP` request.
          #
          # @param [:copy, :delete, :get, :head, :lock, :mkcol, :move,
          #         :options, :patch, :post, :propfind, :proppatch, :put,
          #         :trace, :unlock] method
          #   The HTTP request method to use.
          #
          # @param [String] path
          #
          # @param [String, nil] query
          #   The query-string to append to the request path.
          #
          # @param [Hash, nil] query_params
          #   The query-params to append to the request path.
          #
          # @param [String, nil] body
          #   The body of the request.
          #
          # @param [Hash, String, nil] form_data
          #   The form data that may be sent in the body of the request.
          #
          # @param [String, nil] user
          #   The user to authenticate as.
          #
          # @param [String, nil] password
          #   The password to authenticate with.
          #
          # @param [Hash{Symbol => String}, Hash{String => String}, nil] headers
          #   Additional HTTP header names and values to add to the request.
          #
          # @return [Net::HTTP::Copy,
          #          Net::HTTP::Delete,
          #          Net::HTTP::Get,
          #          Net::HTTP::Head,
          #          Net::HTTP::Lock,
          #          Net::HTTP::Mkcol,
          #          Net::HTTP::Move,
          #          Net::HTTP::Options,
          #          Net::HTTP::Patch,
          #          Net::HTTP::Post,
          #          Net::HTTP::Propfind,
          #          Net::HTTP::Proppatch,
          #          Net::HTTP::Put,
          #          Net::HTTP::Trace,
          #          Net::HTTP::Unlock]
          #   The built HTTP request object.
          #
          def self.build(method,path, headers: nil,
                                      # Basic-Auth keyword arguments
                                      user:     nil,
                                      password: nil,
                                      # query string keyword arguments
                                      query:        nil,
                                      query_params: nil,
                                      # request body keyword arguments
                                      body:      nil,
                                      form_data: nil)
            request_class = METHODS.fetch(method) do
              raise(ArgumentError,"unknown HTTP request method: #{method.inspect}")
            end

            request = request_class.new(
              request_uri(path, query: query, query_params: query_params),
              headers
            )

            if user
              user     = user.to_s
              password = password.to_s if password

              request.basic_auth(user,password)
            end

            if form_data
              case form_data
              when String
                request.content_type = 'application/x-www-form-urlencoded'
                request.body         = form_data
              else
                request.form_data    = form_data
              end
            elsif body
              case body
              when IO, StringIO then request.body_stream = body
              else                   request.body        = body
              end
            end

            return request
          end
        end
      end
    end
  end
end
