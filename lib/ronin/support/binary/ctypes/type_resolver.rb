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

require 'ronin/support/binary/ctypes/type'
require 'ronin/support/binary/ctypes/array_object_type'
require 'ronin/support/binary/ctypes/struct_object_type'
require 'ronin/support/binary/struct'
require 'ronin/support/binary/union'

module Ronin
  module Support
    module Binary
      module CTypes
        #
        # Adds a type system that can be used by {Memory} objects.
        #
        # @api private
        #
        class TypeResolver

          # The {CTypes} module or object to lookup type names in.
          #
          # @return [#[]]
          attr_reader :types

          #
          # Initializes the type resolver.
          #
          # @return [#[]] types
          #   The types module or object that provides a `[]` method for
          #   looking up type names.
          #
          def initialize(types)
            @types = types
          end

          #
          # Resolves C type short-hand syntax into a {CTypes::Type} object.
          #
          # @param [Symbol,
          #         (type, Integer),
          #         Range(type),
          #         Binary::Struct.class] type_signature
          #   The C type value. The value can be one of the following:
          #   * `Symbol` - represents a single type (ex: `:int32`)
          #   * `(type, Integer)` - represents an Array type with the given
          #     element type and length (ex: `[:int32, 10]`)
          #   * `Range(type)` - represents an unbounded Array type with the
          #     given element type. (ex: `:int32..`)
          #   * `Struct.class` - a subclass of {Binary::Struct}.
          #   * `Union.class` - a subclass of {Binary::Union}.
          #
          # @return [Type]
          #   The translated type.
          #
          # @raise [ArgumentError]
          #   The given type name was not known or not a `Symbol`,
          #   `[Symbol, Integer]`, `Symbol..`, {Binary::Struct},
          #   {Binary::Union}, or a {Type}.
          #
          def resolve(type_signature)
            case type_signature
            when ::Array then resolve_array(type_signature)
            when Range   then resolve_range(type_signature)
            when Symbol  then resolve_symbol(type_signature)
            when Type    then type_signature
            when Class
              if type_signature < Binary::Union
                resolve_union(type_signature)
              elsif type_signature < Binary::Struct
                resolve_struct(type_signature)
              else
                raise(ArgumentError,"class must be either a #{Binary::Struct} or a #{Binary::Union} class")
              end
            else
              raise(ArgumentError,"type type_signature must be a Symbol, Array, Range, #{Binary::Struct}, #{Binary::Union}, or a #{CTypes::Type} object: #{type_signature.inspect}")
            end
          end

          private

          #
          # Resolves an array type.
          #
          # @param [(Symbol, Integer),
          #         (Struct.class, Integer),
          #         (Array, Integer)] type_signature
          #
          # @return [ArrayObjectType]
          #
          def resolve_array(type_signature)
            type, length = *type_signature
            type         = resolve(type)
            array_type   = type[length]

            ArrayObjectType.new(array_type)
          end

          #
          # Resolves a range type (aka unbounded array).
          #
          # @param [Range] type_signature
          #
          # @return [UnboundedArrayType]
          #
          def resolve_range(type_signature)
            range = type_signature
            type  = resolve(range.begin)
            type[]
          end

          #
          # Resolves a struct type.
          #
          # @param [Binary::Struct.class] type_signature
          #
          # @return [StructObjectType]
          #
          def resolve_struct(type_signature)
            struct_class   = type_signature
            struct_members = Hash[struct_class.members.map { |name,member|
              [name, resolve(member.type_signature)]
            }]

            struct_type = StructType.build(
              struct_members, alignment: struct_class.alignment,
                              padding:   struct_class.padding
            )

            StructObjectType.new(struct_class,struct_type)
          end

          #
          # Resolves a union type.
          #
          # @param [Binary::Union.class] type_signature
          #
          # @return [UnionObjectType]
          #
          def resolve_union(type_signature)
            union_class   = type_signature
            union_members = Hash[union_class.members.map { |name,member|
              [name, resolve(member.type_signature)]
            }]

            union_type = UnionType.build(
              union_members, alignment: union_class.alignment
            )

            UnionObjectType.new(union_class,union_type)
          end

          #
          # Resolves a type name.
          #
          # @param [Symbol] name
          # 
          # @return [Type]
          #
          def resolve_symbol(name)
            @types[name]
          end

        end
      end
    end
  end
end

