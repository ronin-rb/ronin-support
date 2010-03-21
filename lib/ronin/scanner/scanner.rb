#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/scanner/class_methods'

require 'set'

module Ronin
  #
  # The {Scanner} module allows a class to have multiple scanner rules
  # added to it. The scanner rules can be called individually or en-mass.
  # These scanner rules can be passed options, and pass back their results
  # in real-time.
  #
  module Scanner
    def self.included(base)
      base.extend ClassMethods
    end

    #
    # Runs all scanners in the given categories against {#each_target}.
    # If no categories are specified, all categories will be ran
    # against {#each_target}.
    #
    # @param [Hash{Symbol,String => Boolean,Hash}] categories
    #   The categories to scan for, with additional per-category
    #   scanner-options.
    #
    # @return [Hash]
    #   The results grouped by scanner category.
    #
    # @yield [category, result]
    #   The block that may receive the scanner results for categories
    #   in real-time.
    #
    # @yieldparam [Symbol] category
    #   The category the result belongs to.
    #
    # @yieldparam [Object] result
    #   The result object enqueued by the scanner.
    #
    # @example Scanning a specific category.
    #   url.scan(:rfi => true)
    #   # => {:rfi => [...]}
    #
    # @example Scanning multiple categories, with scanner-options.
    #   url.scan(:lfi => true, :sqli => {:params => ['id', 'catid']})
    #   # => {:lfi => [...], :sqli => [...]}
    #
    # @example Receiving scanner results from categories in real-time.
    #   url.scan(:lfi => true, :rfi => true) do |category,result|
    #     puts "[#{category}] #{result.inspect}"
    #   end
    #
    def scan(categories={},&block)
      options = normalize_category_options(categories)
      tests = {}
      results = {}

      options.each do |name,opts|
        tests[name] = self.class.scanners_in(name)
        results[name] = []
      end

      current_category = nil
      result_callback = lambda { |result|
        results[current_category] << result
        block.call(current_category,result) if block
      }

      each_target do |target|
        tests.each do |name,scanners|
          current_category = name

          scanners.each do |scanner|
            if scanner.arity == 3
              scanner.call(target,result_callback,options[name])
            else
              scanner.call(target,result_callback)
            end
          end
        end
      end

      return results
    end

    protected

    #
    # A place holder method which will call the given block with
    # each target object to be scanned. By default, the method will call
    # the given block once, simply passing it the `self` object.
    #
    # @yield [target]
    #   The block that will be passed each target object to be scanned.
    #
    # @yieldparam [Object] target
    #   The target object to be scanned.
    #
    def each_target(&block)
      block.call(self)
    end

    private

    #
    # Converts a Hash of categories to scan and options, into a Hash
    # of scanner options.
    #
    # @param [Hash{String,Symbol => Boolean,Hash}] categories
    #   The categories to scan for and their options.
    #
    # @return [Hash{Symbol => Hash}]
    #   The normalized scanner options.
    #
    def normalize_category_options(categories)
      options = {}

      if categories.empty?
        self.class.scans_for.each { |name| options[name] = {} }
      else
        categories.each do |name,opts|
          name = name.to_sym

          if opts
            options[name] = if opts.kind_of?(Hash)
                              opts
                            else
                              {}
                            end
          end
        end
      end

      return options
    end
  end
end
