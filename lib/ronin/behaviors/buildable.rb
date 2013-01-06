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

require 'ronin/behaviors/exceptions/not_built'
require 'ronin/behaviors/exceptions/build_failed'
require 'ronin/behaviors/testable'
require 'ronin/ui/printing'

require 'parameters'

module Ronin
  module Behaviors
    #
    # Adds building methods.
    #
    # @since 0.6.0
    #
    module Buildable
      include Parameters, Testable, UI::Printing

      #
      # Initializes the buildable object.
      #
      # @param [Hash] attributes
      #   Additional attributes for the object.
      #
      # @api semipublic
      #
      def initialize(attributes={})
        super(attributes)

        @build_blocks = []
        @built = false
      end

      #
      # Determines whether the object has been built.
      #
      # @return [Boolean]
      #   Specifies whether the object is built.
      #
      # @api semipublic
      #
      def built?
        @built == true
      end

      #
      # Builds the object.
      #
      # @param [Hash] options
      #   Additional options to also use as parameters.
      #
      # @yield []
      #   The given block will be called after the object has been built.
      #
      # @see #build
      #
      # @api semipublic
      #
      def build!(options={})
        self.params = options
        print_debug "#{self} parameters: #{self.params.inspect}"

        print_info "Building #{self} ..."

        @built = false
        @build_blocks.each { |block| block.call() }
        @built = true

        print_info "#{self} built!"

        yield if block_given?
        return self
      end

      #
      # Tests that the object has been built and is properly configured.
      #
      # @return [true]
      #   The object has been tested.
      #
      # @raise [NotBuilt]
      #   The object has not been built, and cannot be verified.
      #
      # @see #test
      #
      # @api semipublic
      #
      def test!
        unless built?
          raise(NotBuilt,"must call build! before test!")
        end

        super
      end

      protected

      #
      # Indicates the build has failed.
      #
      # @raise [BuildFailed]
      #   The building of the object failed.
      #
      # @api public
      #
      def build_failed!(message)
        raise(BuildFailed,message)
      end

      #
      # Registers a given block to be called when the object is built.
      #
      # @yield []
      #   The given block will be called when the object is being built.
      #
      # @return [self]
      #
      # @api public
      #
      def build(&block)
        @build_blocks << block
        return self
      end
    end
  end
end
