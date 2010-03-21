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

module Kernel
  #
  # Calls the given block and ignores any raised exceptions.
  #
  # @yield []
  #   The block to be called.
  #
  # @return [Object, nil]
  #   The return-value of the given block. If `nil` is returned, an
  #   exception occurred and was ignored.
  #
  # @example
  #   attempt do
  #     Resolv.getaddress('might.not.exist.com')
  #   end
  #
  def attempt(&block)
    begin
      block.call() if block
    rescue Exception
      return nil
    end
  end

  #
  # Attempts to run the given block and catches any SyntaxError,
  # RuntimeError or StandardError exceptions.
  #
  # @param [Boolean] verbose
  #   Specifies wether a backtrace will be printed when an exception
  #   has been raised.
  #
  # @yield []
  #   The block to be called.
  #
  # @return [nil]
  #   An exception was ignored, or the block returned nil.
  #
  # @example
  #   catch_all do
  #     load 'suspicious.rb'
  #   end
  #
  def catch_all(verbose=true,&block)
    begin
      block.call() if block
    rescue Exception => e
      if verbose
        STDERR.puts "#{e.class}: #{e}"
        e.backtrace[0,5].each { |trace| STDERR.puts "\t#{trace}" }
      end

      return nil
    end
  end
end
