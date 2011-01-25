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

require 'ronin/templates/template'

require 'erb'

module Ronin
  module Templates
    #
    # The {Erb} module uses the {Template} module to find and render
    # Embedded Ruby (ERB) templates.
    #
    module Erb
      include Template
      #
      # Renders the inline ERB template in the scope of the object.
      #
      # @param [String] template
      #   Source of the ERB template.
      #
      # @return [String]
      #   Result of the rendered template.
      #
      # @example
      #   @user = 'lolcats'
      #
      #   erb %{
      #   USER: <%= @user %>
      #   PASSWORD: <%= @user.reverse %>
      #   }
      #   # => "\nUSER: lolcats\nPASSWORD: staclol\n"
      #
      def erb(template)
        ERB.new(template).result(binding)
      end

      #
      # Renders an ERB template file in the scope of the object.
      #
      # @param [String] template_path
      #   The relative path of the ERB template.
      #
      # @return [String]
      #   Result of the rendered template.
      #
      # @example
      #   erb_file 'path/to/template.erb'
      #
      def erb_file(template_path)
        read_template(template_path) do |template|
          erb(template)
        end
      end
    end
  end
end
