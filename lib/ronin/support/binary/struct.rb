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
require 'ronin/support/binary/struct/member'
require 'ronin/support/binary/ctypes/mixin'
require 'ronin/support/binary/ctypes/type_resolver'
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
      # ### Defining Members
      #
      #     class Point < Ronin::Support::Binary::Struct
      #
      #       member :x, :int32
      #       member :y, :int32
      #
      #     end
      #
      # ### Initializing Structs
      #
      # From a Hash:
      #
      #     point = Point.new(x: 1, y: 2)
      #
      # From a buffer:
      #
      #     point = Point.new("\x01\x00\x00\x00\xFF\xFF\xFF\xFF")
      #
      # ### Reading Fields
      #
      #     point = Point.new("\x01\x00\x00\x00\xFF\xFF\xFF\xFF")
      #     point[:x]
      #     # => 1
      #     point[:y]
      #     # => -1
      #
      #     point.x
      #     # => 1
      #     point.y
      #     # => -1
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
      #     # => "\n\x00\x00\x00\xFF\xFF\xFF\xFF"
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
      #     point = Point.unpack("\x00\x00\x00\x01\xFF\xFF\xFF\xFF")
      #     point.x
      #     # => 1
      #     point.y
      #     # => -1
      #
      # ### Inheriting Structs
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
      #     struct.pack
      #     # => "\x00\x00\x00\x00\x01\x02\x03\x04\x00\x00\x00\x00\x00\x00"
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
      #     struct.payload = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
      #     struct.pack
      #     # => "\x00\x00\x00\x00\x01\x02\x03\x04\x05\x06\a\b"
      #
      # ### Struct Endianness
      #
      #     class MyStruct < Ronin::Support::Binary::Struct
      #
      #       platform endian: :big
      #
      #       member :x, :uint32
      #       member :y, :uint32
      #
      #     end
      #
      #     struct = MyStruct.new
      #     struct.x = 0xAABB
      #     struct.y = 0xCCDD
      #     struct.pack
      #     # => "\x00\x00\xAA\xBB\x00\x00\xCC\xDD"
      #
      # ### Struct Architecture
      #
      #     class MyStruct < Ronin::Support::Binary::Struct
      #
      #       platform arch: :arm64_be
      #
      #       member :x, :int
      #       member :y, :int
      #       member :f, :double
      #
      #     end
      #
      #     struct = MyStruct.new
      #     struct.x = 100
      #     struct.y = -100
      #     struct.f = (90 / Math::PI)
      #     struct.pack
      #     # => "\x00\x00\x00d\xFF\xFF\xFF\x9C@<\xA5\xDC\x1Ac\xC1\xF8"
      #
      # ### Struct Operating System (OS)
      #
      #     class MyStruct < Ronin::Support::Binary::Struct
      #
      #       platform arch: :x86_64, os: :windows
      #
      #       member :x, :long
      #       member :y, :long
      #
      #     end
      #
      #     struct = MyStruct.new
      #     struct.x = 255
      #     struct.y = -1
      #     struct.pack
      #     # => "\xFF\x00\x00\x00\xFF\xFF\xFF\xFF"
      #
      # ### Struct Alignment
      #
      #     class Pixel < Ronin::Support::Binary::Struct
      #
      #       align 4
      #
      #       member :r, :uint8
      #       member :g, :uint8
      #       member :b, :uint8
      #
      #     end
      #
      #     class PixelBuf < Ronin::Support::Binary::Struct
      #
      #       member :count, :uint8
      #       member :pixels, [Pixel, 255]
      #
      #     end
      #
      #     pixelbuf = PixelBuf.new
      #     pixelbuf.count = 2
      #     pixelbuf.pixels[0].r = 0xAA
      #     pixelbuf.pixels[0].g = 0xBB
      #     pixelbuf.pixels[0].b = 0xCC
      #     pixelbuf.pixels[1].r = 0xAA
      #     pixelbuf.pixels[1].g = 0xBB
      #     pixelbuf.pixels[1].b = 0xCC
      #     pixelbuf.pack
      #     # => "\x02\x00\x00\x00\xAA\xBB\xCC\xAA\xBB\xCC..."
      #
      # ### Disable Struct Padding
      #
      #     class MyStruct < Ronin::Support::Binary::Struct
      #
      #       padding false
      #
      #       member :c, :char
      #       member :i, :int32
      #
      #     end
      #
      #     struct = MyStruct.new
      #     struct.c = 'A'
      #     struct.i = -1
      #     struct.pack
      #     # => "A\xFF\xFF\xFF\xFF"
      #
      # @api public
      #
      class Struct < Memory

        # The type system used by the struct.
        #
        # @return [CTypes::StructType]
        #
        # @api private
        attr_reader :type

        #
        # Initializes the struct.
        #
        # @param [Hash{Symbol => Object}, String, ByteSlice] buffer_or_values
        #   Optional values to initialize the members of the struct.
        #
        # @example Initiializing a new struct from a buffer:
        #   class MyStruct < Ronin::Support::Binary::Struct
        #
        #     member :x,    :uint32
        #     member :f,    :double
        #     member :nums, [:uint8, 10]
        #
        #   end
        #
        #   struct = MyStruct.new("\x01\x00\x00\x00\x00\x00\x00\x00333333\xD3?\x01\x02\x03\x00\x00\x00\x00\x00\x00\x00")
        #   struct.x
        #   # => 1
        #   struct.f
        #   # => 0.3
        #   struct.nums.to_a
        #   # => [1, 2, 3, 0, 0, 0, 0, 0, 0, 0]
        #
        # @example Initializing a new struct with values:
        #   struct = MyStruct.new(x: 1, f: 0.3, nums: [1,2,3])
        #   struct.x
        #   # => 1
        #   struct.f
        #   # => 0.3
        #   struct.nums.to_a
        #   # => [1, 2, 3, 0, 0, 0, 0, 0, 0, 0]
        #
        # @api public
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
        # The type for the struct class.
        #
        # @return [CTypes::StructObjectType]
        #   The underlying type.
        #
        # @api semipublic
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
        # @example
        #   class MyStruct < Ronin::Support::Binary::Struct
        #
        #     member :x, :uint32
        #     member :y, :uint32
        #
        #   end
        #
        #   MyStruct.size
        #   # => 8
        #
        # @api public
        #
        def self.size
          type.size
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
        # The members in the struct.
        #
        # @return [Hash{Symbol => Member}]
        #   The member names and type information.
        #
        # @api semipublic
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
        #   Specifies that the member exists in the struct.
        #
        # @api semipublic
        #
        def self.has_member?(name)
          members.has_key?(name.to_sym)
        end

        #
        # Initializes the struct and then packs it.
        #
        # @param [Hash{Symbol => Object}] values
        #   The values to initialize the struct with.
        #
        # @return [String]
        #   The packed struct.
        #
        # @example
        #   class MyStruct < Ronin::Support::Binary::Struct
        #
        #     member :x,    :uint32
        #     member :f,    :double
        #     member :nums, [:uint8, 10]
        #
        #   end
        #
        #   MyStruct.pack(x: 1, f: 0.3, nums: [1,2,3])
        #   # => "\x01\x00\x00\x00\x00\x00\x00\x00333333\xD3?\x01\x02\x03\x00\x00\x00\x00\x00\x00\x00"
        #
        # @api public
        #
        def self.pack(values)
          new(values).to_s
        end

        #
        # Unpacks data into the struct.
        #
        # @param [String] data
        #   The data to unpack.
        #
        # @return [Struct]
        #   The newly unpacked struct.
        #
        # @example
        #   class MyStruct < Ronin::Support::Binary::Struct
        #
        #     member :x,    :uint32
        #     member :f,    :double
        #     member :nums, [:uint8, 10]
        #
        #   end
        #
        #   struct = MyStruct.unpack("\x01\x00\x00\x00\x00\x00\x00\x00333333\xD3?\x01\x02\x03\x00\x00\x00\x00\x00\x00\x00")
        #
        # @api public
        #
        def self.unpack(data)
          new(data)
        end

        #
        # Reads the struct from the IO stream.
        #
        # @param [IO] io
        #   The IO object to read from.
        #
        # @return [Struct]
        #   The read struct.
        #
        # @example
        #   class MyStruct < Ronin::Support::Binary::Struct
        #
        #     member :x,    :uint32
        #     member :f,    :double
        #     member :nums, [:uint8, 10]
        #
        #   end
        #
        #   file   = File.new('binary.dat','b')
        #   struct = MyStruct.read_from(file)
        #
        # @see #read_from
        #
        # @api public
        #
        def self.read_from(io)
          new.read_from(io)
        end

        #
        # Reads a value from the struct.
        #
        # @param [Symbol] name
        #   The member name.
        #
        # @return [Integer, Float, String, Binary::Array, Binary::Struct]
        #   The value of the member.
        #
        # @raise [ArgumentError]
        #   The struct does not contain the member.
        #
        # @example
        #   class MyStruct < Ronin::Support::Binary::Struct
        #
        #     member :x,    :uint32
        #     member :f,    :double
        #     member :nums, [:uint8, 10]
        #
        #   end
        #
        #   struct = MyStruct.new("\x01\x00\x00\x00\x00\x00\x00\x00333333\xD3?\x01\x02\x03\x00\x00\x00\x00\x00\x00\x00")
        #   struct[:x]
        #   # => 1
        #   struct[:f]
        #   # => 0.3
        #   struct[:nums].to_a
        #   # => [1, 2, 3, 0, 0, 0, 0, 0, 0, 0]
        #
        # @api public
        #
        def [](name)
          if (member = @type.members[name])
            case member.type
            when CTypes::UnboundedArrayType
              # XXX: but how do we handle an unbounded array of structs?
              @cache[name] ||= begin
                                 offset = member.offset
                                 length = size - member.offset
                                 slice  = byteslice(offset,length)

                                 Binary::Array.new(member.type.type,slice)
                               end
            when CTypes::ObjectType
              @cache[name] ||= begin
                                 offset = member.offset
                                 length = member.type.size
                                 slice  = byteslice(offset,length)

                                 member.type.unpack(slice)
                               end
            else
              data = super(member.offset,member.type.size)
              member.type.unpack(data)
            end
          else
            raise(ArgumentError,"no such member: #{name.inspect}")
          end
        end

        #
        # Writes a value to the struct.
        #
        # @param [Symbol] name
        #   The member name.
        #
        # @param [Integer, Float, String, Array, Struct] value
        #   The value to write.
        #
        # @return [Integer, Float, String, Array, Struct]
        #   The value of the member.
        #
        # @raise [ArgumentError]
        #   The struct does not contain the member.
        #
        # @example
        #   class MyStruct < Ronin::Support::Binary::Struct
        #
        #     member :x,    :uint32
        #     member :f,    :double
        #     member :nums, [:uint8, 10]
        #
        #   end
        #
        #   struct = MyStruct.new
        #   struct[:x] = 1
        #   struct[:x]
        #   # => 1
        #   struct[:f] = 0.3
        #   struct[:f]
        #   # => 0.3
        #   struct[:nums] = [1,2,3]
        #   struct[:nums].to_a
        #   # => [1, 2, 3, 0, 0, 0, 0, 0, 0, 0]
        #
        # @api public
        #
        def []=(name,value)
          if (member = @type.members[name])
            data = member.type.pack(value)

            super(member.offset,member.type.size,data)
            return value
          else
            raise(ArgumentError,"no such member: #{name.inspect}")
          end
        end

        #
        # Enumerates over the members within the struct.
        #
        # @yield [name, value]
        #   If a block is given, it will be passed each member name and value
        #   from within the struct.
        #
        # @yieldparam [Symbol] name
        #   The name of the struct memeber.
        #
        # @yieldparam [Object] value
        #   The decoded value of the struct member.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator object will be returned.
        #
        # @api public
        #
        def each(&block)
          return enum_for(__method__) unless block_given?

          @type.members.each_key do |name|
            yield name, self[name]
          end
        end

        #
        # Converts the struct to a Hash.
        #
        # @return [Hash{Symbol => Object}]
        #   The hash of member names and values.
        #
        # @api public
        #
        def to_h
          each.to_h
        end

        #
        # Converts the struct to an Array of values.
        #
        # @return [::Array<Object>]
        #   The array of values within the struct.
        #
        # @api public
        #
        def to_a
          each.map { |name,value| value }
        end

        extend CTypes::Mixin

        #
        # Gets or sets the struct's target platform.
        #
        # @param [:little, :big, :net, nil] endian
        #   The desired endianness for the struct.
        #
        # @param [:x86, :x86_64,
        #         :ppc, :ppc64,
        #         :mips, :mips_le, :mips_be,
        #         :mips64, :mips64_le, :mips64_be,
        #         :arm, :arm_le, :arm_be,
        #         :arm64, :arm64_le, :arm64_be] arch
        #   The desired architecture for the struct.
        #
        # @param [:linux, :macos, :windows, :android,
        #         :bsd, :freebsd, :openbsd, :netbsd] os
        #   The Operating System (OS) for the struct.
        #
        # @return [Hash{Symbol => Object}]
        #   The platform configuration Hash.
        #
        # @api public
        #
        def self.platform(endian: nil, arch: nil, os: nil)
          if endian || arch || os
            @type_system = CTypes.platform(endian: endian, arch: arch, os: os)
            @platform    = {endian: endian, arch: arch, os: os}
          else
            @platform ||= if superclass < Struct
                            superclass.platform
                          else
                            {}
                          end
          end
        end

        #
        # The alignment of the struct.
        #
        # @return [Integer]
        #   The alignment, in bytes, for the struct.
        #
        # @api public
        #
        def self.alignment
          @alignment ||= if superclass < Struct
                           superclass.alignment
                         end
        end

        #
        # Sets the alignment of the struct.
        #
        # @param [Integer] new_alignment
        #   The new alignment for the struct.
        #
        # @api public
        #
        def self.align(new_alignment)
          @alignment = new_alignment
        end

        #
        # Gets or sets whether the struct's members will have padding.
        #
        # @param [Boolean, nil] new_padding
        #   The optional new value for {padding}.
        #
        # @return [Boolean]
        #   Specifies whether the struct's members will be padded.
        #
        # @api public
        #
        def self.padding(new_padding=nil)
          unless new_padding.nil?
            @padding = new_padding
          else
            if @padding.nil?
              @padding = if superclass < Struct
                           superclass.padding
                         else
                           true
                         end
            else
              @padding
            end
          end
        end

        #
        # Gets or sets the struct's type system.
        #
        # @return [Types, CTypes::LittleEndian,
        #                 CTypes::BigEndian,
        #                 CTypes::Network]
        #
        # @api semipublic
        #
        def self.type_system
          @type_system ||= if superclass < Struct
                             superclass.type_system
                           else
                             CTypes
                           end
        end

        #
        # The type resolver using {type_system}.
        #
        # @return [CTypes::TypeResolver]
        #
        # @api semipublic
        #
        def self.type_resolver
          @type_resolver ||= CTypes::TypeResolver.new(type_system)
        end

        #
        # Defines a member in the struct.
        #
        # @param [Symbol] name
        #   The name of the member.
        #
        # @param [Symbol, (Symbol, Integer), Range(Symbol)] type_signature
        #   The type of the member.
        #
        # @example Defining a member:
        #   class MyStruct < Ronin::Support::Binary::Struct
        #     member :x, :uint32
        #   end
        #
        #   struct = MyStruct.new
        #   struct.x = 0x11223344
        #
        # @example Defining an Array member:
        #   class MyStruct < Ronin::Support::Binary::Struct
        #     member :nums, [:uint32, 10]
        #   end
        #
        #   struct = MyStruct.new
        #   struct.x = [0x11111111, 0x22222222, 0x33333333, 0x44444444]
        #
        # @example Defining an unbounded Array member:
        #   class MyStruct < Ronin::Support::Binary::Struct
        #     member :payload, :uint8..
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
      # @return [Class<Binary::Struct>]
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
