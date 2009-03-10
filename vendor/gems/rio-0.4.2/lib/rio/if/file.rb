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
    module File
      
      # Calls FileUtils#rm
      #
      # Deletes the referenced file, returning the Rio. Raises an exception on any error. 
      #
      # See also IF::Grande#delete, IF::Grande#delete!, IF::Dir#rmdir.
      def rm() target.rm(); self end
      
      
      # Calls FileUtils#touch
      #
      # Updates modification time (mtime) and access time (atime) of a Rio.
      # A file is created if it doesn't exist.
      #
      def touch() target.touch(); self end
      
      # Calls File#truncate
      #
      # Truncates a file referenced by a Rio to be at most +sz+ bytes long. 
      # Not available on all platforms.
      #
      #  f = rio("out")
      #  f.print!("1234567890")
      #  f.size                     #=> 10
      #  f.truncate(5)
      #  f.size()                   #=> 5
      #
      # If called with no arguments, truncates the Rio at the
      # value returned by IF::FileOrDir#pos().
      #  f.read(2)
      #  f.truncate.size            #=> 2
      #  f.contents                 #=> "12"
      #
      # Returns the Rio
      #
      def truncate(sz=pos()) target.truncate(sz); self end
      
      # Calls IF::File#truncate(0)
      #
      def clear() target.clear(); self end

    end
  end
end

module RIO
  class Rio
    include RIO::IF::File
  end
end
