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


require 'rio/ext/csv'
require 'rio/ext/splitlines'
require 'rio/ext/yaml'
#require 'rio/ext/zipfile'

require 'rio/util'
module RIO
  module Ext #:nodoc: all
    @@extensions = {}

    module_function
    def add(cl,meth)
      @@extensions[cl] ||= []
      @@extensions[cl].push(meth)
    end
    def extend_state(state_class,ext_module)
      ext_proc = proc{ |obj| obj.extend(ext_module) }
      RIO::Ext.add(state_class,ext_proc)
    end

    def became(obj)
      if @@extensions[obj.class]
        @@extensions[obj.class].each { |meth|
          meth[obj]
        }
      end
    end
  end
end

module RIO
  module Ext #:nodoc: all
    class Extension
      def initialize(etest,mod)
        @inc = { 
          'cx' => mod+'::Cx',
          'input' => mod+'::Input',
          'output' => mod+'::Output',
        }
      end
      def add(obj,state)
        case state
          when 'Stream::Input' then obj.extend(@inc['input'])
          when 'Stream::Output' then obj.extend(@inc['output'])
        end
      end
      
    end
  end
end
module RIO
  module Ext #:nodoc: all
    class Extensions
      def initialize()
        #@ext
        @inc = { 
          'cx' => mod+'::Cx',
          'input' => mod+'::Input',
          'output' => mod+'::Output',
        }
      end
      def add(obj)
        
      end
    end
  end
end


module RIO
  module Ext #:nodoc: all
    OUTPUT_SYMS = Util::build_sym_hash(CSV::Output.instance_methods + YAML::Output.instance_methods)

    module Cx
      include CSV::Cx
      include SplitLines::Cx
      include YAML::Cx
      #include ZipFile::Cx
    end
  end
  module Ext
    module Input
      def add_extensions(obj)
        obj.extend(CSV::Input) if obj.csv?
        obj.extend(SplitLines::Input) if obj.splitlines?
        obj.extend(YAML::Input) if obj.yaml?
        obj
      end
      module_function :add_extensions
    end
    module Output
      def add_extensions(obj)
        obj.extend(CSV::Output) if obj.csv?
        obj.extend(SplitLines::Output) if obj.splitlines?
        obj.extend(YAML::Output) if obj.yaml?
        obj
      end
      module_function :add_extensions
    end
  end
end

