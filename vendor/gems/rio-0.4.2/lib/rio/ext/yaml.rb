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

module RIO
  module Ext
    module YAML #:nodoc: all
      module Cx
        def yaml(&block) 
          cxx('yaml',true,&block) 
        end
        def yamldoc(&block) 
          #@yamldoc = YAML::Tie::Doc.new(self.fspath).open
          become('Ext::YAML::Doc::Existing')
        end
        def yaml?() cxx?('yaml') end 
        def yaml_(fs=',',rs=nil) 
          cxx_('yaml',true) 
        end
        protected :yaml_
        def objects(*args) records(*args) end
        def documents(*args) rows(*args) end
        def object(*args) record(*args) end
        def document(*args) row(*args) end
        def skipobjects(*args) skiprecords(*args) end
        def skipdocuments(*args) skiprows(*args) end
      end
    end
    module YAML
      module Input
          
        def cpto_(arg)
          #p callstr('cpto_',arg.inspect)
          
          case arg
          when ::Array,::String then super
          when ::IO,::StringIO then cpto_io_(arg)
          else super
          end
        end
        def apto_(arg)
          case arg
          when ::Array,::String then super
          when ::IO,::StringIO then cpto_io_(arg)
          else super
          end
        end
        def cpto_io_(ioarg)
          recs = self.to_a
          if recs.size == 1
            YAML.dump(recs[0],ioarg)
          else
            YAML.dump(recs,ioarg)
          end
        end
        def cpto_string_(string)
          string << ::YAML.dump_stream(self.contents)
        end
        def get_(arg=nil)
          case cx['stream_itertype']
          when 'lines' then super
          when 'records' then ::YAML.load(self.ioh)
          when 'rows' then ::YAML.dump(::YAML.load(self.ioh))
          else ::YAML.load(self.ioh)
          end
        end
        def each_rec_(&block)
          case cx['stream_itertype']
          when 'lines' then super
          when 'records' then ::YAML.load_documents(self.ioh,&block)
          when 'rows' then ::YAML.load_documents(self.ioh) { |obj| yield obj.to_yaml }
          else ::YAML.load_documents(self.ioh,&block)
          end
          self
        end
        def load()
          getrec()
        end
        def getobj()
          getrec()
        end

      end
    end

    module YAML
      module Output
        protected

        def cpfrom_(arg)
          #p "yaml#cpfrom_(#{arg})"
          case arg
          #when ::Array then cpfrom_array_(arg)
          when Rio,::IO,::StringIO then super
          else self.put_(arg)
          end
          self
        end
#        def cpfrom_array_(array)
#          array.each { |el|
#            self.put_(el)
#          }
#          self
#        end
#        def cpfrom_rio_(ario)
#          p "yaml#cpfrom_rio_(#{ario})"
#          ioh.puts(::YAML.dump_stream(*ario[]))
#          self
#        end
        def put_(obj)
          #p callstr('put_',obj)
          ioh.puts(obj.to_yaml)
        end

        public

        def dump(obj)
          putrec!(obj)
        end
        def putobj(obj)
          putrec(obj)
        end
        def putobj!(obj)
          putrec!(obj)
        end
      end
    end
  end
end
__END__
