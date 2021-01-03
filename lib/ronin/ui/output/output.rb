#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/output/terminal/raw'
require 'ronin/ui/output/terminal/color'

module Ronin
  module UI
    #
    # Controls {Output} from Ronin.
    #
    module Output
      @mode = if ($VERBOSE || $DEBUG) then :verbose
              else                         :quiet
              end

      @handler = if $stdout.tty? then Terminal::Color
                 else                 Terminal::Raw
                 end

      #
      # @return [Boolean]
      #   Specifies whether verbose output is enabled.
      #
      # @since 0.3.0
      #
      # @api semipublic
      #
      def self.verbose?
        @mode == :verbose
      end

      #
      # @return [Boolean]
      #   Specifies whether quiet output is enabled.
      #
      # @since 0.3.0
      #
      # @api semipublic
      #
      def self.quiet?
        @mode == :quiet
      end

      #
      # @return [Boolean]
      #   Specifies whether silent output is enabled.
      #
      # @since 0.3.0
      #
      # @api semipublic
      #
      def self.silent?
        @mode == :silent
      end

      #
      # Enables verbose output.
      #
      # @return [Output]
      #
      # @since 1.0.0
      #
      # @api semipublic
      #
      def self.verbose!
        @mode = :verbose
        return self
      end

      #
      # Disables verbose output.
      #
      # @return [Output]
      #
      # @since 1.0.0
      #
      # @api semipublic
      #
      def self.quiet!
        @mode = :quiet
        return self
      end

      #
      # Disables all output.
      #
      # @return [Output]
      #
      # @since 1.0.0
      #
      def self.silent!
        @mode = :silent
        return self
      end

      #
      # @return [Ronin::UI::Output::Handler]
      #   The current Output handler.
      #
      # @since 0.3.0
      #
      # @api semipublic
      #
      def self.handler
        @handler
      end

      #
      # Sets the current Output handler.
      #
      # @param [Handler] new_handler
      #   The new output handler to use. Must provide the `puts`,
      #   `print_info`, `print_debug`, `print_warning` and `print_error`
      #   class methods.
      #
      # @since 0.3.0
      #
      # @api semipublic
      #
      def self.handler=(new_handler)
        @handler = new_handler
      end
    end
  end
end
