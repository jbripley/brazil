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
    module Dir
      # Calls ::Dir#chdir.
      #
      # Changes the current working directory of the process to the directory specified by the Rio. 
      # Raises a SystemCallError (probably Errno::ENOENT) if the target directory does not exist or 
      # if the Rio does not reference a directory.
      #
      # If a block is given changes to the directory specified by the rio for the length of the block
      # and changes back outside the block
      #
      # Returns the Rio
      #
      #  rio('/home').chdir  # change the current working directory to /home
      #  # the working directory here is /home
      #  rio('/tmp/data/mydata').delete!.mkpath.chdir {
      #     # the working directory here is /tmp/data/mydata
      #  }
      #  # the working directory here is /home
      #
      def chdir(&block) target.chdir(&block);self end



      # Calls Find#find
      #
      # Uses ::Find#find to find all entries recursively for a Rio that 
      # specifies a directory. Note that there are other ways to recurse through
      # a directory structure using a Rio. See IF::Grande#each and IF::GrandeEntry#all.
      #
      # Calls the block passing a Rio for each entry found. The Rio inherits
      # file attrubutes from the directory Rio.
      #
      # Returns itself
      #
      #  rio('adir').find { |entrio| puts "#{entrio}: #{entrio.file?}" }
      #
      #  rio('adir').chomp.find do |entrio|
      #    next unless entrio.file?
      #    lines = entrio[0..10]  # lines are chomped because 'chomp' was inherited
      #  end
      #
      def find(*args,&block) target.find_entries(*args,&block); self end


      # Calls ::Dir#glob
      #
      # Returns the filenames found by expanding the pattern given in string, 
      # either as an array or as parameters to the block. In both cases the filenames
      # are expressed as a Rio.
      # Note that this pattern is not a regexp (it’s closer to a shell glob). 
      # See File::fnmatch for details of file name matching and the meaning of the flags parameter.
      #
      #
      def glob(string,*args,&block) target.glob(string,*args,&block) end


      # Calls ::Dir#rmdir
      #
      # Deletes the directory referenced by the Rio. 
      # Raises a subclass of SystemCallError if the directory isn’t empty.
      # Returns the Rio. If the directory does not exist, just returns the Rio.
      #
      # See also #rmtree, IF::Grande#delete, IF::Grande#delete!
      #
      #    rio('adir').rmdir # remove the empty directory 'adir'
      #
      def rmdir() target.rmdir(); self end


      # Calls FileUtils#rmtree
      #
      # Removes a directory Rio recursively. Returns the Rio. 
      # If the directory does not exist, simply returns the Rio
      #
      # If called with a block, behaves as if <tt>rmtree.each(&block)</tt> had been called
      # 
      # See also IF::Grande#delete!
      #
      #  rio('adir').rmtree # removes the directory 'adir' recursively
      #
      #  # delete the directory 'adir', recreate it and then change to the new directory
      #  rio('adir/asubdir').rmtree.mkpath.chdir {
      #    ...
      #  }
      #
      # 
      def rmtree() target.rmtree(); self end

      # Calls FileUtils#mkpath
      #
      # Makes a new directory named by the Rio and any directories in its path that do not exist.
      # 
      # Returns the Rio. If the directory already exists, just returns the Rio.
      #
      #  rio('adir/a/b').mkpath
      def mkpath(&block) target.mkpath(&block); self end

      
      # Calls FileUtils#mkdir
      #
      # Makes a new directory named by the Rio with permissions specified by the optional parameter. 
      # The permissions may be modified by the value of File::umask
      #
      # Returns the Rio. If the directory already exists, just returns the Rio.
      #
      #  rio('adir').mkdir
      def mkdir(*args,&block) target.mkdir(*args,&block); self end



    end
  end
end

module RIO
  class Rio
    include RIO::IF::Dir
  end
end
