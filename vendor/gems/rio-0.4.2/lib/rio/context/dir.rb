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

require 'rio/entrysel'

module RIO
  module Cx
    module Methods
      def dir_iter?() cx.has_key?('entry_sel') end
      
      private

      def _set_entry_sel_args(sel_type,*args)
        #p callstr('_set_entry_sel_args',sel_type,*args)

        es = (cx['entry_sel'] ||= {})
        eargs = (es['args'] ||= {})
        eargs[sel_type] ||= []
        eargs[sel_type] += args
      end

      def _set_select(ss_type,*args,&block)
        cx['ss_type'] = ss_type
        _set_entry_sel_args(ss_type,*args)
        return each(&block) if block_given?
        self
      end

      def _selkey(sel_type)
        #p callstr('_selkey',sel_type,skipping?)
        if skipping?
          cx['skipping'] = false
          'skip' + sel_type
        else
          sel_type
        end
      end
      public

      def entries(*args,&block) 
        _set_select(_selkey('entries'),*args,&block) 
      end
      def files(*args,&block)   
        _set_select(_selkey('files'),*args,&block)   
      end
      def dirs(*args,&block)    
        _set_select(_selkey('dirs'),*args,&block)     
      end

      def skipentries(*args,&block) 
        _set_select('skipentries',*args,&block) 
      end
      def skipfiles(*args,&block)
        _set_select('skipfiles',*args,&block)
      end
      def skipdirs(*args,&block)
        _set_select('skipdirs',*args,&block)
      end

      private

      def _addselkey(key,sym,*args)
        #p callstr('_addselkey',key,sym,*args)
        cx[key] ||= Match::Entry::Sels.new
        cx[key] << Match::Entry::List.new(sym,*args)
        self
      end

      public

      def recurse(*args,&block)
        _addselkey('r_sel',:dir?,*args).all_
        return each(&block) if block_given?
        self
      end
      def norecurse(*args,&block)
        _addselkey('r_nosel',:dir?,*args).all_
        return each(&block) if block_given?
        self
      end
    end
  end
end
      
