# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    #
    # Represents the user's home directory.
    #
    # @api public
    #
    # @since 1.0.0
    #
    module Home
      # Path to the user's home directory.
      DIR = Gem.user_home

      # Path to the user's `~/.cache/` directory.
      CACHE_DIR = ENV.fetch('XDG_CACHE_HOME') do
        File.join(DIR,'.cache')
      end

      #
      # Returns the path to the sub-directory within the `~/.cache/` directory.
      #
      # @param [String] subdir
      #   The sub-directory.
      #
      # @return [String]
      #   The path to the `~/.cache/<subdir>` directory.
      #
      def self.cache_dir(subdir)
        File.join(CACHE_DIR,subdir)
      end

      # Path to the user's `~/.config/` directory.
      CONFIG_DIR = ENV.fetch('XDG_CONFIG_HOME') do
        File.join(DIR,'.config')
      end

      #
      # Returns the path to the sub-directory within the `~/.config/` directory.
      #
      # @param [String] subdir
      #   The sub-directory.
      #
      # @return [String]
      #   The path to the `~/.config/<subdir>` directory.
      #
      def self.config_dir(subdir)
        File.join(CONFIG_DIR,subdir)
      end

      # Path to the user's `~/.local/share` directory.
      LOCAL_SHARE_DIR = ENV.fetch('XDG_DATA_HOME') do
        File.join(DIR,'.local','share')
      end

      #
      # Returns the path to the sub-directory within the `~/.local/share/`
      # directory.
      #
      # @param [String] subdir
      #   The sub-directory.
      #
      # @return [String]
      #   The path to the `~/.local/share/<subdir>` directory.
      #
      def self.local_share_dir(subdir)
        File.join(LOCAL_SHARE_DIR,subdir)
      end
    end
  end
end
