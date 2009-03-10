#--
# =============================================================================== 
# Copyright (c) 2005,2006,2007,2008 Christopher Kleckner
# All rights reserved
#
# This file is part of the Rio library for ruby.
#
# Rio is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Rio is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Rio; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
# =============================================================================== 
#++
#
# To create the documentation for Rio run the command
#  ruby build_doc.rb
# from the distribution directory.
#
# Suggested Reading
# * RIO::Doc::SYNOPSIS
# * RIO::Doc::INTRO
# * RIO::Doc::HOWTO
# * RIO::Doc::EXAMPLES
# * RIO::Rio
#


require 'yaml'
require 'forwardable'
require 'delegate'

module RIO
  module Ext
    module YAML #:nodoc: all
      module Tie
        class Doc
          extend Forwardable
          def initialize(fn)
            @filename = fn
            @io = nil
            @doc = nil
            @root = nil
          end
          def open()
            @io = ::File.new('database.yml',"r")
            @doc = ::YAML.load(@io)
            @root = RIO::Ext::YAML::Tie::Root.new(@doc)
            self
          end

          def close()
            if @root.dirty?
              @io.close
              ::File.open('database.yml',"w") do |ios|
                ::YAML.dump(@doc,ios)
              end
            end
          end

          def_instance_delegators(:@root,:inspect)
          def method_missing(sym,*args)
            @root.__send__(sym,*args)
          end
          def self.new_node(doc,cont)
          end
        end
      end
    end
  end
end
module RIO
  module Ext
    module YAML #:nodoc: all
      module Tie
        class Base
          attr :doc,:cont
          def initialize(doc,cont=nil)
            @doc = doc
            @cont = cont
          end
        end
        class Root < Base
          extend Forwardable
          attr_accessor :dirty
          def initialize(doc)
            @doc = doc
            @root = Tie::Hash.new(@doc,self)
            @dirty = false
          end
          def dirty=(val)
            @dirty = val
          end
          def dirty?()
            @dirty
          end
          def_instance_delegators(:@root,:inspect)
          def method_missing(sym,*args)
            @root.__send__(sym,*args)
          end
        end
      end
    end
  end
end

module RIO
  module Ext
    module YAML #:nodoc: all
      module Tie
        module Node
          def dirty=(val)
            cont.dirty=(val)
          end
        end
        class Hash < DelegateClass(::Hash)
          include Tie::Node
          attr_reader :doc
          attr_reader :cont
          def initialize(doc,cont=nil)
            @doc = doc
            @cont = cont
            super(@doc)
          end
          def [](key)
            val = super
            case val
            when ::Hash then Tie::Hash.new(val,self)
            else val
            end
          end
          def []=(key,val)
            self.dirty = true
            super
          end
        end
      end
    end
  end
end
__END__
