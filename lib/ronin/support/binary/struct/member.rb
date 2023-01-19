# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/memory'

module Ronin
  module Support
    module Binary
      class Struct < Memory
        class Member

          # The name of the structure member.
          #
          # @return [Symbol]
          attr_reader :name

          # The type signature of the structure member.
          #
          # @return [Symbol, (Symbol, Integer), Range(Symbol)]
          attr_reader :type_signature

          # The default value for the structure member.
          #
          # @return [Object, Proc, nil]
          attr_reader :default

          #
          # Initializes the structure member.
          #
          # @param [Symbol] name
          #
          # @param [Symbol, (Symbol, Integer), Range(Symbol)] type_signature
          #   The type signature of the field.
          #
          # @param [Object, Proc, nil] default
          #   The optional default value for the structure's field.
          #
          def initialize(name,type_signature, default: nil)
            @name = name
            @type_signature = type_signature

            @default = default
          end

          #
          # Returns a default value for the structure's field.
          #
          # @param [Struct] struct
          #   The structure that is being initialized.
          #
          # @return [Object, nil]
          #   The new default value for the member field in the given structure.
          #
          def default_value(struct)
            case @default
            when Proc
              if @default.arity == 1
                @default.call(struct)
              else
                @default.call
              end
            else
              @default.dup
            end
          end

        end
      end
    end
  end
end
