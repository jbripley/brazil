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


require 'rio/exception/notsupported'
require 'rio/ios/mode'
module RIO
  module IOS #:nodoc: all
    module Methods
    end
  end
end
module RIO
  module IOS #:nodoc: all
    module Exception
      class NotDuplex < RIO::Exception::Base
      end
    end
  end
end

module RIO
  module IOS #:nodoc: all
    class Null  #:nodoc: all
      def initialize(el=nil,m='r') 
        @lineno = 0
        @open = true
        @mode = Mode.new(m)
        @pos = 0
      end
      require 'rio/ios/fail'
      include Fail
                                                                             
      def <<(obj) self end
      def binmode() self end
      def close() @open = false end
      def close_read() raise Exception::NotDuplex end
      def close_write()  raise Exception::NotDuplex end
      def closed?() not @open end
      def each(sep_string=$/,&block) self end
      def each_line(sep_string=$/,&block) self end
      def each_byte(sep_string=$/,&block) self end
      def eof?() true end
      #def fcntl(integer_cmd,arg) notsupported(:fcntl) end
      #def fileno() notsupported(:fileno) end
      #def to_i() notsupported(:to_i) end
      def flush() nil end
      def fsync() nil end
      def getc() nil end
      def gets(sep_string=$/) nil end
      #def ioctl(integer_cmd,arg) notsupported(:ioctl) end
      def tty?() false end
      def isatty() tty? end
      def lineno() @lineno end
      def lineno=(a) @lineno = a; lineno() end
      #def pid() notsupported(:pid) end
      def pos() 0 end
      def tell() pos() end
      def pos=(v) @pos = v; pos end
      def print(*objs) nil end
      def printf(format,*objs) nil end
      def putc(obj) nil end
      def puts(*objs) nil end
      def read(length=nil,*args) length.nil? ? "" : nil end
      def readchar() raise EOFError end
      def readline(sep_string=$/) raise EOFError end
      def readlines(sep_string=$/) [] end
      def readpartial(maxlen,*args)  raise EOFError end
      def reopen(*args) self end
      def rewind() 0 end
      def seek(amount,whence) 0 end
      #def stat() notsupported(:stat) end
      #def sync() notsupported(:sync) end
      #def sync=(v) notsupported(:sync=) end
      #def sysread() notsupported(:sysread) end
      #def sysseek() notsupported(:sysseek) end
      #def syswrite() notsupported(:syswrite) end
      #def ungetc() notsupported(:ungetc) end
      def write(str) str.length end
      
      def callstr(func,*args)
        self.class.to_s+'['+self.to_s+']'+'.'+func.to_s+'('+args.join(',')+')'
      end
      
    end
  end
end
