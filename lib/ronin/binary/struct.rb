#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/binary/template'

require 'set'

module Ronin
  module Binary
    #
    # Generic Binary Struct class.
    #
    #     class Packet < Binary::Struct
    #     
    #       layout :length, :uint32,
    #              :data, [:uchar, 256]
    #
    #       def length
    #         @length || data.length
    #       end
    #     
    #     end
    #
    class Struct

      #
      # Initializes the structure.
      #
      def initialize
        # initialize the fields in order
        self.class.layout.each do |name|
          self[name] = self.class.default(self.class.fields[name])
        end
      end

      #
      # The fields in the structure.
      #
      # @return [Hash{Symbol => type, (type, length)}]
      #   The field names and types.
      #
      def self.fields
        @fields ||= {}
      end

      #
      # Determines if a field exists in the structure.
      #
      # @param [Symbol] name
      #   The field name.
      #
      # @return [Boolean]
      #   Specifies that the field exists in the structure.
      #
      def self.field?(name)
        fields.has_key?(name.to_sym)
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
      def self.layout(*fields)
        unless fields.empty?
          @layout = []
          @fields = {}

          fields.each_slice(2) do |name,(type,length)|
            type = typedefs.fetch(type,type)

            unless (type.kind_of?(Symbol) || type < Struct)
              raise(TypeError,"#{type.inspect} is not a Symbol or #{Struct}")
            end

            @layout      << name
            @fields[name] = [type, length]

            attr_accessor name
          end
        end

        return (@layout ||= [])
      end

      #
      # The templates for the structure.
      #
      # @return [Hash{Symbol => Template}]
      #   The templates for each endianness.
      #
      def self.templates
        @templates ||= Hash.new do |hash,endian|
          hash[endian] = template(endian)
        end
      end

      #
      # Creates a new template for the structure.
      #
      # @param [Symbol] endian
      #   The endianness for the template.
      #
      # @return [Template]
      #   The new template.
      #
      def self.template(endian=self.endian)
        template = Template.new

        each_field do |struct,name,(type,length)|
          if type.kind_of?(Symbol)
            if (endian && ENDIAN_TYPES.include?(type))
              # translate types to a specific endianness
              type = case endian
                     when :little
                       :"#{type}_le"
                     when :big, :network
                       :"#{type}_be"
                     end
            end
          end

          template << [type, length]
        end

        return template
      end

      #
      # Unpacks data into the structure.
      #
      # @param [String] data
      #   The data to unpack.
      #
      # @param [Symbol] endian
      #   The endianness of the data.
      #
      # @return [Struct]
      #   The newly unpacked structure.
      def self.unpack(data,endian=self.endian)
        new().unpack(data,endian)
      end

      #
      # Determines if a field exists in the structure.
      #
      # @param [Symbol] name
      #   The name of the field.
      #
      # @return [Boolean]
      #   Specifies whether the field exists.
      #
      def field?(name)
        self.class.field?(name)
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
        if field?(name)
          send(name)
        else
          raise(ArgumentError,"no such field '#{name}'")
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
        if field?(name)
          send("#{name}=",value)
        else
          raise(ArgumentError,"no such field '#{name}'")
        end
      end

      #
      # The values within the structure.
      #
      # @return [Array<Integer, Float, String, Struct>]
      #   The values of the fields.
      #
      def values
        normalize = lambda { |value|
          case value
          when Struct
            value.values
          else
            value
          end
        }

        self.class.layout.map do |name|
          case (value = self[name])
          when Array
            value.map(&normalize)
          else
            normalize[value]
          end
        end
      end

      #
      # Clears the fields of the structure.
      #
      # @return [Struct]
      #   The cleared structure.
      #
      def clear
        each_field do |struct,name,field|
          struct[name] = self.class.default(field)
        end

        return self
      end

      #
      # Packs the structure.
      #
      # @param [:little, :big, :network] endian
      #   Endianness.
      #
      # @return [String]
      #   The packed structure.
      #
      def pack(endian=self.class.endian)
        self.class.template(endian).pack(*values.flatten)
      end

      #
      # Unpacks data into the structure.
      #
      # @param [String] data
      #   The data to unpack.
      #
      # @param [:little, :big, :network] endian
      #   Endianness.
      #
      # @return [Struct]
      #   The unpacked structure.
      #
      def unpack(data,endian=self.class.endian)
        values = self.class.template(endian).unpack(data)

        each_field do |struct,name,(type,length)|
          struct[name] = if length
                           if STRING_TYPES.include?(type)
                             # string types are combined into a single String
                             values.shift
                           else
                             # shift off an Array of elements
                             values.shift(length)
                           end
                         else
                           values.shift
                         end
        end

        return self
      end

      #
      # @see #pack
      #
      def to_s
        pack
      end

      #
      # @see #pack
      #
      def to_str
        pack
      end

      #
      # Inspects the structure.
      #
      # @return [String]
      #   The inspected structure.
      #
      def inspect
        "#<#{self.class}: " << self.class.layout.map { |name|
          "#{name}: " << self[name].inspect
        }.join(', ') << '>'
      end

      protected

      # Types which have little/big endian forms
      ENDIAN_TYPES = Set[
        :uint16,
        :uint32,
        :uint64,
        :int16,
        :int32,
        :int64,
        :ushort,
        :uint,
        :ulong,
        :ulong_long,
        :short,
        :int,
        :long,
        :long_long,
        :float,
        :double
      ]

      # Integer types
      INT_TYPES = Set[
        :uint8,
        :uint16,
        :uint32,
        :uint64,

        :int8,
        :int16,
        :int32,
        :int64,

        :ubyte,
        :ushort,
        :uint,
        :ulong,
        :ulong_long,

        :byte,
        :short,
        :int,
        :long,
        :long_long,

        :uint16_le,
        :uint32_le,
        :uint64_le,

        :int16_le,
        :int32_le,
        :int64_le,

        :ushort_le,
        :uint_le,
        :ulong_le,
        :ulong_long_le,

        :short_le,
        :int_le,
        :long_le,
        :long_long_le,

        :uint16_be,
        :uint32_be,
        :uint64_be,

        :int16_be,
        :int32_be,
        :int64_be,

        :ushort_be,
        :uint_be,
        :ulong_be,
        :ulong_long_be,

        :short_be,
        :int_be,
        :long_be,
        :long_long_be
      ]

      # Float types
      FLOAT_TYPES = Set[
        :float,
        :double,
        :float_le,
        :double_le,
        :float_be,
        :double_be
      ]

      # Character types
      CHAR_TYPES = Set[:uchar, :char]

      # String types
      STRING_TYPES = CHAR_TYPES + Set[:string]

      #
      # Sets or gets the endianness of the structure.
      #
      # @param [:little, :big, :network, nil] type
      #   The new endianness.
      #
      # @return [:little, :big, :network, nil]
      #   The endianness of the structure.
      #
      def self.endian(type=nil)
        if type
          @endian = type.to_sym
        else
          @endian
        end
      end

      #
      # Typedefs.
      #
      # @return [Hash{Symbol => Symbol}]
      #   The typedef aliases.
      #
      def self.typedefs
        @@typedefs ||= {}
      end

      #
      # Defines a typedef.
      #
      # @param [Symbol] type
      #   The original type.
      #
      # @param [Symbol] type_alias
      #   The new type.
      #
      def self.typedef(type,type_alias)
        type = typedefs.fetch(type,type)

        unless (type.kind_of?(Symbol) || type < Struct)
          raise(TypeError,"#{type.inspect} is not a Symbol or #{Struct}")
        end

        typedefs[type_alias] = typedefs.fetch(type,type)
      end

      # core typedefs
      typedef :ulong, :pointer
      typedef :uchar, :bool

      # _t typedefs
      typedef :uint8, :uint8_t
      typedef :uint16, :uint16_t
      typedef :uint32, :uint32_t
      typedef :uint64, :uint64_t
      typedef :int8, :int8_t
      typedef :int16, :int16_t
      typedef :int32, :int32_t
      typedef :int64, :int64_t

      typedef :uint16_be,     :uint16_net
      typedef :uint32_be,     :uint32_net
      typedef :uint64_be,     :uint64_net
      typedef :int16_be,      :int16_net
      typedef :int32_be,      :int32_net
      typedef :int64_be,      :int64_net
      typedef :ushort_be,     :ushort_net
      typedef :uint_be,       :uint_net
      typedef :ulong_be,      :ulong_net
      typedef :ulong_long_be, :ulong_long_net
      typedef :int_be,        :int_net
      typedef :long_be,       :long_net
      typedef :long_long_be,  :long_long_net

      # libc typedefs
      typedef :long,  :blkcnt_t
      typedef :pointer, :caddr_t
      typedef :int, :clockid_t
      typedef :int, :daddr_t
      typedef :ulong, :dev_t
      typedef :long, :fd_mask
      typedef :ulong, :fsblkcnt_t
      typedef :ulong, :fsfilcnt_t
      typedef :uint32, :git_t
      typedef :uint32, :id_t
      typedef :ulong, :ino_t
      typedef :int32, :key_t
      typedef :long, :loff_t
      typedef :uint32, :mode_t
      typedef :ulong, :nlink_t
      typedef :long, :off_t
      typedef :int32, :pid_t
      typedef :uint32, :pthread_key_t
      typedef :int32, :pthread_once_t
      typedef :ulong, :pthread_t
      typedef :long, :quad_t
      typedef :long, :register_t
      typedef :ulong, :rlim_t
      typedef :uint16, :sa_family_t
      typedef :ulong, :size_t
      typedef :uint32, :socklen_t
      typedef :long, :suseconds_t
      typedef :long,  :ssize_t
      typedef :long, :time_t
      typedef :pointer, :timer_t
      typedef :uint32, :uid_t

      #
      # Default value for a field.
      #
      # @param [type, (type, length)] type
      #   The type of the field.
      #
      # @return [Integer, Float, String, Struct]
      #   The default value for the type.
      #
      def self.default(type)
        type, length = type

        if length
          if STRING_TYPES.include?(type)
            # arrays of chars should be Strings
            String.new
          else
            # create an array of values
            Array.new(length) { |index| default(type) }
          end
        else
          if type.kind_of?(Symbol)
            if INT_TYPES.include?(type)
              0
            elsif FLOAT_TYPES.include?(type)
              0.0
            elsif CHAR_TYPES.include?(type)
              "\0"
            elsif STRING_TYPES.include?(type)
              ''
            end
          elsif type < Struct
            type.new
          end
        end
      end
      
      #
      # Enumerates the fields of the structure, and all nested structures.
      #
      # @yield [struct, name, type]
      #   The given block will be passed each structure, field name and field
      #   type.
      #
      # @yieldparam [Struct] struct
      #   The structure class.
      #
      # @yieldparam [Symbol] name
      #   The name of the field.
      #
      # @yieldparam [type, (type, length)] type
      #   The type of the field.
      #
      def self.each_field(&block)
        layout.each do |name|
          type, length = field = fields[name]

          if type.kind_of?(Symbol)
            yield self, name, field
          elsif type < Struct
            (length || 1).times do
              type.each_field(&block)
            end
          end
        end
      end

      #
      # Enumerates the fields of the structure, and all nested structure.
      #
      # @yield [struct, name, type]
      #   The given block will be passed each structure, field name and type.
      #
      # @yieldparam [Struct] struct
      #   The structure instance.
      #
      # @yieldparam [Symbol] name
      #   The name of the field.
      #
      # @yieldparam [type, (type, length)] type
      #   The type of the field.
      #
      def each_field(&block)
        self.class.layout.each do |name|
          type, length = field = self.class.fields[name]

          if type.kind_of?(Symbol)
            yield self, name, field
          elsif type < Struct
            if length
              self[name].each do |struct|
                struct.each_field(&block)
              end
            else
              self[name].each_field(&block)
            end
          end
        end
      end

    end
  end
end
