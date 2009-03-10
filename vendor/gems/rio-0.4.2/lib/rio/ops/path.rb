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


#require 'rio/impl/path'
module RIO
  module Ops #:nodoc: all
    module Path
      module Test
        def blockdev?(*args) fs.blockdev?(self.to_s,*args) end
        def chardev?(*args) fs.chardev?(self.to_s,*args) end
        def directory?(*args) fs.directory?(self.to_s,*args) end
        def exist?(*args) fs.exist?(self.to_s,*args) end
        def file?(*args) 
          fs.file?(self.to_s,*args) 
        end
        def pipe?(*args) fs.pipe?(self.to_s,*args) end
        def socket?(*args) fs.socket?(self.to_s,*args) end
        def symlink?(*args) fs.symlink?(self.to_s,*args) end
        alias :dir? :directory?
        def open?() not self.closed? end
        def closed?() self.ioh.nil? end
      end
      module Status
        include Test
        def fnmatch(*args) fs.fnmatch(self.to_s,*args) end
        def fnmatch?(*args) fs.fnmatch?(self.to_s,*args) end
        def ftype(*args) fs.ftype(self.to_s,*args) end
        def stat(*args) fs.stat(self.to_s,*args) end
        def atime(*args) fs.atime(self.to_s,*args) end
        def ctime(*args) fs.ctime(self.to_s,*args) end
        def mtime(*args) fs.mtime(self.to_s,*args) end
        def executable?(*args) fs.executable?(self.to_s,*args) end 
        def executable_real?(*args) fs.executable_real?(self.to_s,*args) end 
        def readable?(*args) fs.readable?(self.to_s,*args) end 
        def readable_real?(*args) fs.readable_real?(self.to_s,*args) end 
        def writable?(*args) fs.writable?(self.to_s,*args) end 
        def writable_real?(*args) fs.writable_real?(self.to_s,*args) end
        def sticky?(*args) fs.sticky?(self.to_s,*args) end 
        def owned?(*args) fs.owned?(self.to_s,*args) end 
        def grpowned?(*args) fs.grpowned?(self.to_s,*args) end 
        def setgid?(*args) fs.setgid?(self.to_s,*args) end 
        def setuid?(*args) fs.setuid?(self.to_s,*args) end
        def size(*args) fs.size(self.to_s,*args) end 
        def size?(*args) fs.size?(self.to_s,*args) end 
        def zero?(*args) fs.zero?(self.to_s,*args) end
        def root?(*args) fs.root?(self.to_s) end

      end
      module URI
        def abs(base=nil)
          if base.nil?
            nrio = new_rio(rl.abs)
            nrio
          else
            #new_rio(rl,{:base => ensure_rio(base).abs.to_uri}).abs
            brio = ensure_rio(base)
            new_rio(rl.abs(ensure_rio(base).to_s))
          end
        end
        def abs?
          rl.abs?
        end
        alias :absolute? :abs?
        def route_from(other)
          new_rio(rl.abs.route_from(ensure_rio(other).rl.abs))
        end
        def rel(other=nil)
          if other.nil?
            base = self.abs.dirname
          else
            new_rio(self.rl.abs.route_from(ensure_rio(other).rl.abs))
          end
          base = other.nil? ? self.abs : ensure_rio(other).dup
          base += '/' if base.directory? and base.to_s[-1] != '/'
          route_from(base)
        end
        def route_to(other)
          new_rio(rl.abs.route_to(ensure_rio(other).rl.abs))
        end
        def merge(other)
          new_rio(rl.merge(ensure_rio(other).rl))
        end
        def base()
          new_rio(rl.base())
        end
        def setbase(b)
          rl.base(b)
          self
        end
        extend Forwardable
        def_instance_delegators(:rl,:scheme,:host,:opaque)

      end
      module Query
        def expand_path(*args)
          args[0] = args[0].to_s unless args.empty?
          new_rio(RL.fs2url(fs.expand_path(self.to_s,*args)))
        end
        def extname(*args) 
          en = fs.extname(rl.path_no_slash,*args) 
          (en.empty? ? nil : en)
        end
        def splitpath()
          require 'rio/to_rio'
          parts = self.rl.split
          # map to rios and extend the array with to_array
          parts.map { |arl| new_rio(arl) }.extend(ToRio::Array)
        end
        def basename(*args)
          unless args.empty?
            ex = args[0] || self.extname
            self.ext(ex)
          end
           new_rio(rl.basename(self.ext?))
        end
        def filename()
          new_rio(rl.filename)
        end
        def dirname(*args)
          new_rio(rl.dirname)
        end

        def sub(re,arg)
          new_rio(softreset.to_s.sub(re,arg.to_s))
        end
        def gsub(re,arg)
          new_rio(softreset.to_s.gsub(re,arg.to_s))
        end

        def +(arg)
          new_rio(softreset.to_str + ensure_rio(arg).to_str)
        end

        private

        def _path_with_basename(arg)
          old =  rl.path_no_slash
          old[0,old.length-basename.length-ext?.length]+arg.to_s+ext?
        end
        def _path_with_filename(arg)
          old =  rl.path_no_slash
          old[0,old.length-filename.length]+arg.to_s
        end
        def _path_with_ext(ex)
          old =  rl.path_no_slash
          old[0,old.length-ext?.length]+ex
        end
        def _path_with_dirname(arg)
          old =  rl.path_no_slash
          arg.to_s + old[-(old.length-dirname.length),old.length]
        end
      end
      module Change
        def sub!(*args)
          rl.path = rl.path.sub(*args)
          softreset
        end
        
        def rename(*args,&block)
          if args.empty?
            cxx('rename',true,&block)
          else
            rtn = must_exist.rename(*args)
            return rtn.each(&block) if block_given?
            rtn
          end
        end
        def rename?() cxx?('rename') end
        def norename(arg=false,&block) nocxx('rename',&block) end
        
        def filename=(arg)
          if cx['rename']
            must_exist.filename = arg
          else
            rl.urlpath = _path_with_filename(arg)
            softreset
          end
        end
        
        def basename=(arg)
          if cx['rename']
            must_exist.basename = arg
          else
            rl.urlpath = _path_with_basename(arg)
            softreset
          end
        end
        
        def extname=(arg)
          #p callstr('extname=',arg)
          
          if cx['rename']
            must_exist.extname = arg
          else
            rl.urlpath = _path_with_ext(arg)
            softreset
          end
        end
        
        def dirname=(arg)
          if cx['rename']
            must_exist.dirname = arg
          else
            rl.path = _path_with_dirname(arg)
            softreset
          end
        end
        
      end
    end 
  end
end
require 'rio/ops/create'
require 'rio/ops/construct'
module RIO
  module Ops
    module Path
      module Empty
        include Ops::Path::Create
        include Ops::Path::URI
        include Ops::Construct
      end
      module ExistOrNot
        def symlink(d) 
          rtn_self { 
            dst = self.ensure_rio(d)
            dst /= self.filename if dst.directory?
            if self.abs?
              fs.symlink(self,dst) 
            else
              #p "symlink(#{dst.route_to(self)},#{dst})"
              fs.symlink(dst.route_to(self),dst.to_s) 
            end
            dst.reset
          } 
        end
      end
      module NonExisting
        include Test
        include Create
        include ExistOrNot
        # Rio does not consider an attempt to remove something that does not exist an error. 
        # Rio says "You called this method because you didn't want the thing to exist on the 
        # file system. After the call it doesn't exist. You're welcome"
        # 
        def delete!() softreset  end
        def delete() softreset  end
        def rmdir() softreset  end
        def rmtree() softreset  end
        def rm() softreset  end
        
      end
      module Str
        include Status
        include Query
        include Create        
        include URI
        include ExistOrNot
      end
    end
    
  end
end
