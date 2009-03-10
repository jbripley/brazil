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

module RIO
  module Cx
    module Methods
      def stream_iter?() cx.has_key?('stream_itertype') && !cx['nostreamenum'] end
      
      private

      def _set_bytes(nb)
        nb = 1 if nb.nil? or nb < 1
        cx['bytes_n'] = nb
      end
      def _set_bytes_(nb)
        nb = 1 if nb.nil? or nb < 1
        cx.set_('bytes_n',nb)
      end

      def _set_sstype(ss,explicit=true)
        case
        when explicit then cx['ss_type'] = ss
        else cx.set_('ss_type',ss)
        end
      end
      def _set_rectype(rt,explicit=true)
        case
        when explicit then cx['stream_rectype'] = rt
        else cx.set_('stream_rectype',rt)
        end
      end
      def _set_itertype(rt,explicit=true)
        case
        when explicit then cx['stream_itertype'] = rt
        else cx.set_('stream_itertype',rt)
        end
      end

      def _set_selargs(sa,sel=true,&block)
        key = (sel ? 'stream_sel' : 'stream_nosel')
        cx[key] = sa
        each(&block) if block_given?
        self
      end

      def _lines(args,sel=true,explicit=true,&block)   
        #p callstr('lines',*args)
        _set_itertype('lines',explicit)
        _set_rectype('lines',explicit)
        _set_selargs(args,sel,&block)
      end

      def _records(args,sel=true,explicit=true,&block) 
        _set_itertype('records',explicit)
        _set_selargs(args,sel,&block)
      end

      def _rows(args,sel=true,explicit=true,&block) 
        _set_itertype('rows',explicit)
        _set_selargs(args,sel,&block)
      end

      def _sel()
        !skipping?
      end
      def _sel_key(key)
        (skipping? ? 'skip'+key : key)
      end
      public

      def lines(*args,&block)   
        #p callstr('lines',*args)
        if skipping?
          cx['skipping'] = false
          skiplines(*args,&block)
        else
          _set_sstype('lines')
          _lines(args,_sel,&block)
        end
      end
      def lines_(*args,&block) 
        #p callstr('lines_',*args)
        _set_sstype('lines',false)
        _lines(args,_sel,false,&block)
      end

      def line(*args,&block)   
        #p callstr('line',*args)
        cx['line'] = true
        self.lines(*args,&block)
      end
      def line_(*args,&block) 
        #p callstr('line_',*args)
        cx.set_('line',true)
        self.lines_(*args,&block)
      end

      def records(*args,&block) 
        if skipping?
          cx['skipping'] = false
          skiprecords(*args,&block)
        else
          _set_sstype('records')
          _records(args,_sel,&block)
        end
      end
      def records_(*args,&block) 
        _set_sstype('records',false)
        _records(args,_sel,false,&block)
      end

      def record(*args,&block)   
        #p callstr('record',*args)
        cx['record'] = true
        self.records(*args,&block)
      end
      def record_(*args,&block) 
        #p callstr('record_',*args)
        cx.set_('record',true)
        self.records_(*args,&block)
      end

      def rows(*args,&block) 
        if skipping?
          cx['skipping'] = false
          skiprows(*args,&block)
        else
          _set_sstype('rows')
          _rows(args,_sel,&block)
        end
      end
      def rows_(*args,&block) 
        _set_sstype('rows',false)
        _rows(args,_sel,false,&block)
      end

      def row(*args,&block)   
        #p callstr('row',*args)
        cx['row'] = true
        self.rows(*args,&block)
      end
      def row_(*args,&block) 
        #p callstr('row_',*args)
        cx.set_('row',true)
        self.rows_(*args,&block)
      end


      def skiplines(*args,&block) 
        #p callstr('skiplines',*args)
        self.lines() unless args.empty? or cx.has_key?('stream_sel')
        _set_sstype('skiplines')
        _lines(args,false,&block)
      end
      def skiprecords(*args,&block) 
        self.records_() unless args.empty? or cx.has_key?('stream_sel')
        _set_sstype('skiprecords')
        _records(args,false,&block)
      end
      def skiprecords_(*args,&block) 
        self.records_() unless args.empty? or cx.has_key?('stream_sel')
        _set_sstype('skiprecords',false)
        _records(args,false,false,&block)
      end
      def skiprows(*args,&block) 
        self.rows() unless args.empty? or cx.has_key?('stream_sel')
        _set_sstype('skiprows')
        _rows(args,false,&block)
      end



      def bytes(nb=1,*args,&block)
        _set_sstype('bytes')
        _set_bytes(nb)
        _set_itertype('records')
        _set_rectype('bytes')
        each(&block) if block_given?
        self
      end
      def bytes_(nb=1,*args,&block)
        _set_bytes_(nb)
        _set_itertype('records',false)
        _set_rectype('bytes',false)
        each(&block) if block_given?
        self
      end



    end
  end
end
