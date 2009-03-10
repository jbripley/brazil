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
  class NotSupportedException < ArgumentError  #:nodoc: all
    def self.emsg(fname,obj)
      "#{fname}() is not supported for #{obj.class} objects" 
    end

  end
  class NullIOMode #:nodoc: all
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
  class NullIO  #:nodoc: all
    def initialize(a=nil,m='r')
#      p "#{callstr('initialize',a,m)} hnd=#{@hnd.inspect}"
      @lineno = 0
      @open = true
      @mode = NullIOMode.new(m)
    end
    def lineno() @lineno end
    def lineno=(a) @lineno = a end
    def self.open(a=nil,m='r',&block)
      rtn = io = new(a,m)
      if block_given?
        rtn = yield(io)
        io.close
      end
      rtn
    end
    def fileno() nil end
    def flush() nil end
    def fsync() nil end
    def isatty() false end
    def tty?() false end
    def pos() 0 end
    def pos=(n) 0 end

    def readchar() nil end
    def read() nil end
    def getc() nil end

    def closed?
      not @open
    end
    def close
      @open = false
    end
    def eof?()
      true
    end
    def each_line(sep_string=$/,&block) 
      self
    end
    def each_byte(sep_string=$/,&block) 
      nil
    end
    def fcntl(integer_cmd,arg)
      raise NotSupportedException,NotSupportedException.emsg('fcntl',self)
    end
    def ioctl(integer_cmd,arg)
      raise NotSupportedException,NotSupportedException.emsg('fcntl',self)
    end
    alias each each_line
    def gets(sep_string=$/)
      raise IOError,"NullIO is not open for reading" unless @mode.can_read?
      nil
    end
    def readline(sep_string=$/)
      raise EOFError
    end
    
    def readlines(sep_string=$/)
      []
    end
    def rewind
      @lineno = 0
    end
    def print(*objs)
      raise IOError,"NullIO is not open for writing" unless @mode.can_write?
      nil
    end
    def close_read(*objs)
      raise IOError,"NullIO is not a duplex stream"
      nil
    end
    def close_write(*objs)
      raise IOError,"NullIO is not a duplex stream"
      nil
    end
    def <<(obj)
      self
    end
    def puts(*objs)
      nil
    end
    def write(string)
      print(string)
      string.size
    end
    def binmode() nil end
    def printf(fmt,*args)
      print(sprintf(fmt,*args))
    end
    def callstr(func,*args)
      self.class.to_s+'['+self.to_s+']'+'.'+func.to_s+'('+args.join(',')+')'
    end
    
  end
end
