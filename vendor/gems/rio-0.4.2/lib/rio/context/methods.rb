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


require 'rio/context/cxx.rb'
require 'rio/iomode'

require 'rio/context/stream'   
require 'rio/context/dir'   
require 'rio/context/skip'   
require 'rio/filter'   
require 'rio/context/autoclose'   
require 'rio/context/gzip'   
require 'rio/context/copying'   

module RIO
  module Cx #:nodoc: all
    module SS
      STREAM_KEYS = %w[records lines rows bytes skiplines skiprows skiprecords nobytes]
      ENTRY_KEYS = %w[entries files dirs skipfiles skipdirs skipentries]
      KEYS = ENTRY_KEYS + STREAM_KEYS
    end
  end
end

module RIO
  module Cx
    module Methods
      def mode(arg)
#        p callstr('mode',arg)
        self.cx['mode'] = Mode::Str.new(arg)
        self 
      end
      def mode?()         
        self.cx['mode']
      end
      def mode_(arg=nil)  
        #p callstr('mode_',arg)  
        self.cx.set_('mode',Mode::Str.new(arg)) 
        self 
      end
      protected :mode_
    end
  end
  
  
  module Cx
    module Methods
      def split(*args,&block)
        if args.empty? 
          self.splitpath 
        else
          self.splitlines(*args,&block)
        end
      end
    end
  end


  module Cx
    module Methods
      def sync(arg=true,&block) 
        ioh.sync = arg unless ioh.nil?
        cxx('sync',arg,&block) 
      end
      def nosync(arg=false,&block) 
        ioh.sync = arg unless ioh.nil?
        nocxx('sync',arg,&block) 
      end
      def sync?() 
        setting = cxx?('sync')
        unless ioh.nil?
          actual = ioh.sync
          cxx_(actual) unless actual == setting
        end
        setting
      end 
      def sync_(arg=true)  
        cxx_('sync',arg) 
      end
      protected :sync_
    end
  end




  module Cx
    module Methods
      def all(arg=true,&block) cxx('all',arg,&block) end
      def noall(arg=false,&block) nocxx('all',arg,&block) end
      def all?() cxx?('all') end 
      def all_(arg=true)  cxx_('all',arg) end
      protected :all_
      
    end
  end
end
      
module RIO
  module Cx
    module Methods
      def nostreamenum(arg=true,&block) cxx('nostreamenum',arg,&block) end
      def nostreamenum?() cxx?('nostreamenum') end 
      def nostreamenum_(arg=true)  cxx_('nostreamenum',arg) end
      protected :nostreamenum_
      
    end
  end
end
module RIO
  module Cx
    module Methods
      def ext(arg=nil)
        arg ||= self.extname || ""
        self.cx['ext'] = arg
        self 
      end
      def noext()
        ext('')
        self 
      end
      def ext?() 
        self.cx.set_('ext',self.extname || "") if self.cx['ext'].nil?
        self.cx['ext'] 
      end
      def ext_(arg=nil)  
        arg ||= self.extname || ""
        self.cx.set_('ext',arg);
        self 
      end
      protected :ext_
    end
  end
end
module RIO
  module Cx
    module Methods
      def a()  cx['outputmode'] = Mode::Str.new('a');  self end
      def a!() cx['outputmode'] = Mode::Str.new('a+'); self end
      def w()  cx['outputmode'] = Mode::Str.new('w');  self end
      def w!() cx['outputmode'] = Mode::Str.new('w+'); self end
      def r()  cx['inputmode']  = Mode::Str.new('r');  self end
      def r!() cx['inputmode']  = Mode::Str.new('r+'); self end
      def outputmode?() cxx?('outputmode') end
      def inputmode?()  cxx?('inputmode')  end
      def +@() a() end
    end
  end
end
