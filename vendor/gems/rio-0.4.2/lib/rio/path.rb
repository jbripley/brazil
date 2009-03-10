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


require 'rio/state'
require 'rio/ops/path'
require 'rio/ops/symlink'
require 'rio/cp'
module RIO

  module Path #:nodoc: all
    # Empty: 
    #  nil? or empty? => Emp
    #  else => Sin
    class Empty < State::Base
      include Ops::Path::Empty
      def check?() fspath.nil? or fspath.empty? end

      private

      def _assume_cwd()
        self.rl = Path::RL.new('.')
        self.softreset
      end
      def _assume_stdio()
        require 'rio/scheme/stdio'
        self.rl = RIO::StdIO::RL.new
        self.softreset
      end

      public

      def [](*args)    _assume_cwd[*args] end
      def each(&block) _assume_cwd.each(&block) end
      def read(*args)  _assume_cwd.read(*args) end
      def get(*args)   _assume_cwd.get(*args)  end

      def gets(*args)  _assume_stdio.chomp.gets(*args) end

      def when_missing(sym,*args) gofigure(sym,*args) end
    end 

    # Primary State for Rio as path manipulator
    class Str < State::Base 
      include Ops::Path::Str
      include Ops::Path::Change
      public 
      
      def check?() not fspath.nil? and not fspath.empty? end
      def when_missing(sym,*args) 
        #p callstr('when_missing',sym,*args)+" file?=#{file?} symlink?=#{symlink?} dir?=#{directory?}"
        case
        when file? then efile()
        when directory? then edir()
        else npath()
        end
      end

      private

      def _fs_state(become_state,symlink_mod)
        next_state = become(become_state)
        next_state.extend(symlink_mod) if symlink?
        next_state
      end

      protected

      def edir() _fs_state('Dir::Existing',Ops::Symlink::Existing) end
      def efile() _fs_state('File::Existing',Ops::Symlink::Existing) end
      def npath() _fs_state('Path::NonExisting',Ops::Symlink::NonExisting) end

    end

    # A transition state. Anything but simple path tests must cause a transition out of this state.
    class NonExisting < State::Base
      include Ops::Path::NonExisting
      include Cp::NonExisting::Output

      def check?() not exist? end

      def ndir() become 'Dir::NonExisting' end
      def nfile() become('File::NonExisting') end

      def when_missing(sym,*args)
        case sym
        when :mkdir,:mkpath
          ndir()
        else 
          nfile()
        end
      end
    end

  end

end
