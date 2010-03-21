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

require 'ronin/yard/extensions'
require 'yard'

module Ronin
  module Yard
    class ScannerHandler < YARD::Handlers::Ruby::Base

      include Extensions

      handles method_call(:scanner)

      def process
        obj = statement.parameters(false).first
        nobj = namespace
        mscope = scope
        name = case obj.type
               when :symbol_literal
                 obj.jump(:ident, :op, :kw, :const).source
               when :string_literal
                 obj.jump(:string_content).source
               end

        register MethodObject.new(nobj, "first_#{name}", mscope) do |o|
          o.visibility = :public
          o.source = statement.source
          o.signature = "def first_#{name}(options=true)"
          o.parameters = [['options', 'true']]
        end

        register MethodObject.new(nobj, "has_#{name}?", mscope) do |o|
          o.visibility = :public
          o.source = statement.source
          o.signature = "def has_#{name}?(options=true)"
          o.parameters = [['options', 'true']]
        end

        register MethodObject.new(nobj, "#{name}_scan", mscope) do |o|
          o.visibility = :public
          o.source = statement.source
          o.signature = "def #{name}_scan(options=true,&block)"
          o.parameters = [['options', 'true'], ['&block', nil]]
        end
      end

    end
  end
end
