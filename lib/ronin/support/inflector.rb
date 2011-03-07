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
    inflectors = [
      {
        :path => 'dm-core/support/inflector',
        :const => 'DataMapper::Inflector'
      },
      {
        :path => 'active_support/inflector',
        :const => 'ActiveSupport::Inflector'
      },
      {
        :path => 'extlib/inflection',
        :const => 'Extlib::Inflection'
      }
    ]
    inflector_const = 'Inflector'

    inflectors.each do |inflector|
      begin
        require inflector[:path]
      rescue LoadError
        next
      end

      const_set(inflector_const, eval("::#{inflector[:const]}"))
      break
    end

    unless const_defined?(inflector_const)
      raise(LoadError,"unable to load or find any Inflectors")
    end
  end
end
