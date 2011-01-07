#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as publishe by
# the Free Software Foundation, either version 3 of the License, or
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

begin
  require 'active_support/inflector'
rescue LoadError
  begin
    require 'extlib/inflection'
  rescue LoadError
    raise(LoadError,"unable to load 'active_support/inflector' or 'extlib/inflection'",caller)
  end
end

module Ronin
  module Support
    # The inflector that Ronin will use.
    Inflector = if Object.const_defined?(:ActiveSupport)
                  ActiveSupport::Inflector
                else
                  Extlib::Inflection
                end
  end
end
