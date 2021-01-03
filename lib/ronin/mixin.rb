#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

module Ronin
  #
  # A base Module for all other Mixin modules. Adds a `mixin` method
  # which includes/extends other Modules and evaluates a block of
  # code, within any Classes/Objects it is included/extended into.
  #
  #     module MyMixin
  #       include Mixin
  #
  #       mixin Paremters
  #
  #       mixin do
  #         parameter :user, :default => 'admin'
  #       end
  #     end
  #
  # @since 0.2.0
  #
  module Mixin
    #
    # Defines the `mixin` method when included.
    #
    # @since 0.2.0
    #
    def self.included(base)
      base.module_eval do
        protected

        #
        # Mixins in the modules or code block into other modules that the
        # module might be included or extended into.
        #
        # @param [Array<Module>] modules
        #   Other modules to mixin.
        #
        # @yield []
        #   The given code block will be evaluated into the modules
        #   the module is included or extended into.
        #
        # @since 0.2.0
        #
        # @api semipublic
        #
        def self.mixin(*modules,&block)
          unless modules.empty?
            @mixin_modules = modules
          end

          @mixin_block = block if block

          def self.included(base)
            if @mixin_modules
              base.send(:include,*@mixin_modules)
            end

            base.module_eval(&@mixin_block) if @mixin_block
          end

          def self.extended(base)
            if @mixin_modules
              base.send(:extend,*@mixin_modules)
            end

            base.instance_eval(&@mixin_block) if @mixin_block
          end
        end
      end
    end
  end
end
