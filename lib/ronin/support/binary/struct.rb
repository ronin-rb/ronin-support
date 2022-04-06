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

require 'ronin/support/binary/memory'
require 'ronin/support/binary/struct/member'
require 'ronin/support/binary/types'

require 'set'

module Ronin
  module Support
    module Binary
      #
      # Generic Binary Struct class.
      #
      # ## Examples
      #
      # ### Defining Fields
      #
      #     class Point < Ronin::Support::Binary::Struct
      #     
      #       field :x, :int32
      #       field :y, :int32
      #     
      #     end
      #     
      #     class Point3D < Point
      #     
      #       field :z, :int32
      #
      #     end
      #     
      #     point   = Point.new(x: 100, y: 42)
      #     point3d = Point3D.new(x: 100, y: 42, z: -1)
      #
      # ### Array Fields
      #
      #     class MyStruct < Ronin::Support::Binary::Struct
      #     
      #       field :x,    :uint32
      #       field :nums, [:uint8, 10]
      #     
      #     end
      #
      #     struct = MyStruct.new
      #     struct.nums = [0x01, 0x02, 0x03, 0x04]
      #
      # ### Unbounded Array Fields
      #
      #     class MyStruct < Ronin::Support::Binary::Struct
      #     
      #       field :length,  :uint32
      #       field :payload, (:uint8..)
      #     
      #     end
      #     
      #     struct = MyStruct.new
      #     struct.payload = [0x01, 0x02, 0x03, 0x04, ...]
      #
      # ### Packing Structs
      #
      #     class Point < Ronin::Support::Binary::Struct
      #     
      #       field :x, :int32
      #       field :y, :int32
      #     
      #     end
      #
      #     point = Point.new(x: 10, y: -1)
      #     point.pack
      #     # => ""
      #
      # ### Unpacking Structs
      #
      #     class Point < Ronin::Support::Binary::Struct
      #     
      #       field :x, :int32
      #       field :y, :int32
      #     
      #     end
      #     
      #     point = Point.unpack("")
      #     point.x
      #     # => 10
      #     point.y
      #     # => -1
      #
      # ### Default Endianness
      #
      #     class Packet < Ronin::Support::Binary::Struct
      #     
      #       endian :network
      #     
      #       field :length, :uint32
      #       field :data,   [:uchar, 48]
      #     
      #     end
      #     
      #     pkt = Packet.new
      #     pkt.length = 5
      #     pkt.data   = 'hello'
      #     
      #     buffer = pkt.pack
      #     # => "\x00\x00\x00\x05hello\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
      #    
      #     new_pkt = Packet.unpack(buffer)
      #     # => #<Packet: length: 5, data: "hello">
      #
      # ### `FFI::Struct` style syntax:
      #
      #     class Packet < Ronin::Support::Binary::Struct
      #
      #       endian :network
      #     
      #       layout :length, :uint32,
      #              :data,   [:uchar, 48]
      #
      #     end
      #
      # @api public
      #
      class Struct < Memory

        # The type data for the struct.
        #
        # @return [Types::StructType]
        attr_reader :type

        #
        # Initializes the structure.
        #
        # @param [Hash{Symbol => Object}, String, ByteSlice] buffer_or_values
        #   Optional values to initialize the fields of the struct.
        #
        def initialize(buffer_or_values={}, **kwargs)
          @type = self.class.type

          case buffer_or_values
          when Hash
            values = buffer_or_values

            super(@type.size)

            values.each do |name,value|
              self[name] = value
            end
          when String, ByteSlice
            buffer = buffer_or_values

            super(buffer)
          else
            raise(ArgumentError,"first argument of #{self.class}.new must be either a Hash of values or a String or #{ByteSlice}")
          end
        end

        #
        # Gets or sets the struct's type system.
        #
        # @param [Module#[], nil] new_type_system
        #   The optional type system.
        #
        # @return [Types, Types::LittleEndian,
        #                 Types::BigEndian,
        #                 Types::Network]
        #
        def self.type_system(new_type_system=nil)
          if new_type_system
            @type_system = new_type_system
          else
            @type_system ||= if superclass < Struct
                               superclass.type_system
                             else
                               Types
                             end
          end
        end

        def self.derivative_classes
          @derivative_classes ||= {}
        end

        def self.as(endian: nil, arch: nil)
          derivative_classes[endian: endian, arch: arch] ||= (
            Class.new(self).tap do |struct_class|
              struct_class.class_exec do
                self.endian(endian) if endian
                self.arch(arch)     if arch
              end
            end
          )
        end

        #
        # The members in the structure.
        #
        # @return [Hash{Symbol => Member}]
        #   The field names and field information.
        #
        # @api private
        #
        def self.members
          @members ||= if superclass < Struct
                         superclass.members.dup
                       else
                         {}
                       end
        end

        #
        # Determines if the struct has the given member.
        #
        # @param [Symbol] name
        #   The member name.
        #
        # @return [Boolean]
        #   Specifies that the member exists in the structure.
        #
        def self.has_member?(name)
          members.has_key?(name.to_sym)
        end

        #
        # Initializes the structure and then packs it.
        #
        # @param [Hash{Symbol => Object}] values
        #   The values to initialize the struct with.
        #
        # @return [String]
        #   The packed struct.
        #
        def self.pack(values,**kwargs)
          new(values,**kwargs).to_s
        end

        #
        # Unpacks data into the structure.
        #
        # @param [String] data
        #   The data to unpack.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Unpacking keyword arguments.
        #
        # @option kwargs [:little, :big, :network] :endian
        #   The endianness to apply to the types.
        #
        # @return [Struct]
        #   The newly unpacked structure.
        #
        def self.unpack(data,**kwargs)
          new(data,**kwargs)
        end

        #
        # Reads a value from the structure.
        #
        # @param [Symbol] name
        #   The field name.
        #
        # @return [Integer, Float, String, Struct]
        #   The value of the field.
        #
        # @raise [ArgumentError]
        #   The structure does not contain the field.
        #
        def [](name)
          if (member = @type.members[name])
            case member.type
            when Types::AggregateType
              # TOOD: implement nested aggregate objects
            else
              data = super(member.offset,member.type.size)

              member.type.unpack(data)
            end
          else
            raise(ArgumentError,"no such member field #{name.inspect}")
          end
        end

        #
        # Writes a value to the structure.
        #
        # @param [Symbol] name
        #   The field name.
        #
        # @param [Integer, Float, String, Struct] value
        #   The value to write.
        #
        # @return [Integer, Float, String, Struct]
        #   The value of the field.
        #
        # @raise [ArgumentError]
        #   The structure does not contain the field.
        #
        def []=(name,value)
          if (member = @type.members[name])
            case member.type
            when Types::AggregateType
              # TOOD: implement nested aggregate objects
            else
              data = member.type.pack(value)

              super(member.offset,member.type.size,data)
            end
          else
            raise(ArgumentError,"no such member field: #{name.inspect}")
          end
        end

        #
        # Enumerates over the fields within the structure.
        #
        # @yield [name, value]
        #
        # @yieldparam [Symbol] name
        #
        # @yieldparam [Object] value
        #
        # @return [Enumerator]
        #
        def each_value(&block)
          return enum_for(__method__) unless block_given?

          @type.members.each_key  do |name|
            yield name, self[name]
          end
        end

        #
        # Converts the structure to a Hash.
        #
        # @return [Hash{Symbol => Object}]
        #   The hash of field names and values.
        #
        def to_h
          Hash[@type.members.keys.map { |name|
            [name, self[name]]
          }]
        end

        #
        # Converts the structure to an Array of values.
        #
        # @return [Array<Object>]
        #   The array of values within the structure.
        #
        def to_a
          @type.members.keys.map do |name|
            self[name]
          end
        end

        protected

        #
        # Sets or gets the default endianness of the structure.
        #
        # @param [:little, :big, :network] type
        #   The new endianness.
        #
        # @api public
        #
        def self.endian(new_endian)
          type_system(Types.endian(new_endian))
        end

        #
        # Sets or gets the default architecture for the structure.
        #
        # @param [Symbol] arch
        #   The new architecture.
        #
        # @api public
        #
        def self.arch(new_arch)
          type_system(Types.arch(new_arch))
        end

        #
        # Defines a field in the structure.
        #
        # @param [Symbol] name
        #   The name of the field.
        #
        # @param [Symbol, (Symbol, Integer), Range(Symbol)] type
        #   The type of the field.
        #
        # @example Defining a field:
        #   class MyStruct < Ronin::Support::Binary::Struct
        #     field :x, :uint32
        #   end
        #   
        #   struct = MyStruct.new
        #   struct.x = 0x11223344
        #
        # @example Defining an Array field:
        #   class MyStruct < Ronin::Support::Binary::Struct
        #     field :nums, [:uint32, 10]
        #   end
        #   
        #   struct = MyStruct.new
        #   struct.x = [0x11111111, 0x22222222, 0x33333333, 0x44444444]
        #
        # @example Defining an unbounded Array field:
        #   class MyStruct < Ronin::Support::Binary::Struct
        #     field :payload, :uint8..
        #   end
        #   
        #   struct = MyStruct.new
        #   struct.payloads = [0x1, 0x2, 0x3, 0x4]
        #
        # @api public
        #
        def self.member(name,type_signature,**kwargs)
          unless (type_signature.kind_of?(Symbol) || type_signature < Struct)
            raise(ArgumentError,"type signature is not a Symbol or #{Struct}: #{type_signature.inspect}")
          end

          type = resolve_type(type_signature)
          self.members[name] = Member.new(name,type_signature,type)

          define_method(name)       { self[name] }
          define_method("#{name}=") { |value| self[name] = value }
        end

        #
        # The type for the structure class.
        #
        # @return [Types::StructType]
        #   The underlying type.
        #
        def self.type
          @type ||= Types::StructType.new(
            Hash[members.map { |name,member| [name, member.type] }]
          )
        end

        #
        # The size of the struct.
        #
        # @return [Integer]
        #   The size of the struct in bytes.
        #
        def self.size
          type.size
        end

        #
        # The layout of the structure.
        #
        # @param [Array<(name, type)>] fields
        #   The new fields for the structure.
        #
        # @return [Array<Symbol>]
        #   The field names in order.
        #
        # @example
        #   layout :length, :uint32,
        #          :data,   [:uchar, 256]
        #
        # @note
        #   This method is mainly for compatibility with
        #   [FFI::Struct](https://rubydoc.info/gems/ffi/FFI/Struct).
        #
        # @api public
        #
        def self.layout(*fields)
          fields.each_slice(2) do |(name,type)|
            member(name,type)
          end
        end

        private

        #
        # Parses the type signature and returns the type using the structure's
        # {#type_system}.
        #
        # @param [Symbol, (Symbol, Integer), Range(Symbol),
        #        Class<Struct>, (Class<Struct>, Integer), Range(Class<Struct>),
        #        Types::Type, (Types::Type, Integer), Range(Types::Type)] type_signature
        # The type signature to parse.
        #
        # @return [Types::Type]
        #   The resolved type.
        #
        def self.resolve_type(type_signature)
          type, length = case type_signature
                         when Array then type_signature
                         when Range then [type_signature.begin, Float::INFINITY]
                         else            type_signature
                         end

          type = case type
                 when Struct       then type.type
                 when Types::Type  then type
                 when Array, Range then resolve_type(type)
                 when Symbol       then type_system[type]
                 else
                   raise(TypeError,"field type must be a Symbol, Type, or a Struct: #{type_signature.inspect}")
                 end

          case length
          when Float::INFINITY then type = type[]
          when Integer         then type = type[length]
          end

          return type
        end

      end
    end
  end
end
