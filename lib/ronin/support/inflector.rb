#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Support
    # The Inflectors supported by ronin-support
    INFLECTORS = {
      :datamapper => {
        :path => 'dm-core',
        :const => 'DataMapper::Inflector'
      },
      :active_support => {
        :path => 'active_support/inflector',
        :const => 'ActiveSupport::Inflector'
      },
      :extlib => {
        :path => 'extlib/inflection',
        :const => 'Extlib::Inflection'
      }
    }

    #
    # Loads an Inflector library and sets the `Ronin::Support::Inflector`
    # constant.
    #
    # @param [Symbol, String] name
    #   The name of the Inflector library to load. May be either
    #   `:datamapper`, `:active_support` or `:extlib`.
    #
    # @return [true]
    #   Specifies that the Inflector library was successfully loaded.
    #
    # @raise [ArgumentError]
    #   The Inflector library is not supported.
    #
    # @raise [LoadError]
    #   The Inflector library could not be loaded.
    #
    # @raise [NameError]
    #   The constant could not be found.
    #
    # @api private
    #
    def Support.load_inflector!(name)
      name = name.to_sym

      unless (inflector = INFLECTORS[name])
        raise(ArgumentError,"unsupported Inflector: #{name}")
      end

      begin
        require inflector[:path]
      rescue Gem::LoadError => e
        raise(e)
      rescue ::LoadError
        raise(LoadError,"unable to load #{inflector[:path]}")
      end

      begin
        const_set('Inflector', eval("::#{inflector[:const]}"))
      rescue NameError
        raise(NameError,"unable to find #{inflector[:const]}")
      end

      return true
    end

    [:datamapper, :active_support, :extlib].each do |name|
      begin
        Support.load_inflector!(name)
        break
      rescue LoadError
      end
    end

    unless const_defined?('Inflector')
      raise(LoadError,"unable to load or find any Inflectors")
    end
  end
end
