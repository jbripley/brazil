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
    module GrandeEntry
      # Grande Directory Selection Method 
      #
      # Sets the rio to return directories. _args_ can be used to select which directories are returned.
      #  ario.dirs(*args) do |f|
      #    f.directory?      #=> true
      #  end
      #
      # No aguments selects all directories.
      # if _args_ are:
      # Regexp:: selects matching directories
      # glob::   selects matching directories
      # Proc::   called for each directory. the directory is processed unless the proc returns false
      # Symbol:: sent to each directory. Each directory is processed unless the symbol returns false
      # Fixnum:: matched against the "depth" of the directory
      #
      # If a block is given, behaves like <tt>ario.dirs(*args).each(&block)</tt>
      #
      # See also #files, #entries, #skipdirs
      #
      #  rio('adir').dirs { |frio| ... } # process all directories in 'adir'    
      #  rio('adir').all.dirs { |frio| ... } #  same thing recursively
      #  rio('adir').dirs(/^\./) { |frio| ...} # process dot directories
      #  rio('adir').dirs[/^\./] # return an array of dot directories
      #  rio('adir').dirs[:symlink?] # an array of symlinks to directories
      #
      # Given the directory structure 'adir/a/b/c/d'
      #
      #  rio('adir').all.dirs[2]          #=> 'adir/a/b'
      #  rio('adir').all.dirs[0..2]       #=> 'adir/a','adir/a/b'
      #  rio('adir').all.skipdirs[0..2]   #=> 'adir/a/b/c','adir/a/b/c/d'
      #
      def dirs(*args,&block) target.dirs(*args,&block); self end
      
      # Grande Directory Exclude Method 
      #
      # If no args are provided selects anything but directories.
      #  ario.skipdirs do |el|
      #    el.directory?     #=> false
      #  end
      # If args are provided, sets the rio to select directories as with #dirs, but the arguments are
      # used to determine which directories will *not* be processed
      #
      # If a block is given behaves like 
      #  ario.skipdirs(*args).each(&block)
      #
      # See #dirs
      #
      #  rio('adir').skipdirs { |ent| ... } # iterate through everything except directories
      #  rio('adir').skipdirs(/^\./) { |drio| ... } # iterate through directories, skipping dot directories
      # 
      #
      def skipdirs(*args,&block) target.skipdirs(*args,&block); self end


      # Grande Directory Entry Selection Method 
      #
      # No aguments selects all entries.
      #
      # if +args+ are:
      # Regexp:: selects matching entries
      # glob::   selects matching entries
      # Proc::   called for each entry. the entry is processed unless the proc returns false
      # Symbol:: sent to each entry. Each entry is processed unless the symbol returns false
      #
      # If a block is given, behaves like <tt>ario.etries(*args).each(&block)</tt>
      #
      # See also #files, #dirs, #skipentries
      #
      #  rio('adir').entries { |frio| ... } # process all entries in 'adir'    
      #  rio('adir').all.entries { |frio| ... } #  same thing recursively
      #  rio('adir').entries(/^\./) { |frio| ...} # process entries starting with a dot
      #  rio('adir').entries[/^\./] # return an array of all entries starting with a dot
      #  rio('adir').entries[:symlink?] # an array of symlinks in 'adir'
      #
      def entries(*args,&block) target.entries(*args,&block); self end

      # Grande Directory Entry Rejection Method 
      #
      # No aguments rejects all entries.
      #
      # Behaves like #entries, except that matching entries are excluded.
      #
      # See also #entries, IF::Grande#skip
      #
      def skipentries(*args,&block) target.skipentries(*args,&block); self end

      
      # Grande File Selection Method 
      #
      # Configures the rio to process files. +args+ can be used to select which files are returned.
      #  ario.files(*args) do |f|
      #    f.file?      #=> true
      #  end
      # No aguments selects all files.
      #
      # +args+ may be zero or more of the following:
      #
      # Regexp:: selects matching files
      # String:: treated as a glob, and selects matching files
      # Proc::   called for each file. the file is processed unless the proc returns false
      # Symbol:: sent to each file. Each file is processed unless the symbol returns false
      #
      # +files+ returns the Rio which called it. This might seem counter-intuitive at first. 
      # One might reasonably assume that
      #  rio('adir').files('*.rb')
      # would return files. It does not. It configures the rio to return files and returns
      # the Rio. This enables chaining for further configuration so constructs like
      #  rio('adir').all.files('*.rb').norecurse('.svn')
      # are possible.
      #
      # If a block is given, behaves like 
      #  ario.files(*args).each
      #
      # 
      # See also #dirs, #entries, #skipfiles
      #
      #  rio('adir').files { |frio| ... } # process all files in 'adir'    
      #  rio('adir').all.files { |frio| ... } #  same thing recursively
      #  rio('adir').files('*.rb') { |frio| ...} # process .rb files
      #  rio('adir').files['*.rb'] # return an array of .rb files
      #  rio('adir').files[/\.rb$/] # same thing using a regular expression
      #  rio('adir').files[:symlink?] # an array of symlinks to files
      #  rio('adir').files >> rio('other_dir') # copy files to 'other_dir'
      #  rio('adir').files('*.rb') >> rio('other_dir') # only copy .rb files
      #
      # For Rios that refer to files, <tt>files(*args)</tt> causes the file to be processed only if 
      # it meets the criteria specified by the args.
      #
      #  rio('afile.z').files['*.z'] #=> [rio('afile.z')]
      #  rio('afile.q').files['*.z'] #=> []
      #
      # === Example Problem
      #
      # Fill the array +ruby_progs+ with all ruby programs in a directory and its subdirectories, 
      # skipping those in _subversion_ (.svn) directories. 
      #
      #  ruby_progs = []
      # 
      # For the purposes of this problem, a Ruby program is defined as a file ending with .rb or a file
      # that is executable and whose shebang line contains 'ruby':
      #
      #  is_ruby_exe = proc{ |f| f.executable? and f.gets =~ /^#!.+ruby/ }
      #
      # ==== Solution 1. Use the subscript operator.
      #
      #  ruby_progs = rio('adir').norecurse('.svn').files['*.rb',is_ruby_exe]
      #
      # Explanation:
      #
      # 1. Create the Rio
      #
      #    Create a Rio for a directory
      #     rio('adir')
      #
      # 2. Configure the Rio
      #
      #    Specify recursion and that '.svn' directories should not be included.
      #     rio('adir').norecurse('.svn')
      #    Select files
      #     rio('adir').norecurse('.svn').files
      #    Limit to files ending with '.rb'
      #     rio('adir').norecurse('.svn').files('*.rb')
      #    Also allow files for whom +is_ruby_exe+ returns true
      #     rio('adir').norecurse('.svn').files('*.rb',is_ruby_exe)
      #
      # 3. Do the I/O
      #
      #    Return an array rather than iterating thru them
      #     ruby_progs = rio('adir').norecurse('.svn').files['*.rb',is_ruby_exe]
      #
      # ==== Solution  2. Use the copy-to operator
      #
      #  rio('adir').files('*.rb',is_ruby_exe).norecurse('.svn') > ruby_progs
      #
      # Explanation:
      #
      # 1. Create the Rio
      #
      #    Create a Rio for a directory
      #     rio('adir')
      #
      # 2. Configure the Rio
      #
      #    Select only files
      #     rio('adir').files
      #    Limit to files ending with '.rb'
      #     rio('adir').files('*.rb')
      #    Also allow files for whom +is_ruby_exe+ returns true
      #     rio('adir').files('*.rb',is_ruby_exe)
      #    Specify recursion and that '.svn' directories should not be included.
      #     rio('adir').files('*.rb',is_ruby_exe).norecurse('.svn')
      #
      # 3. Do the I/O
      #
      #    Copy the Rio to ruby_progs
      #     rio('adir').files('*.rb',is_ruby_exe).norecurse('.svn') > ruby_progs
      #
      # ==== Example Discussion
      #
      # Note that the only difference between Step 2 of Solution 1 and that of Solution 2 is 
      # the order of the configuration methods. Step 2 of Solution 1 would have worked equally 
      # well:
      #
      #  rio('adir').norecurse('.svn').files('*.rb',is_ruby_exe) > ruby_progs
      #
      # Furthermore if our problem were changed slightly and instead of having our results
      # ending up in an array, we wished to iterate through them, we could use:
      #
      #  rio('adir').norecurse('.svn').files('*.rb',is_ruby_exe) { |ruby_prog_rio| ... }
      #
      # Note the similarities. In fact, solution 1 could have been written:
      #  
      #  rio('adir').norecurse('.svn').files('*.rb',is_ruby_exe).to_a
      # or
      #  rio('adir').norecurse('.svn').files('*.rb',is_ruby_exe)[]
      #
      # Passing the arguments for +files+ to the subscript operator is syntactic sugar.
      # The subscript operator does not really take any arguments of its own. It always
      # passes them to the most recently called of the grande selection methods (or the
      # default selection method, if none have been called). So,
      #
      #  rio('adir').files['*.rb']
      # is a shortcut for
      #  rio('adir').files('*.rb').to_a
      #
      # and
      #
      #  rio('adir')['*.rb']
      # is a shortcut for
      #  rio('adir').entries('*.rb').to_a
      #
      # and
      #
      #  rio('afile').lines[0..10]
      # is a shortcut for
      #  rio('afile').lines(0..10).to_a
      #
      # And so on.
      # 
      #
      #
      def files(*args,&block) target.files(*args,&block); self end

      # Grande File Exclude Method 
      #
      # If no args are provided selects anything but files.
      #  ario.skipfiles do |el|
      #    el.file?     #=> false
      #  end
      # If args are provided, sets the rio to select files as with #files, but the arguments are
      # used to determine which files will *not* be processed
      #
      # If a block is given behaves like <tt>ario.skipfiles(*args).each(&block)</tt>
      #
      # See #files, IF::Grande#skip
      #
      #  rio('adir').skipfiles { |ent| ... } # iterate through everything except files
      #  rio('adir').skipfiles('*~') { |frio| ... } # iterate through files, skipping those ending with a tilde
      # 
      #
      def skipfiles(*args,&block) target.skipfiles(*args,&block); self end


      # Returns +true+ if the rio is in +all+ (recursive) mode. See #all
      #
      #  adir = rio('adir').all.dirs
      #  adir.all? # true
      #  adir.each do |subdir|
      #    subdir.all?  # true
      #  end
      #
      #  rio('adir').all? # false
      #  
      def all?() target.all?() end


      # Grande Directory Recursion Method
      # 
      # Sets the Rio to all mode (recursive)
      # 
      # When called with a block, behaves as if all.each(&block) had been called
      # 
      # +all+ causes subsequent calls to +files+ or +dirs+ to be applied recursively
      # to subdirectories
      #
      #  rio('adir').all.files('*.[ch]').each { |file| ... } # process all c language source files in adir 
      #                                                      # and all subdirectories of adir
      #  rio('adir').all.files(/\.[ch]$/) { |file| ... }     # same as above
      #  rio('adir').files("*.[ch]").all { |file| ... }      # once again
      #  rio('adir').all.files["*.[ch]"]                     # same, but return an array instead of iterating
      #  
      def all(arg=true,&block) target.all(arg,&block); self end


      # Grande Directory Recursion Selection Method
      # 
      # Sets the Rio to recurse into directories like #all. If no args are provided behaves like #all. 
      # If args are provided, they are processed like #dirs to select which subdirectories should 
      # be recursed into. #recurse always implies #all.
      #
      # +args+ may be one or more of:
      # Regexp::  recurse into matching subdirectories
      # glob::    recurse into matching subdirectories
      # Proc::    called for each directory. The directory is recursed into unless the proc returns false
      # Symbol::  sent to each directory. Each directory is recursed into unless the symbol returns false
      # Fixnum::  recurse into directories only at the given depth
      # Range::   recurse into directories at a range of depths
      #
      # If a block is given, behaves like <tt>ario.recurse(*args).each(&block)</tt>
      #
      # See also #norecurse, #all, #dirs
      #
      #  rio('adir').recurse('test*') { |drio| ... } # process all entries and all entries in subdirectories
      #                                              # starting with 'test' -- recursively
      #
      def recurse(*args,&block) target.recurse(*args,&block); self end


      # Grande Directory Recursion Exclude Method
      # 
      # Sets the Rio to recurse into directories like #all. If no args are provided, no
      # directories will be recursed into. If args are provided, behaves like #recurse, except
      # that matching directories will *not* be recursed into
      #
      #  rio('adir').norecurse('.svn') { |drio| ... } # recurse, skipping subversion directories
      #
      #  rio('adir').norecurse(3) {|drio| ... } # only recurse 2 levels deep into a directory structure
      #
      def norecurse(*args,&block) target.norecurse(*args,&block); self end


    end
  end
end

module RIO
  class Rio
    include RIO::IF::GrandeEntry
  end
end
