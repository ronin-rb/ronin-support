#
# Ronin Support - A support library for Ronin.
#
# Copyright (c) 2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301  USA
#

require 'ronin/scanner/exceptions/unknown_category'

require 'set'

module Ronin
  module Scanner
    module ClassMethods
      #
      # The defined categories and their scanners for the class.
      #
      # @return [Hash]
      #   The categories and the scanners defined for the them within
      #   the class.
      #
      def scanners
        @scanners ||= {}
      end

      #
      # Collects all categories that the class and ancestors scan
      # for.
      #
      # @return [Set]
      #   The category names of all defined scanners.
      #
      def scans_for
        names = Set[]

        ancestors.each do |ancestor|
          if ancestor.include?(Ronin::Scanner)
            names += ancestor.scanners.keys
          end
        end

        return names
      end

      #
      # Specifies whether or not there are scanners defined for the
      # specified category.
      #
      # @param [Symbol, String] name
      #   The name of the category to search for scanners within.
      #
      # @return [Boolean]
      #   Specifies whether there is a scanner defined for the
      #   specified category.
      #
      def scans_for?(name)
        name = name.to_sym

        ancestors.each do |ancestor|
          if ancestor.include?(Ronin::Scanner)
            return true if ancestor.scanners.has_key?(name)
          end
        end

        return false
      end

      #
      # Collects all scanners in the specified category.
      #
      # @param [Symbol, String] name
      #   The category name to return all scanners for.
      #
      # @return [Array]
      #   All scanners in the specified category.
      #
      # @raise [UnknownCategory]
      #   No category has the specified name.
      #
      def scanners_in(name)
        name = name.to_sym

        unless scans_for?(name)
          raise(Ronin::Scanner::UnknownCategory,"unknown scanner category #{name}",caller)
        end

        tests = []

        ancestors.each do |ancestor|
          if ancestor.include?(Ronin::Scanner)
            if ancestor.scanners.has_key?(name)
              tests += ancestor.scanners[name]
            end
          end
        end

        return tests
      end

      #
      # Defines a scanner in the category for the class.
      #
      # @param [Symbol, String] name
      #   The name of the category to define the scanner for.
      #
      # @yield [target, results, (options)]
      #   The block that will be called when the scanner is ran.
      #
      # @yieldparam [Object] target
      #   The target object to scan.
      #
      # @yieldparam [Proc] results
      #   A callback for enqueuing results from the scanner in
      #   real-time.
      #
      # @yieldparam [Hash] options
      #   Additional scanner-options that can be used to configure
      #   the scanning.
      #
      # @example Defining a scanner for the `:lfi` category.
      #   scanner(:lfi) do |url,results|
      #     # ...
      #   end
      #
      # @example Defining a scanner for the `:sqli` category, that
      #          accepts additional scanner-options.
      #   scanner(:sqli) do |url,results,options|
      #     # ...
      #   end
      #
      def scanner(name,&block)
        method_name = name.to_s.downcase.gsub(/[\s\._-]+/,'_')
        name = name.to_sym

        (scanners[name] ||= []) << block

        define_method("first_#{method_name}") do |*arguments|
          options = case arguments.length
                    when 1
                      arguments.first
                    when 0
                      true
                    else
                      raise(ArgumentError,"wrong number of arguments (#{arguments.length} for 1)",caller)
                    end

          first_result = nil

          scan(name => options) do |category,result|
            first_result = result
            break
          end

          return first_result
        end

        define_method("has_#{method_name}?") do |*arguments|
          !(self.send("first_#{method_name}",*arguments).nil?)
        end

        name = name.to_s

        module_eval %{
          def #{method_name}_scan(options=true,&block)
            results = scan(:#{name.dump} => options) do |category,result|
              block.call(result) if block
            end

            return results[:#{name.dump}]
          end
        }

        return true
      end
    end
  end
end
