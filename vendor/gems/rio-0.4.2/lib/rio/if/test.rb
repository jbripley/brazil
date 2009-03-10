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
  module IF
    module Test
      # Calls FileTest#blockdev?
      #  rio('afile').blockdev?     =>  true or false
      # Returns +true+ if the named file is a block device.
      def blockdev?() target.blockdev?() end

      # Calls FileTest#chardev?
      #  rio('afile').chardev?     =>  true or false
      # Returns +true+ if the named file is a character device.
      def chardev?() target.chardev? end

      # Calls FileTest#directory?
      #  rio('afile').directory?     =>  true or false
      # Returns +true+ if the named file is a directory, +false+ otherwise.
      def directory?() target.directory? end

      # Alias for #directory?
      def dir?() target.dir? end

      # Calls FileTest#exist?
      #  rio('afile').exist?()    =>  true or false
      # Returns +true+ if the named file exists.
      def exist?() target.exist? end

      # Calls FileTest#file?
      #  rio('afile').file?     => true or false
      # Returns +true+ if the named file exists and is a regular file.
      def file?() target.file? end

      # Calls FileTest#socket?
      #  rio('afile').socket?     =>  true or false
      # Returns +true+ if the named file is a socket.
      def socket?() target.socket? end 

      # Calls FileTest#symlink?
      #  rio('afile').symlink?     =>  true or false
      # Returns +true+ if the named file is a symbolic link.
      def symlink?() target.symlink? end

      # Returns +true+ if a Rio is not #closed?
      def open?() target.open?() end 

      # Calls IO#closed?
      #  ario.closed?    => true or false
      # Returns +true+ if _ario_ is completely closed (for duplex streams,
      # both reader and writer), +false+ otherwise.
      def closed?() target.closed?()  end

      # call-seq:
      #  fnmatch?( pattern, [flags] ) => (true or false)
      #
      # Calls File#fnmatch?
      #
      # Returns true if IF::Path#path matches <i>pattern</i>. The
      # pattern is not a regular expression; instead it follows rules
      # similar to shell filename globbing. It may contain the following
      # metacharacters:
      #
      # <i>flags</i> is a bitwise OR of the <code>FNM_xxx</code> parameters.
      # The same glob pattern and flags are used by <code>Dir::glob</code>.
      #
      #  rio('cat').fnmatch?('cat')              #=> true
      #  rio('category').fnmatch?('cat')         #=> false
      #  rio('cats').fnmatch?('c{at,ub}s')       #=> false
      #  rio('cubs').fnmatch?('c{at,ub}s')       #=> false
      #  rio('cat').fnmatch?('c{at,ub}s')        #=> false
      #
      #  rio('cat').fnmatch?('c?t')              #=> true
      #  rio('cat').fnmatch?('c\?t')             #=> false
      #  rio('cat').fnmatch?('c??t')             #=> false
      #  rio('cats').fnmatch?('c*')              #=> true
      #
      #  rio('cat').fnmatch?('c*t')                       #=> true
      #  rio('cat').fnmatch?('c\at')                      #=> true
      #  rio('cat').fnmatch?('c\at',File::FNM_NOESCAPE)   #=> false
      #  rio('a/b').fnmatch?('a?b')                       #=> true
      #  rio('a/b').fnmatch?('a?b',File::FNM_PATHNAME)    #=> false
      #
      #  rio('.profile').fnmatch?('*')                           #=> false
      #  rio('.profile').fnmatch?('*',File::FNM_DOTMATCH)        #=> true
      #  rio('dave/.profile').fnmatch?('*')                      #=> true
      #  rio('dave/.profile').fnmatch?('*',File::FNM_DOTMATCH)   #=> true
      #  rio('dave/.profile').fnmatch?('*',File::FNM_PATHNAME)   #=> false
      #
      def fnmatch?(*args) target.fnmatch?(*args) end

      # Calls File#ftype
      #
      # Identifies the type of the named file; the return string is one of 'file’, 'directory’, 
      # 'characterSpecial’, 'blockSpecial’, 'fifo’, 'link’, 'socket’, or 'unknown’.
      def ftype(*args) target.ftype(*args) end

      # Calls File#stat
      def stat(*args) target.stat(*args) end
      
      # Calls File#lstat
      def lstat(*args) target.lstat(*args) end

      # Calls FileTest#pipe?
      #  rio('afile').pipe?     =>  true or false
      # Returns +true+ if the named file is a pipe.
      def pipe?() target.pipe?() end


      # Calls File#atime
      #
      # Returns the last access time (a Time object) for the file system object referenced
      def atime(*args) target.atime(*args) end

      # Calls File#ctime
      #
      # Returns the change time for Rios that reference file system object (that is, 
      # the time directory information about the file was changed, not the file itself).    
      def ctime(*args) target.ctime(*args) end

      # Calls File#mtime
      #
      # Returns the modification time for Rio that reference file system objects
      def mtime(*args) target.mtime(*args) end

      # Calls File#executable?
      #
      # Returns true if the file is executable by the effective user id of this process.
      def executable?(*args) target.executable?(*args) end 

      # Calls File#executable_real?
      #
      # Returns true if the file is executable by the real user id of this process.
      def executable_real?(*args) target.executable_real?(*args) end 

      # Calls FileTest#readable?
      #  rio('afile').readable?     => true or false
      # Returns +true+ if the named file is readable by the effective user
      #      id of this process.
      def readable?(*args) target.readable?(*args) end 

      # Calls FileTest#readable_real?
      #  rio('afile').readable_real?     => true or false
      # Returns +true+ if the named file is readable by the real user id of
      # this process.
      def readable_real?(*args) target.readable_real?(*args) end 

      # Calls FileTest#writable?
      #  rio('afile').writable?     => true or false
      # Returns +true+ if the named file is writable by the effective user
      # id of this process.
      def writable?(*args) target.writable?(*args) end 

      # Calls FileTest#writable_real?
      #  rio('afile').writable_real?     => true or false
      # Returns +true+ if the named file is writable by the real user id of
      # this process.
      def writable_real?(*args) target.writable_real?(*args) end

      # Calls FileTest#sticky?
      #  rio('afile').sticky?     =>  true or false
      # Returns +true+ if the named file is a has the sticky bit set.
      def sticky?(*args) target.sticky?(*args) end 

      # Calls FileTest#owned?
      #  rio('afile').owned?     => true or false
      # Returns +true+ if the named file exists and the effective used id
      # of the calling process is the owner of the file.
      def owned?(*args) target.owned?(*args) end 

      # Calls FileTest#grpowned?
      #  rio('afile').grpowned?     => true or false
      # Returns +true+ if the named file exists and the effective group id
      # of the calling process is the owner of the file. Returns +false+ on
      # Windows.
      def grpowned?(*args) target.grpowned?(*args) end 

      # Calls FileTest#setgid?
      #  rio('afile').setgid?     =>  true or false
      # Returns +true+ if the named file is a has the setgid bit set.
      def setgid?(*args) target.setgid?(*args) end 
      
      # Calls FileTest#setuid?
      #  rio('afile').setuid?     =>  true or false
      # Returns +true+ if the named file is a has the setuid bit set.
      def setuid?(*args) target.setuid?(*args) end
      
      # Calls FileTest#size
      #  rio('afile').size     => integer
      # Returns the size of _afile_.
      # To get the length of the Rio's string representation use Rio#length
      def size(*args) target.size(*args) end 
      
      # Calls FileTest#size?
      #  rio('afile').size?     => integer  or  nil
      # Returns +nil+ if _afile_ doesn't exist or has zero size, the
      # size of the file otherwise.
      def size?(*args) target.size?(*args) end 
      
      # Calls FileTest#zero?
      #  rio('afile').zero?     => true or false
      # Returns +true+ if the named file exists and has a zero size.
      def zero?(*args) target.zero?(*args) end


      # Returns true if the rio represents an absolute path or URI. Alias for IF::Test#absolute?
      #
      #  rio('/tmp').abs?                     # >> true
      #  rio('.ssh').abs?                     # >> false
      #  rio('file:///tmp').abs?              # >> true
      #  rio('http://www.ruby-doc.org/').abs? # >> true
      # 
      def abs?() target.abs?()  end


      # Returns true if the Rio represents and absolute path or URI. Calls URI#absolute?
      #
      #  rio('/tmp').absolute?                     # >> true
      #  rio('.ssh').absolute?                     # >> false
      #  rio('file:///tmp').absolute?              # >> true
      #  rio('http://www.ruby-doc.org/').absolute? # >> true
      # 
      def absolute?() target.absolute?()  end

      # Calls Pathname#mountpoint?
      #
      # Returns +true+ if <tt>self</tt> points to a mountpoint.
      def mountpoint?() target.mountpoint?()  end
      
      # Calls Pathname#root?
      #
      # #root? is a predicate for root directories.  I.e. it returns +true+ if the
      # pathname consists of consecutive slashes.
      #
      # It doesn't access the actual filesystem.  So it may return +false+ for some
      # pathnames which points to roots such as <tt>/usr/..</tt>.
      #
      def root?() target.root?()  end

      
    end
  end
end

module RIO
  class Rio
    include RIO::IF::Test
  end
end
