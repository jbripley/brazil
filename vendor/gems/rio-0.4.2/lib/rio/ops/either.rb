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


require 'rio/exception'
require 'fileutils'
module RIO
  module Impl
    module U
      def self.mv(s,d)
        ::FileUtils.mv(s.to_s,d.to_s)
      end
      def self.chmod(mod,s)
        ::File.chmod(mod,s.to_s)
      end
      def self.chown(owner_int,group_int,s)
        ::File.chown(owner_int,group_int,s.to_s)
      end
    end
  end
  module Ops
    module FileOrDir
      module ExistOrNot
      end
      module NonExisting
        include ExistOrNot
        def empty?() false end
      end

      module Existing
        include ExistOrNot

        def chmod(mod) rtn_self { fs.chmod(mod,fspath) } end
        def chown(owner,group) rtn_self { fs.chown(owner,group,fspath) } end
        def must_exist() self end

        def rename(*args,&block)
          if args.empty?
            softreset.rename(*args,&block)
          else
            rtn_reset { 
              dst = ensure_rio(args.shift)
              #p "rename: #{self} => #{dst}"
              fs.mv(self,dst,*args) 
              dst.reset
            } 
          end
        end
        def rename!(*args,&block)
          if args.empty?
            softreset.rename(*args,&block)
          else
            rtn_reset { 
              dst = ensure_rio(args.shift)
              #p "rename!: #{self} => #{dst}"
              fs.mv(self,dst,*args) unless self == dst 
              dst.reset
              self.rl = dst.rl.clone
            } 
          end
        end
        alias :mv :rename
        def basename=(arg)
          rename!(_path_with_basename(arg))
        end
        def filename=(arg)
          rename!(_path_with_filename(arg))
        end
        def extname=(ex)
          rename!(_path_with_ext(ex))
          cx['ext'] = ex
        end
        def dirname=(arg)
          rename!(_path_with_dirname(arg))
        end

        def ss_type?
          case cx['ss_type']
          when nil
            'entries'
          when 'files', 'dirs', 'entries', 'skipfiles', 'skipdirs', 'skipentries'
            cx['ss_type'] 
          else
            nil
          end
        end

        require 'pathname'
        def realpath
          new_rio(fs.realpath(fspath))
        end
        def mountpoint?
          fs.mountpoint?(fspath)
        end
        def empty?() self.to_a.empty? end
        
      end

    end
  end
end

