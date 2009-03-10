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


require 'rio/stream/base'
require 'rio/ops/path'
require 'rio/ops/stream'
require 'rio/ops/stream/input'
require 'rio/ops/stream/output'
require 'rio/ext'

require 'rio/filter/gzip'
#require 'rio/filter/yaml'
#require 'rio/filter/chomp'
#require 'rio/filter/strip'
require 'rio/filter/closeoneof'

module RIO

  module Stream #:nodoc: all
    class Reset < Base
      # Mixin the appropriate ops
      #include Ops::Path::Str
      include Ops::Stream::Reset

      def check?() true end
      def when_missing(sym,*args) retryreset() end
    end

    class IOBase < Base
      # Mixin the appropriate ops
      include Ops::Path::Str
      include Ops::Stream::Status
      include Ops::Stream::Manip
      
      def check?() open? end
      def when_missing(sym,*args) 
        #p callstr('when_missing',sym,*args)
        retryreset() 
      end
      def base_state() 'Stream::Close' end
      def reset()
        self.close.softreset()
      end
      def setup
        ioh.sync = sync? if cx.has_key?('sync')
        self
      end
      def add_filter(mod)
        unless ioh.kind_of?(mod)
          ioh.extend(mod)
        end
      end
#      def open_(*args)
#        self
#      end
      def rectype_mod
        case cx['stream_rectype']
        when 'lines' then RIO::RecType::Lines
        when 'bytes' then RIO::RecType::Bytes
        else RIO::RecType::Lines
        end
      end
      def self.copier(src,dst)
        RIO::Copy::Strategy::Stream.instance.copier(src,dst)
      end
    end
    module Ini
      def setup
        super
        @recno = -1
        @get_selrej,@get_rangetops = create_selrej()
        self
      end
    end
    class Input < IOBase
      include Ops::Stream::Input
      include Ini
      include Filters


      def add_extensions()
        #p callstr('add_extensions')
        Ext::Input.add_extensions(self)
      end
      def add_filters
        #p "IN stream#add_filters"
        add_filter(Filter::GZipRead) if gzip?
        #add_filter(Filter::YAML) if yaml?
        add_line_filters()
#        add_filter(Filter::FasterCSV) if csv?
#        if closeoneof?
#          add_filter(Filter::CloseOnEOF)
#          ioh.oncloseproc = proc { self.on_closeoneof }
#        end
        self
      end
      def add_rec_methods()
        self.extend(rectype_mod.module_eval('Input'))
      end
    end 

    class Output < IOBase
      include Ops::Stream::Output
      
      def add_rec_methods()
        self.extend(rectype_mod.module_eval('Output'))
      end
      def add_extensions()
        Ext::Output.add_extensions(self)
      end
      def add_filters
        add_filter(Filter::GZipWrite) if gzip?
        #add_filter(Filter::FasterCSV) if csv?
        #add_filter(Filter::YAML) if yaml?
        self
      end

    end 

    class InOut < IOBase
      include Ops::Stream::Input
      include Ops::Stream::Output
      include Ini
      include Filters
      
      def add_rec_methods()
        self.extend(rectype_mod.module_eval('Input'))
        self.extend(rectype_mod.module_eval('Output'))
      end
      def add_extensions()
        Ext::Input.add_extensions(self)
        Ext::Output.add_extensions(self)
      end

      def add_filters
        add_line_filters()

 #       if closeoneof?
 #         add_filter(Filter::CloseOnEOF)
 #         ioh.oncloseproc = proc { self.on_closeoneof }
 #       end
        self
      end

    end 
  end

end # module RIO
