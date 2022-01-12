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

module Ronin
  module CLI
    #
    # Defines ANSI colors.
    #
    # @api public
    #
    # @since 1.0.0
    #
    module ANSI
      # ANSI reset code
      RESET = "\e[0m"

      # ANSI code for bold text
      BOLD_ON = "\e[1m"

      # ANSI code to disable boldness
      BOLD_OFF = "\e[22m"

      # ANSI color code for black
      BLACK = "\e[30m"

      # ANSI color code for red
      RED = "\e[31m"

      # ANSI color code for green
      GREEN = "\e[32m"

      # ANSI color code for yellow
      YELLOW = "\e[33m"

      # ANSI color code for blue
      BLUE = "\e[34m"

      # ANSI color code for magenta
      MAGENTA = "\e[35m"

      # ANSI color code for cyan
      CYAN = "\e[36m"

      # ANSI color code for white
      WHITE = "\e[37m"

      # ANSI color for the default foreground color
      RESET_COLOR = "\e[39m"

      module_function

      #
      # Resets text formatting.
      #
      # @return [RESET]
      #
      # @see RESET
      #
      # @api public
      #
      def reset
        if $stdout.tty? then RESET
        else                 ''
        end
      end

      #
      # @see reset
      #
      # @api public
      #
      def clear
        reset
      end

      #
      # Bolds the text.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BOLD_ON]
      #   The bolded string or just {BOLD_ON} if no arguments were given.
      #
      # @see BOLD_ON
      #
      # @api public
      #
      def bold(string=nil)
        if string
          if $stdout.tty? then "#{BOLD_ON}#{string}#{BOLD_OFF}"
          else                 string
          end
        else
          if $stdout.tty? then BOLD_ON
          else                 ''
          end
        end
      end

      #
      # @group Foreground Color Methods
      #

      #
      # Sets the text color to black.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BLACK]
      #   The colorized string or just {BLACK} if no arguments were given.
      #
      # @see BLACK
      #
      # @api public
      #
      def black(string=nil)
        if string
          if $stdout.tty? then "#{BLACK}#{string}#{RESET_COLOR}"
          else                 string
          end
        else
          if $stdout.tty? then BLACK
          else                 ''
          end
        end
      end

      #
      # Sets the text color to red.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, RED]
      #   The colorized string or just {RED} if no arguments were given.
      #
      # @see RED
      #
      # @api public
      #
      def red(string=nil)
        if string
          if $stdout.tty? then "#{RED}#{string}#{RESET_COLOR}"
          else                 string
          end
        else
          if $stdout.tty? then RED
          else                 ''
          end
        end
      end

      #
      # Sets the text color to green.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, GREEN]
      #   The colorized string or just {GREEN} if no arguments were given.
      #
      # @see GREEN
      #
      # @api public
      #
      def green(string=nil)
        if string
          if $stdout.tty? then "#{GREEN}#{string}#{RESET_COLOR}"
          else                 string
          end
        else
          if $stdout.tty? then GREEN
          else                 ''
          end
        end
      end

      #
      # Sets the text color to yellow.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, YELLOW]
      #   The colorized string or just {YELLOW} if no arguments were given.
      #
      # @see YELLOW
      #
      # @api public
      #
      def yellow(string=nil)
        if string
          if $stdout.tty? then "#{YELLOW}#{string}#{RESET_COLOR}"
          else                 string
          end
        else
          if $stdout.tty? then YELLOW
          else                 ''
          end
        end
      end

      #
      # Sets the text color to blue.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BLUE]
      #   The colorized string or just {BLUE} if no arguments were given.
      #
      # @see BLUE
      #
      # @api public
      #
      def blue(string=nil)
        if string
          if $stdout.tty? then "#{BLUE}#{string}#{RESET_COLOR}"
          else                 string
          end
        else
          if $stdout.tty? then BLUE
          else                 ''
          end
        end
      end

      #
      # Sets the text color to magenta.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, MAGENTA]
      #   The colorized string or just {MAGENTA} if no arguments were given.
      #
      # @see MAGENTA
      #
      # @api public
      #
      def magenta(string=nil)
        if string
          if $stdout.tty? then "#{MAGENTA}#{string}#{RESET_COLOR}"
          else                 string
          end
        else
          if $stdout.tty? then MAGENTA
          else                 ''
          end
        end
      end

      #
      # Sets the text color to cyan.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, CYAN]
      #   The colorized string or just {CYAN} if no arguments were given.
      #
      # @see CYAN
      #
      # @api public
      #
      def cyan(string=nil)
        if string
          if $stdout.tty? then "#{CYAN}#{string}#{RESET_COLOR}"
          else                 string
          end
        else
          if $stdout.tty? then CYAN
          else                 ''
          end
        end
      end

      #
      # Sets the text color to white.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, WHITE]
      #   The colorized string or just {WHITE} if no arguments were given.
      #
      # @see WHITE
      #
      # @api public
      #
      def white(string=nil)
        if string
          if $stdout.tty? then "#{WHITE}#{string}#{RESET_COLOR}"
          else                 string
          end
        else
          if $stdout.tty? then WHITE
          else                 ''
          end
        end
      end

    end
  end
end
