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
require 'ronin/support/binary/types/mixin'
require 'ronin/support/binary/array'

module Ronin
  module Support
    module Binary
      #
      # Generic Binary Struct class.
      #
      # @note This class provides lazy memory mapped access to an underlying
      # buffer. This means values are decoded/encoded each time they are read
      # or written to.
      #
      # ## Examples
      #
      # ### Defining Fields
      #
      #     class Point < Ronin::Support::Binary::Struct
      #     
      #       member :x, :int32
      #       member :y, :int32
      #     
      #     end
      #     
      #     class Point3D < Point
      #     
      #       member :z, :int32
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
      #       member :x,    :uint32
      #       member :nums, [:uint8, 10]
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
      #       member :length,  :uint32
      #       member :payload, (:uint8..)
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
      #       member :x, :int32
      #       member :y, :int32
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
      #       member :x, :int32
      #       member :y, :int32
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
      #       member :length, :uint32
      #       member :data,   [:uchar, 48]
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
      # @api public
      #
      class Struct < Memory

        # The type system used by the struct.
                #
        # @return [Types::StructType]
        attr_reader :type

        #
        # Initializes the structure.
        #
        # @param [Hash{Symbol => Object}, String, ByteSlice] buffer_or_values
        #   Optional values to initialize the fields of the struct.
        #
        def initialize(buffer_or_values={})
          @type_system = self.class.type_system
          @type        = self.class.type

          @cache = {}

          case buffer_or_values
          when Hash
            super(@type.size)

            values = buffer_or_values
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
        # The type for the structure class.
        #
        # @return [Types::StructObjectType]
        #   The underlying type.
        #
        def self.type
          @type ||= type_resolver.resolve(self)
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
        # The alignment of the struct.
        #
        # @return [Integer]
        #   The alignment, in bytes, for the struct.
        #
        def self.alignment
          type.alignment
        end

        #
        # Translates the struct class using the given type system into a new
        # struct class.
        #
        # @param [:little, :big, :net, nil] endian
        #   The desired endian-ness.
        #
        # @param [:x86, :x86_64,
        #         :ppc, :ppc64,
        #         :mips, :mips_le, :mips_be,
        #         :mips64, :mips64_le, :mips64_be,
        #         :arm, :arm_le, :arm_be,
        #         :arm64, :arm64_le, :arm64_be, nil] arch
        #   The new architecture for the struct.
        #
        # @return [Class<Struct>]
        #
        def self.translate(endian: nil, arch: nil)
          struct_class = Class.new(self)

          if    arch   then struct_class.arch(arch)
          elsif endian then struct_class.endian(endian)
          end

          struct_class
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
        def self.pack(values)
          new(values).to_s
        end

        #
        # Unpacks data into the structure.
        #
        # @param [String] data
        #   The data to unpack.
        #
        # @return [Struct]
        #   The newly unpacked structure.
        #
        def self.unpack(data)
          new(data)
        end

        #
        # Reads a value from the structure.
        #
        # @param [Symbol] name
        #   The field name.
        #
        # @return [Integer, Float, String, Binary::Array, Binary::Struct]
        #   The value of the field.
        #
        # @raise [ArgumentError]
        #   The structure does not contain the field.
        #
        def [](name)
          if (member = @type.members[name])
            case member.type
            when Types::UnboundedArrayType
              # XXX: but how do we handle an unbounded array of structs?
              @cache[name] ||= (
                slice = byteslice(member.offset,size - member.offset)
                Binary::Array.new(member.type.type,slice)
              )
            when Types::ObjectType
              @cache[name] ||= (
                slice = byteslice(member.offset,member.type.size)
                member.type.unpack(slice)
              )
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
        # @param [Integer, Float, String, Array, Struct] value
        #   The value to write.
        #
        # @return [Integer, Float, String, Array, Struct]
        #   The value of the field.
        #
        # @raise [ArgumentError]
        #   The structure does not contain the field.
        #
        def []=(name,value)
          if (member = @type.members[name])
            data = member.type.pack(value)

            super(member.offset,member.type.size,data)
            return value
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
        def each(&block)
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
        # @return [::Array<Object>]
        #   The array of values within the structure.
        #
        def to_a
          @type.members.keys.map do |name|
            self[name]
          end
        end

        extend Types::Mixin

        #
        # Gets or sets the struct's endian-ness.
        #
        # @param [:little, :big, :net, nil] new_endian
        #   The desired endian-ness.
        #
        # @return [:little, :big, :net, nil]
        #   The struct's endian-ness.
        #
        def self.endian(new_endian=nil)
          if new_endian
            initialize_type_system(endian: new_endian)
            @endian = new_endian
          else
            @endian ||= if superclass < Struct
                          superclass.endian
                        end
          end
        end

        #
        # Gets or sets the struct's endian-ness.
        #
        # @param [:x86, :x86_64,
        #         :ppc, :ppc64,
        #         :mips, :mips_le, :mips_be,
        #         :mips64, :mips64_le, :mips64_be,
        #         :arm, :arm_le, :arm_be,
        #         :arm64, :arm64_le, :arm64_be, nil] new_arch
        #   The new architecture for the struct.
        #
        # @return [:little, :big, :net, nil]
        #   The struct's architecture.
        #
        def self.arch(new_arch=nil)
          if new_arch
            initialize_type_system(arch: new_arch)
            @arch = new_arch
          else
            @arch ||= if superclass < Struct
                          superclass.arch
                        end
          end
        end

        #
        # Gets or sets the struct's type system.
        #
        # @return [Types, Types::LittleEndian,
        #                 Types::BigEndian,
        #                 Types::Network]
        #
        # @abstract
        #
        def self.type_system
          Types
        end

        #
        # The type resolver using {type_system}.
        #
        # @return [Types::Resolver]
        #
        def self.type_resolver
          @resolver ||= Types::Resolver.new(type_system)
        end

        #
        # Defines a field in the structure.
        #
        # @param [Symbol] name
        #   The name of the field.
        #
        # @param [Symbol, (Symbol, Integer), Range(Symbol)] type_signature
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
          self.members[name] = Member.new(name,type_signature,**kwargs)

          define_method(name)       { self[name] }
          define_method("#{name}=") { |value| self[name] = value }
        end

      end

      #
      # Defines a new {Struct} sub-class with the desired endian-ness or
      # architecture.
      #
      # @param [:little, :big, :net, nil] endian
      #   The desired endian-ness.
      #
      # @param [:x86, :x86_64,
      #         :ppc, :ppc64,
      #         :mips, :mips_le, :mips_be,
      #         :mips64, :mips64_le, :mips64_be,
      #         :arm, :arm_le, :arm_be,
      #         :arm64, :arm64_le, :arm64_be, nil] arch
      #   The new architecture for the struct.
      #
      # @return [Class<Struct>]
      #   The configured {Struct} sub-class.
      #
      # @see Struct.translate
      #
      def self.Struct(endian: nil, arch: nil)
        Struct.translate(endian: endian, arch: arch)
      end
    end
  end
end
