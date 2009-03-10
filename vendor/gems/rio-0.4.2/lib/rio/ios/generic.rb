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

module RIO
  class GenericIOMode #:nodoc: all
    def initialize(mode_string)
      @str = mode_string
    end
    def to_s() @str end
    def can_write?
      @str =~ /^[aw]/ or @str =~ /\+/
    end
    def can_read?
      @str =~ /^r/ or @str =~ /\+/
    end
    def appends?
      @str =~ /^a/
    end
    def =~(re)
      re =~ @str
    end
  end
end

module RIO
  module IOS #:nodoc: all
    class Generic  #:nodoc: all
      def initialize(el,m='r')
      end
      
      def <<(obj) self end
      def binmode() self end
      def close() nil end
      def close_read() nil end
      def close_write() nil end
      def closed?() true end
      def each(sep_string=$/,&block) self end
      def each_line(sep_string=$/,&block) self end
      def each_byte(sep_string=$/,&block) nil end
      def eof?() true end
      def fcntl(integer_cmd,arg) nil end
      def fileno() nil end
      def to_i() nil end
      def flush() self end
      def fsync() nil end
      def getc() nil end
      def gets(sep_string=$/) nil end
      def ioctl(integer_cmd,arg) nil end
      def isatty() false end
      def tty?() false end
      def lineno() 0 end
      def lineno=(a) nil end
      def pid() nil end
      def pos() nil end
      def tell() nil end
      def pos=(v) self.pos end
      def print(*objs) nil end
      def printf(format,*objs) nil end
      def putc(obj) nil end
      def puts(*objs) nil end
      def read(*args) nil end
      def readchar() nil end
      def readline(sep_string=$/) nil end
      def readlines(sep_string=$/) [] end
      def readpartial(maxlen,*args)  end
      def reopen(*args) self end
      def rewind() 0 end
      def seek() 0 end
      def stat() nil end
      def sync() nil end
      def sync=(v) nil end
      def sysread() 0 end
      def sysseek() 0 end
      def syswrite() 0 end
      def ungetc() nil end
      def write(str) 0 end
      
      def callstr(func,*args)
        self.class.to_s+'['+self.to_s+']'+'.'+func.to_s+'('+args.join(',')+')'
      end
      
    end
  end
end
