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

require 'ronin/behaviors/exceptions/deploy_failed'
require 'ronin/behaviors/testable'
require 'ronin/ui/printing'

require 'parameters'

module Ronin
  module Behaviors
    #
    # Adds deployment methods.
    #
    # @since 0.6.0
    #
    module Deployable
      include Parameters, Testable, UI::Printing

      #
      # Initializes the deployable object.
      #
      # @param [Hash] attributes
      #   Additional attributes for the object.
      #
      # @api semipublic
      #
      def initialize(attributes={})
        super(attributes)

        @deploy_blocks = []
        @deployed = false

        @evacuate_blocks = []
        @evacuated = false
      end

      #
      # Determines whether the object was deployed.
      #
      # @return [Boolean]
      #   Specifies whether the object was previously deployed.
      #
      # @api semipublic
      #
      def deployed?
        @deployed == true
      end

      #
      # Tests and then deploys the object.
      #
      # @yield []
      #   If a block is given, it will be passed the deployed object
      #   after a successful deploy.
      #
      # @return [self]
      #
      # @see deploy
      #
      # @api semipublic
      #
      def deploy!
        test!

        print_info "Deploying #{self} ..."

        @deployed = false
        @deploy_blocks.each { |block| block.call() }
        @deployed = true
        @evacuated = false

        print_info "#{self} deployed!"

        yield if block_given?
        return self
      end

      #
      # Determines whether the object was evacuated.
      #
      # @return [Boolean]
      #   Specifies whether the object has been evacuated.
      #
      # @api semipublic
      #
      def evacuated?
        @evacuated == true
      end

      #
      # Evacuates the deployed object.
      #
      # @yield []
      #   If a block is given, it will be called before the object is
      #   evacuated.
      #
      # @return [self]
      #
      # @see #evacuate
      #
      # @api semipublic
      #
      def evacuate!
        yield if block_given?

        print_info "Evauating #{self} ..."

        @evacuated = false
        @evacuate_blocks.each { |block| block.call() }
        @evacuated = true
        @deployed = false

        print_info "#{self} evacuated."
        return self
      end

      protected

      #
      # Indicates the deployment of the object has failed.
      #
      # @raise [DeployFailed]
      #   The deployment of the object failed.
      #
      # @api public
      #
      def deploy_failed!(message)
        raise(DeployFailed,message)
      end

      #
      # Registers a given block to be called when the object is being
      # deployed.
      #
      # @yield []
      #   The given block will be called when the object is being
      #   deployed.
      #
      # @return [self]
      #
      # @api public
      #
      def deploy(&block)
        @deploy_blocks << block
        return self
      end

      #
      # Registers a given block to be called when the object is being
      # evacuated.
      #
      # @yield []
      #   The given block will be called when the object is being
      #   evacuated.
      #
      # @return [self]
      #
      # @api public
      #
      def evacuate(&block)
        @evacuate_blocks.unshift(block)
        return self
      end
    end
  end
end
