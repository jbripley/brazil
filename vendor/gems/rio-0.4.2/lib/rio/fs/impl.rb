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

module RIO
  module FS #:nodoc: all
    module Str
      def fnmatch?(s,globstr,*flags) @file.fnmatch?(globstr,s,*flags) end
      def extname(s,*args) @file.extname(s,*args) end

      def basename(s,*args) @file.basename(s,*args) end
      def dirname(s,*args) @file.dirname(s,*args) end
      def join(s,*args) @file.join(s,*args) end
      def cleanpath(s,*args) @path.new(s).cleanpath(*args) end
    end
    module File
      def expand_path(s,*args) @file.expand_path(s,*args) end


      def ftype(s,*args) @file.ftype(s,*args) end
      def symlink(s,d) @file.symlink(s.to_s,d.to_s) end

      def stat(s,*args) @file.stat(s,*args) end

      def atime(s,*args) @file.atime(s,*args) end
      def ctime(s,*args) @file.ctime(s,*args) end
      def mtime(s,*args) @file.mtime(s,*args) end

      def chmod(mod,s) @file.chmod(mod,s.to_s) end
      def chown(owner_int,group_int,s) @file.chown(owner_int,group_int,s.to_s) end

      def readlink(s,*args) @file.readlink(s,*args) end
      def lstat(s,*args) @file.lstat(s,*args) end

      def truncate(s,integer) @file.truncate(s,integer) end

    end
    module Dir
      def rmdir(s) @dir.rmdir(s.to_s) end
      def mkdir(s,*args) @dir.mkdir(s.to_s,*args) end
      def chdir(s,&block) @dir.chdir(s.to_s,&block) end
      def foreach(s,&block) @dir.foreach(s.to_s,&block) end
      def entries(s) @dir.entries(s.to_s) end
      def glob(gstr,*args,&block) @dir.glob(gstr,*args,&block) end
      def pwd() @dir.pwd end
      def getwd() @dir.getwd end
    end
    module Test
      def blockdev?(s,*args) @test.blockdev?(s,*args) end
      def chardev?(s,*args) @test.chardev?(s,*args) end
      def directory?(s,*args) @test.directory?(s,*args) end
      def dir?(s,*args) @test.directory?(s,*args) end
      def executable?(s,*args) @test.executable?(s,*args) end
      def executable_real?(s,*args) @test.executable_real?(s,*args) end
      def exist?(s,*args) @test.exist?(s,*args) end
      def file?(s,*args) @test.file?(s,*args) end
      def grpowned?(s,*args) @test.grpowned?(s,*args) end
      def owned?(s,*args) @test.owned?(s,*args) end
      def pipe?(s,*args) @test.pipe?(s,*args) end
      def readable?(s,*args) @test.readable?(s,*args) end
      def readable_real?(s,*args) @test.readable_real?(s,*args) end
      def setgid?(s,*args) @test.setgid?(s,*args) end
      def setuid?(s,*args) @test.setuid?(s,*args) end
      def size(s,*args) @test.size(s,*args) end
      def size?(s,*args) @test.size?(s,*args) end
      def socket?(s,*args) @test.socket?(s,*args) end
      def sticky?(s,*args) @test.sticky?(s,*args) end
      def symlink?(s,*args) @test.symlink?(s,*args) end
      def writable?(s,*args) @test.writable?(s,*args) end
      def writable_real?(s,*args) @test.writable_real?(s,*args) end
      def zero?(s,*args) @test.zero?(s,*args) end
    end
    module Path
      require 'pathname'
      def root?(s) @path.new(s).root? end
      def mountpoint?(s) @path.new(s).mountpoint? end
      def realpath(s) @path.new(s).realpath end
    end
    module Util
      # Directory stuff
      def cp_r(s,d)  @util.cp_r(s.to_s,d.to_s) end
      def rmtree(s) @util.rmtree(s.to_s) end
      def mkpath(s) @util.mkpath(s.to_s) end
      def rm(s) @file.delete(s.to_s) end
      def touch(s) @util.touch(s.to_s) end

      # file or dir
      def mv(s,d) @util.mv(s.to_s,d.to_s) end
    end
  end
end
