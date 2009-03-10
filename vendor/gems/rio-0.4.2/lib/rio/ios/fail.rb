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
  module IOS
    module Methods
    end
  end
end

module RIO
  module IOS #:nodoc: all
    module Fail  #:nodoc: all
      def notsupported(sym) 
        raise RIO::Exception::NotSupported,RIO::Exception::NotSupported.emsg(sym,self)
      end
                                                                             
      def <<(obj) notsupported(:<<) end
      def binmode() notsupported(:binmode) end
      def close() notsupported(:close) end
      def close_read() notsupported(:close_read) end
      def close_write() notsupported(:close_write) end
      def closed?() notsupported(:closed?) end
      def each(sep_string=$/,&block) notsupported(:each) end
      def each_line(sep_string=$/,&block) notsupported(:each_line) end
      def each_byte(sep_string=$/,&block) notsupported(:each_byte) end
      def eof?() notsupported(:eof?) end
      def fcntl(integer_cmd,arg) notsupported(:fcntl) end
      def fileno() notsupported(:fileno) end
      def to_i() notsupported(:to_i) end
      def flush() notsupported(:flush) end
      def fsync() notsupported(:fsync) end
      def getc() notsupported(:getc) end
      def gets(sep_string=$/) notsupported(:gets) end
      def ioctl(integer_cmd,arg) notsupported(:ioctl) end
      def isatty() notsupported(:isatty) end
      def tty?() notsupported(:tty?) end
      def lineno() notsupported(:lineno) end
      def lineno=(a) notsupported(:lineno=) end
      def pid() notsupported(:pid) end
      def pos() notsupported(:pos) end
      def tell() notsupported(:tell) end
      def pos=(v) notsupported(:pos=) end
      def print(*objs) notsupported(:print) end
      def printf(format,*objs) notsupported(:printf) end
      def putc(obj) notsupported(:putc) end
      def puts(*objs) notsupported(:puts) end
      def read(*args) notsupported(:read) end
      def readchar() notsupported(:readchar) end
      def readline(sep_string=$/) notsupported(:readline) end
      def readlines(sep_string=$/) notsupported(:readlines) end
      def readpartial(maxlen,*args)  notsupported(:readpartial) end
      def reopen(*args) notsupported(:reopen) end
      def rewind() notsupported(:rewind) end
      def seek() notsupported(:seek) end
      def stat() notsupported(:stat) end
      def sync() notsupported(:sync) end
      def sync=(v) notsupported(:sync=) end
      def sysread() notsupported(:sysread) end
      def sysseek() notsupported(:sysseek) end
      def syswrite() notsupported(:syswrite) end
      def ungetc() notsupported(:ungetc) end
      def write(str) notsupported(:write) end
      
      def callstr(func,*args)
        self.class.to_s+'['+self.to_s+']'+'.'+func.to_s+'('+args.join(',')+')'
      end
      
    end
  end
end
