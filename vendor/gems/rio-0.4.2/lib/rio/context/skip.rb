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

module RIO
  module Cx
    module Methods
      def _arg_skip(args)
        #p callstr('_arg_skip',args,cx.inspect)
        cx['ss_skipped'] = cx['ss_type'].sub(/^skip/,'') if cx['ss_type']
        cx['ss_type'] = 'skip'
        cx['skip_args'] = args
      end
      def _noarg_skip
        cx['ss_skipped'] = cx['ss_type'].sub(/^skip/,'') if cx['ss_type']
        cx['ss_type'] = 'skip'
        cx['skipping'] = true
      end
      def skipping?() cx['skipping'] end
      def skip(*args,&block)
        if args.empty?
          _noarg_skip
        else
          _arg_skip(args)
        end
        each(&block) if block_given?
        self
      end

    end
  end
end
