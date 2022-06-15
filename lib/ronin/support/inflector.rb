require 'strscan'

module Ronin
  module Support
    #
    # Provides inflector method for converting between `CamelCase` and
    # `under_scored`.
    #
    # @note
    #   If you need something more powerful, checkout
    #   [dry-inflector](https://dry-rb.org/gems/dry-inflector/0.1/)
    #
    # @api public
    #
    # @since 1.0.0
    #
    module Inflector
      #
      # Converts a `CamelCased` name to an `under_scored` name.
      #
      # @param [#to_s] name
      #   The CamelCased name.
      #
      # @return [String]
      #   The resulting under_scored name.
      #
      # @raise [ArgumentError]
      #   The given string contained non-alpha-numeric characters.
      #
      def self.underscore(name)
        scanner    = StringScanner.new(name.to_s)
        new_string = String.new

        until scanner.eos?
          if (separator = scanner.scan(/[_-]+/))
            new_string << ('_' * separator.length)
          else
            if (capitalized = scanner.scan(/[A-Z][a-z\d]+/))
              new_string << capitalized
            elsif (uppercase = scanner.scan(/[A-Z][A-Z\d]*(?=[A-Z_-]|$)/))
              new_string << uppercase
            elsif (lowercase = scanner.scan(/[a-z][a-z\d]*/))
              new_string << lowercase
            else
              raise(ArgumentError,"cannot convert string to underscored: #{scanner.string.inspect}")
            end

            if (separator = scanner.scan(/[_-]+/))
              new_string << ('_' * separator.length)
            elsif !scanner.eos?
              new_string << '_'
            end
          end
        end

        new_string.downcase!
        new_string
      end

      #
      # Converts an `under_scored` name to a `CamelCased` name.
      #
      # @param [String] name
      #   The under_scored name.
      #
      # @return [String]
      #   The CamelCased name.
      #
      # @raise [ArgumentError]
      #   The given under_scored string contained non-alpha-numeric characters.
      #
      def self.camelcase(name)
        scanner    = StringScanner.new(name.to_s)
        new_string = String.new

        until scanner.eos?
          if (word = scanner.scan(/[A-Za-z\d]+/))
            word.capitalize!
            new_string << word
          elsif scanner.scan(/[_-]+/)
            # skip
          elsif scanner.scan(/\//)
            new_string << '::'
          else
            raise(ArgumentError,"cannot convert string to CamelCase: #{scanner.string.inspect}")
          end
        end

        new_string
      end
    end
  end
end
