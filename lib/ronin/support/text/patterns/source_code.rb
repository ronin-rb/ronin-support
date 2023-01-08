# frozen_string_literal: true
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Support
    module Text
      #
      # @since 0.3.0
      #
      module Patterns
        #
        # @group Source Code Patterns
        #

        # Regular expression to find deliminators in text
        #
        # @since 0.4.0
        DELIM = /[;&\n\r]/

        # Regular expression to find identifier in text
        #
        # @since 0.4.0
        IDENTIFIER = /[_]*[a-zA-Z]+[a-zA-Z0-9_-]*/

        # Regular expression to find all variable names in text.
        #
        # @see IDENTIFIER
        #
        # @since 1.0.0
        VARIABLE_NAME = /#{IDENTIFIER}(?=\s*=\s*[^;\n]+)/

        # Regular expression to find all variable assignments in text.
        #
        # @see VARIABLE_NAME
        #
        # @since 1.0.0
        VARIABLE_ASSIGNMENT = /#{IDENTIFIER}\s*=\s*[^;\n]+/

        # Regular expression to find all function names in text.
        #
        # @see IDENTIFIER
        #
        # @since 1.0.0
        FUNCTION_NAME = /#{IDENTIFIER}(?=\()/

        # Regular expression to find all double quoted strings in text.
        #
        # @since 1.0.0
        DOUBLE_QUOTED_STRING = /"(?:\\.|[^"])*"/

        # Regular expression to find all single quoted strings in text.
        #
        # @since 1.0.0
        SINGLE_QUOTED_STRING = /'(?:\\[\\']|[^'])*'/

        # Regular expression to find all single or double quoted strings in
        # text.
        #
        # @since 1.0.0
        STRING = /#{DOUBLE_QUOTED_STRING}|#{SINGLE_QUOTED_STRING}/

        # Regular expression to find all Base64 encoded strings in the text.
        #
        # @since 1.0.0
        BASE64 = /(?:[A-Za-z0-9+\/]{4}\n?)+(?:[A-Za-z0-9+\/]{2}==\n?|[A-Za-z0-9+\/]{3}=\n?)?|[A-Za-z0-9+\/]{2}==\n?|[A-Za-z0-9+\/]{3}=\n?/

        # Regular expression to match any single-line or multi-line C-style
        # comments.
        #
        # @since 1.0.0
        C_STYLE_COMMENT = %r{(?://(?:[^\r\n]*)(?:\r?\n|\z))+|(?:/\*[\s\S]*?\*/)}

        # Regular expression to match any single-line or multi-line C comments.
        #
        # @since 1.0.0
        C_COMMENT = C_STYLE_COMMENT

        # Regular expression to match any single-line or multi-line C++
        # comments.
        #
        # @since 1.0.0
        CPP_COMMENT = C_STYLE_COMMENT

        # Regular expression to match any single-line or multi-line Java
        # comments.
        #
        # @since 1.0.0
        JAVA_COMMENT = C_STYLE_COMMENT

        # Regular expression to match any single-line or multi-line JavaScript
        # comments.
        #
        # @since 1.0.0
        JAVASCRIPT_COMMENT = C_STYLE_COMMENT

        # Regular expression to match any single-line or multi-line shell-style
        # comments.
        #
        # @since 1.0.0
        SHELL_STYLE_COMMENT = /(?:#(?:[^\r\n]*)(?:\r?\n|\z))+/

        # Regular expression to match any single-line or multi-line shell script
        # comments.
        #
        # @since 1.0.0
        SHELL_COMMENT = SHELL_STYLE_COMMENT

        # Regular expression to match any single-line or multi-line Bash
        # comments.
        #
        # @since 1.0.0
        BASH_COMMENT = SHELL_STYLE_COMMENT

        # Regular expression to match any single-line or multi-line Ruby
        # comments.
        #
        # @since 1.0.0
        RUBY_COMMENT = SHELL_STYLE_COMMENT

        # Regular expression to match any single-line or multi-line Python
        # comments.
        #
        # @since 1.0.0
        PYTHON_COMMENT = SHELL_STYLE_COMMENT

        # Regular expression to match any single-line or multi-line comments.
        #
        # @since 1.0.0
        COMMENT = /#{SHELL_STYLE_COMMENT}|#{C_STYLE_COMMENT}/
      end
    end
  end
end
