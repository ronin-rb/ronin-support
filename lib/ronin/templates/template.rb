#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'data_paths/finders'

module Ronin
  module Templates
    #
    # The {Template} module allows a class to find templates and manage
    # multiple template directories. The {Template} module also can find
    # templates within `data/` directories using `DataPaths::Finders`.
    #
    module Template
      include DataPaths::Finders

      protected

      #
      # A stack of directories to search for other templates within.
      #
      # @return [Array]
      #   The stack of directory paths.
      #
      # @api semipublic
      #
      def template_dirs
        @template_dirs ||= []
      end

      #
      # The first path in {#template_dirs}, that will be used to search for
      # other templates in.
      #
      # @return [String, nil]
      #   Returns the first path in {#template_dirs}, or `nil` if
      #   {#template_dirs} is empty.
      #
      # @api semipublic
      #
      def template_dir
        template_dirs.first
      end

      #
      # Finds the template within the {#template_dir} or uses
      # `DataPaths::Finders#find_data_file` to search through all
      # `data/` directories for the template.
      #
      # @param [String] sub_path
      #   The relative path of the template to find.
      #
      # @return [String, nil]
      #   Returns the absolute path to the template, or `nil` if the
      #   template could not be found.
      #
      # @example
      #   find_template 'sub/path/template.erb'
      #
      # @api semipublic
      #
      def find_template(sub_path)
        sub_path = sub_path.to_s

        if template_dir
          path = File.expand_path(File.join(template_dir,sub_path))

          return path if File.file?(path)
        end

        return find_data_file(sub_path)
      end

      #
      # Finds the template, pushing the directory that the template resides
      # within to {#template_dirs}, calls the given block and then pops
      # the directory off of {#template_dirs}.
      #
      # @param [String] sub_path
      #   The relative path of the template to find.
      #
      # @yield [path]
      #   The block to be called after the directory of the template has
      #   been pushed onto {#template_dirs}. After the block has returned,
      #   the directory will be popped off of {#template_dirs}.
      #
      # @yieldparam [String] path
      #   The absolute path of the template.
      #
      # @return [Object]
      #   Result of the given block.
      #
      # @raise [RuntimeError]
      #   The template was not found.
      #
      # @example
      #   enter_template('sub/path/template.erb') do |path|
      #     # do stuff with the full path
      #   end
      #
      # @api semipublic
      #
      def enter_template(sub_path)
        sub_path = sub_path.to_s

        unless (path = find_template(sub_path))
          raise(RuntimeError,"could not find template #{sub_path.dump}")
        end

        template_dirs.unshift(File.dirname(path))

        result = yield(path)

        template_dirs.shift
        return result
      end

      #
      # Finds and reads the contents of a template.
      #
      # @param [String] template_path
      #   The relative path to the template.
      #
      # @yield [template]
      #   The given block will receive the contents of the template.
      #
      # @yieldparam [String] template
      #   The contents of the template.
      #
      # @example
      #   read_template 'path/to/_include.txt'
      #   # => "..."
      #
      # @example Calling read_template with a block
      #   read_template 'path/to/_include.txt' do |contents|
      #     # ...
      #   end
      #
      # @api semipublic
      #
      def read_template(template_path)
        enter_template(template_path) do |path|
          contents = File.read(path)

          if block_given?
            yield(contents)
          else
            contents
          end
        end
      end
    end
  end
end
