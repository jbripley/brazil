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
    module GrandeStream

      # Calls #lines(*args) but when used with the subscript operator
      # returns the first element of the returned array instead of the array.
      #
      # If afile contains ["line 0\n","line 1\n"]
      #  rio('afile').line[0]       #=> "line 0\n"
      #  rio('afile').line[1]       #=> "line 1\n"
      #  rio('afile').lines[0]      #=> ["line 0\n"]
      #  rio('afile').lines[1]      #=> ["line 1\n"]
      #  rio('afile').lines[0][0]   #=> "line 0\n"
      #  rio('afile').lines[1][0]   #=> "line 1\n"
      def line(*args,&block) target.line(*args,&block); self end


      # See #line.
      def record(*args,&block) target.record(*args,&block); self end


      # See #line.
      def row(*args,&block) target.row(*args,&block); self end
      

      # Sets the rio to read lines and returns the Rio
      # 
      # If called with a block behaves as if <tt>lines(*args).each(&block)</tt> had been called
      # 
      # +lines+ returns the Rio which called it. This might seem counter-intuitive at first. 
      # One might reasonably assume that
      #  rio('adir').lines(0..10)
      # would return lines. It does not. It configures the rio to return lines and returns
      # the Rio. This enables chaining for further configuration so constructs like
      #  rio('afile').lines(0..10).skiplines(/::/)
      # are possible.
      #
      # If args are provided they may be one or more of the following:
      # Regexp::  any matching record will be processed
      # Range::   specifies a range of records (zero-based) to be included
      # Integer:: interpreted as a one element range of lines to be processed
      # Proc::    a proc which will be called for each record, records are included unless nil or false is returned
      # Symbol::  a symbol which will _sent_ to each record, records are included unless nil or false is returned
      # Array::   an array of other selectors. records are selected unless any of the matches fail.
      #
      #  rio('f.txt').lines(/^\s*#/) { |line| ... } # iterate over comment-only lines
      #  rio('f.txt').lines(/^\s*#/).each { |line| ... } # same as above
      #
      #  rio('f.txt').lines(1,7..9) > rio('anotherfile.txt') # copy lines 1,7,8 and 9 to anotherfile.txt
      #
      #  rio('f.txt').lines(1...3).to_a # return an array containing lines 1 and 2 of f.txt
      #  rio('f.txt').lines[1...3]      # same thing
      #
      def lines(*args,&block) target.lines(*args,&block); self end

      # Sets the rio to read bytes and returns the rio
      #
      # _n_ specifies the number of bytes to be returned on each iteration of IF::Grande#each or by IF::GrandeStream#getrec. If _args_
      # are provided, they are treated as record selectors as if <tt>ario.bytes(n).records(*args)</tt> had been
      # called. See also #records, #lines, IF::Grande#each, IF::Grande#[]
      # 
      # If called with a block behaves as if <tt>ario.bytes(n,*args).each(&block)</tt> had been called
      # 
      #  rio('f.dat').bytes(1024) { |rec| ... }      # iterate through f.txt 1024 bytes at a time
      #  rio('f.dat').bytes(1024).each { |rec| ... } # same as above
      #
      #  rio('f.dat').bytes(1024,0..4) { |rec| ... } # iterate through the first five 1024 byte blocks
      #
      #  rio('f.dat').bytes(64).to_a # return the contents of f.dat as an array of 64 byte chunks
      #
      #  rio('f.dat').bytes(512).records(0,7..9) > rio('dfile.dat') # copy 512-byte blocks 0,7,8 and 9 to dfile.dat
      #
      #  rio('f.dat').bytes(2048).records[0...10] # return an array containing the first 10 2K blocks of f.dat
      #  rio('f.dat').bytes(2048)[0...10]         # same thing
      #
      #  rio('f.dat').bytes { |bytestr| ... } # iterate over f.dat 1 byte at a time. 
      #  rio('f.dat').bytes[0...100]          # returns an array of the first 100 bytes of f.dat
      #
      def bytes(n=1,*args,&block) target.bytes(n,*args,&block); self end


      # Specifies which records will be iterated through by IF::Grande#each or returned by IF::GrandeStream#getrec
      # 
      # If called with a block behaves as if <tt>records(*args).each(&block)</tt> had been called
      # 
      # Returns the Rio
      #
      # If no args are provided, all records are selected. 
      # What constitutes a record is affected by #lines,#bytes,
      # and extensions such as IF::CSV#csv and IF::YAML#yaml.
      #
      # If args are provided they may be one or more of the following:
      # Regexp::  any matching record will be iterated over by IF::Grande#each or returned by IF::GrandeStream#getrec
      # Integer:: specifies a record-number (zero-based) to be iterated over by IF::Grande#each or returned by IF::GrandeStream#getrec
      # Range::   specifies a range of records (zero-based) to included in the iteration
      # Proc::    a proc which will be called for each record, records are included unless nil or false is returned
      # Symbol::  a symbol which will _sent_ to each record, records are included unless nil or false is returned
      # Array::   an array of any of above. All must match for a line to be included
      #
      # Any other argument type is compared with the record using its <tt>===</tt> method.
      #
      # If the argument is a ::Proc it may be called with one, two or three paramaters.
      # 1. the record
      # 2. the recno (optional)
      # 3. the rio (optional)
      #
      # Note in the following examples that since +lines+ is the default <tt>ario.records(*args)</tt>
      # is effectively the same as <tt>ario.lines(*args)</tt>.
      #
      #  rio('afile').records(0) { |line| ... } # iterate over the first line of 'afile'
      #  rio('afile').records(0,5..7)) { |line| ... } # iterate over lines 0,5,6 and 7
      #  rio('afile').records(/Zippy/) { |line| ... } # iterate over all lines containing 'Zippy'
      #
      # 
      #  rio('f.csv').puts!(["h0,h1","f0,f1"]) # Create f.csv                
      #
      #  rio('f.csv').csv.records[]    #==>[["h0", "h1"], ["f0", "f1"]]
      #  rio('f.csv').csv.lines[]      #==>["h0,h1\n", "f0,f1\n"]
      #  rio('f.csv').csv.records[0]   #==>[["h0", "h1"]]
      #
      def records(*args,&block) target.records(*args,&block); self end


      # Specifies records which should *not* be iterated through by IF::Grande#each or returned by IF::GrandeStream#getrec
      # 
      # If called with a block behaves as if <tt>skiprecords(*args).each(&block)</tt>
      # had been called
      # 
      # Returns the Rio
      #
      # See also #records, #skiplines, #lines, IF::Grande#skip
      #
      # If no args are provided, no records are rejected. What constitutes a record is affected by #lines,#bytes,
      # and extensions such as IF::CSV#csv and IF::YAML#yaml.
      #
      # If args are provided they may be one or more of the following:
      # Regexp::  any matching record will not be processed
      # Integer:: specifies a record-number (zero-based) to be skipped
      # Range::   specifies a range of records (zero-based) to be excluded
      # Proc::    a proc which will be called for each record, records are excluded unless nil or false is returned
      # Symbol::  a symbol which will _sent_ to each record, records are excluded unless nil or false is returned
      # Array::   an array of any of the above, all of which must match for the array to match.
      #
      # Note in the following examples that since +lines+ is the default record 
      # type <tt>ario.skiprecords(*args)</tt> is effectively 
      # the same as <tt>ario.skiplines(*args)</tt>.
      #
      #  rio('afile').skiprecords(0) { |line| ... } # iterate over all but the first line of 'afile'
      #  rio('afile').skiprecords(0,5..7)) { |line| ... } # don't iterate over lines 0,5,6 and 7
      #  rio('afile').skiprecords(/Zippy/) { |line| ... } # skip all lines containing 'Zippy'
      #  rio('afile').chomp.skiplines(:empty?) { |line| ... } # skip empty lines
      #
      def skiprecords(*args,&block) target.skiprecords(*args,&block); self end


      # Sets the Rio to read lines and specifies lines which should *not* be iterated through by IF::Grande#each or 
      # returned by IF::GrandeStream#getrec
      # 
      # If called with a block behaves as if <tt>skiplines(*args).each(&block)</tt> had been called
      # 
      # Returns the Rio
      #
      # See also #lines, #records, IF::Grande#skip
      #
      # If no args are provided, no lines are rejected.
      #
      # If args are provided they may be one or more of the following:
      # Regexp::  any matching line will not be processed
      # Integer:: specifies a line-number (zero-based) to be skipped
      # Range::   specifies a range of lines (zero-based) to be excluded
      # Proc::    a proc which will be called for each line, lines are excluded unless nil or false is returned
      # Symbol::  a symbol which will _sent_ to each line, lines are excluded unless nil or false is returned
      # Array::   an array of any of above. All must match for a line to be included
      #
      #  rio('afile').skiplines(0) { |line| ... } # iterate over all but the first line of 'afile'
      #  rio('afile').skiplines(0,5..7)) { |line| ... } # don't iterate over lines 0,5,6 and 7
      #  rio('afile').skiplines(/Zippy/) { |line| ... } # skip all lines containing 'Zippy'
      #  rio('afile').chomp.skiplines(:empty?) { |line| ... } # skip empty lines
      #
      def skiplines(*args,&block) target.skiplines(*args,&block); self end


      # Sets the Rio to read rows and specifies rows which should be iterated through 
      # by IF::Grande#each or returned by IF::GrandeStream#getrec.
      # #rows is intended for use by extensions, where the concept of a row is reasonable. 
      # In the absensence of an extension behaves like #records.
      def rows(*args,&block) target.rows(*args,&block); self end


      # Sets the Rio to read rows and specifies lines which should *not* be iterated 
      # through by IF::Grande#each or returned by IF::GrandeStream#getrec
      # #skiprows is intended for use by extensions, where the concept of a row is 
      # reasonable. In the absence of an extension behaves like #skiprecords
      def skiprows(*args,&block) target.skiprows(*args,&block); self end


      # Temporarily set the Rio to read records, and call IF::Grande#get
      #
      # See also IF::GrandeStream#records, IF::GrandeStream#lines, IF::Grande#each, IF::Grande#[]
      #
      def getrec() target.getrec() end


      # Temporarily set the Rio to read rows, and call IF::Grande#get
      #
      # See also IF::GrandeStream#rows, IF::GrandeStream#lines, IF::Grande#each, IF::Grande#[]
      #
      def getrow() target.getrow() end


      # Temporarily set the Rio to read lines, and call IF::Grande#get
      #
      # See also IF::GrandeStream#records, IF::GrandeStream#lines, IF::Grande#each, IF::Grande#[]
      #
      def getline() target.getline() end


      # Slurps the contents of the rio into a string.
      #
      #  astring = rio('afile.txt').contents # slurp the entire contents of afile.txt into astring
      # 
      def contents() target.contents() end


      # Writes a single record to a Rio
      def putrec(el) target.putrec(el) end


      # Sets the implicit output mode to 'a'.
      # 
      # This is the mode Rio will use for output when no mode is specified
      #
      # Rios normally don't need to be opened or have their open mode specified. A Rio determines the mode
      # based on the file system object and on the action specified. For instance when a Rio encounters
      # a +read+ on a file it opens the file for reading using File#open and calls IO#read; when it encounters
      # a +read+ on a directory it knows to use Dir#open and call Dir#read. When it encounters a IF::RubyIO#puts, it knows
      # to perform a File#open, and call IO#puts on the returned handle. By default when a method requires
      # a file be opened for writing the file is opened with a mode of 'w'. #a changes this implicit 
      # output mode to 'a'. 
      #
      # Note that this is not the same as setting the output mode *explicitly*, as in rio('afile').mode('a').
      # When the mode is set explicitly using IF::RubyIO#mode, the mode specified will be used regardless of
      # the operation being performed. The #a method only affects how Rio opens a file when
      # it sees an operator that requires writing, and must determine for itself how to open it.
      #
      #  rio('afile').puts!('Hello World') # call IO#puts on a file handle opened in 'w' mode
      #  rio('afile').a.puts!('Hello World') # call IO#puts on a file handle opened in 'a' mode
      # 
      # See also #a!, #w! for setting the implicit output mode 'a+' and 'w+' respectively
      #
      # The methods #a, #a!, #w, #w!, #r, #r! set the +implicit+ open mode 
      # to 'a','a+','w','w+','r' and 'r+' respectively. 
      #
      # See also #+@
      def a() target.a(); self end


      # Unary Plus. Alternate form of #a
      #  rio('f1') > rio('f2')     # copy f1 to f2
      #  rio('f1') > rio('f2').a   # append f1 to f2
      #  rio('f1') > +rio('f2')    # same thing
      #  rio('f1') >> rio('f2')    # same thing
      # 
      def +@()
        RIO::no_warn { +target }
        self
      end


      # Sets the implicit output mode to 'a+'. 
      # 
      # The implicit output mode is the mode Rio will use for output when no mode is specified.
      #
      # Returns the Rio
      #
      # See the discussion for #a. 
      #
      def a!() target.a!(); self end


      # Sets the implicit input mode to 'r'. 
      # 
      # The implicit input mode is the mode Rio will use for input when no mode is specified.
      #
      # Returns the Rio
      #
      # See the discussion for #a. 
      #
      # Since 'r' is the implicit input mode used by default, this method
      # is probably uneeded.
      #
      def r() target.r(); self end


      # Sets the implicit input mode to 'r+'. 
      # 
      # The implicit input mode is the mode Rio will use for input when no mode is specified.
      #
      # Returns the Rio
      #
      # See the discussion for #a. 
      #
      def r!() target.r!(); self end


      # Sets the implicit output mode to 'w'. 
      # 
      # The implicit output mode is the mode Rio will use for output when no mode is specified.
      #
      # Returns the Rio
      #
      # See the discussion for #a. 
      #
      # Since 'w' is the implicit output mode used by default, this method
      # is uneeded, but is provided for completeness..
      #
      def w() target.w(); self end


      # Sets the implicit output mode to 'w+'. 
      # 
      # The implicit output mode is the mode Rio will use for output when no mode is specified.
      #
      # Returns the Rio
      #
      #  rio(?-,'cat').w!.puts!("Hello Kitty").readline #=> "Hello Kitty"
      #
      # See the discussion for #a. 
      #
      def w!() target.w!(); self end


      # Set the Rio's closeoneof mode. 
      #
      #  ario.closeoneof(&block) => ario
      #
      # +closeoneof+ causes a Rio to be closed automatically whenever the end of
      # file is reached. This affects# all methods that read from 
      # a rio (IF::RubyIO#readlines, #to_a, IF::Grande#each IF::RubyIO#gets etc.)
      # Because +closeoneof+ must be on for many of Rio's most useful idioms,
      # it is on by default. +closeoneof+ can be turned off using #nocloseoneof.
      # 
      # If a block is given behaves like <tt>ario.closeoneof.each(&block)</tt> had been called
      # 
      # Returns the Rio
      # 
      #  ario = rio('afile')
      #  lines = ario.readlines
      #  ario.closed?     #=> true
      #
      #  ario = rio('afile').nocloseoneof
      #  lines = ario.readlines
      #  ario.closed?     #=> false
      #  ario.close       # must be explicitly closed
      #
      # +closeoneof+ is ignored by directory Rios, however, setting it on a directory Rio 
      # causes each file Rio returned while iterating to inherit the directory's setting
      #
      #  rio('adir').files do |file|
      #    file.closeoneof?    #=> true
      #  end
      #
      #  rio('adir').files.nocloseoneof do |file|
      #    file.closeoneof?    #=> false
      #  end
      #
      #  rio('adir').files.nocloseoneof['*.rb'] # array of .rb file Rios in adir with closeoneof off
      #
      #  drio = rio('adir').files
      #  frio1 = drio.read
      #  frio1.closeoneof?    #=> true
      #  drio.nocloseoneof
      #  frio2 = drio.read 
      #  frio2.closeoneof?    #=> false
      #
      #  
      def closeoneof(arg=true,&block) target.closeoneof(arg,&block); self end


      # Set the Rio's closeoneof mode to false
      #  ario.nocloseoneof(&block) => ario
      # See #closeoneof
      # 
      # If a block is given behaves like
      #  ario.nocloseoneof.each(&block)
      # 
      # Returns the Rio
      # 
      #  ario = rio('afile')
      #  lines = ario.to_a
      #  ario.closed?     #=> true
      #
      #  ario = rio('afile').nocloseoneof
      #  lines = ario.to_a
      #  ario.closed?     #=> false
      #  ario.close       # must be explicitly closed
      def nocloseoneof(arg=false,&block) target.nocloseoneof(arg,&block); self end


      # Query a Rio's closeoneof mode
      #  ario.closeoneof?    => true or false
      #
      # See #closeoneof and #nocloseoneof
      # 
      #  ario = rio('afile')
      #  ario.closeoneof?  #=> true
      #  lines = ario.to_a
      #  ario.closed?     #=> true
      #
      #  ario = rio('afile').nocloseoneof
      #  ario.closeoneof?  #=> false
      #  lines = ario.to_a
      #  ario.closed?     #=> false
      #  ario.close       # must be explicitly closed
      def closeoneof?() target.closeoneof?() end



      # Set a Rio's closeoncopy mode
      #
      #  ario.closeoncopy(&block) => ario
      #
      # #closeoncopy causes the Rio being written to to be closed when using 
      # a grande copy operator. While #closeoneof causes all Rio's to be closed
      # when reading to the end of file, it does not affect Rios being written to.
      # #closeoncopy only affects the Rio being written to and only when a 
      # grande copy operator is used. +closeoncopy+ is on by default, with one exception. 
      # 
      #  dest = rio('destfile')
      #  dest < rio('srcfile')
      #  dest.closed?   #=> true
      #
      #  dest = rio('destfile').nocloseoncopy
      #  dest < rio('srcfile')
      #  dest.closed?   #=> false
      #  dest.close     # must be explicitly closed
      # 
      #  dest = rio('destfile')
      #  dest.print(rio('srcfile').contents)
      #  dest.closed?   #=> false (IF::RubyIO#print is not a copy operator)
      #  dest.close
      #
      #
      # ==== The Exception
      #
      # When a block is passed directly to the rio constructor +closeoncopy+ is turned off.
      #
      #  rio('afile') { |file|
      #    file.closeoncopy? #=> false
      #    file < a_string
      #    file.closed?  #=> false
      #  }
      #  # The file is now closed. See IF::GrandeStream#rio for more informatioin
      # 
      # ==== Why?
      #
      # Some of my favorite Rio idioms are its copy one-liners
      #
      #  rio('afile') < a_string # put a string into a file
      #  rio('afile') < an_array # put an array into a file
      #  rio('afile') < rio('anotherfile').lines(0..9) # copy the first 10 lines of anotherfile into afile
      #  rio('afile.gz').gzip < rio('anotherfile').lines(0..9) # same thing into a gzipped file
      #
      # In each of these cases, 'afile' would remain open after the copy and furthermore
      # since the destination Rio was not saved in a variable, There is no way to close file.
      # Without closeoncopy Something like this would be required:
      #
      #  ario = rio('afile')
      #  ario < something_else
      #  ario.close
      #
      # Or this...
      #
      #  ario = rio('afile') < something_else
      #  ario.close
      #
      # Or this...
      #
      #  (rio('afile') < something_else).close
      # One line, but ugly, and prone to error.
      #
      # What I want is this:
      #
      #  rio('afile') < something_else
      #
      # Simple. I want to copy this to that, I point the arrow and it works.
      #
      # In perl the rio's destructor would be called, because there are no remaining references to the Rio
      # However, it my understanding and experience that in Ruby the finalizer will not necessarily be 
      # called at this point. 
      #
      def closeoncopy(arg=true,&block) target.closeoncopy(arg,&block); self end


      # Set a Rio's closeoncopy mode to false
      #
      #     ario.nocloseoncopy(&block) => ario
      #
      # See #closeoncopy
      #
      def nocloseoncopy(arg=false,&block) target.nocloseoncopy(arg,&block); self end


      # Query a Rio's closeoncopy mode
      #
      #     ario.closeoncopy? => true or false
      #
      # See #closeoncopy
      #
      def closeoncopy?() target.closeoncopy?() end


      # Turns off both closeoneof and closeoncopy.
      # Equivelent to:
      #  ario.nocloseoneof.nocloseoncopy
      # Returns the Rio
      #  ario.noautoclose(&block) => ario
      # If a block is given, acts as if 
      #  ario.noautoclose.each(&block) 
      # had been called.
      #
      # See #nocloseoneof and #nocloseoncopy
      #
      def noautoclose(arg=false,&block) target.noautoclose(arg,&block); self end


      # Queries the Rio's chomp-mode.
      # See #chomp.
      #
      def chomp?() target.chomp?() end


      # Sets the Rio to chomp lines and returns the Rio
      # 
      # When called with a block, behaves as if <tt>chomp.each(&block)</tt> had been called
      #
      # chomp causes lines returned by each, to_a, readlines, readline, gets, each_line etc.
      # to be chomped before iterated over or assigned
      #
      #  rio('f.txt').chomp.each { |line| ... } # Block is called with lines already chomped
      #
      #  rio('f.txt').chomp { |line| ... } # same as above
      #
      #  rio('f.txt').chomp.to_a # returns the lines of f.txt chomped
      # 
      #  rio('f.txt').chomp.lines(1..2).to_a # returns an array containg lines 1 and 2 of the file after being chomped
      #
      #    This would have similar results to rio('f.txt').lines(1..2).to_a.map{ |line| line.chomp}
      #
      #  rio('f.txt').lines(1..2).chomp.to_a # same as above
      #
      #  rio('f.txt').chomp.readlines # returns the lines of f.txt chomped
      #
      #  rio('f.txt').chomp.gets # returns the first line of 'f.txt' chomped
      #
      #  rio('f.txt').chomp > an_array # copies the chomped lines of f.txt into an_array
      #
      #  # fill an array with all the 'require' lines in all the .rb files (recursively) in adir
      #  # chomping each line
      #
      #  an_array = []
      #  rio('adir').chomp.all.files("*.rb") { |file| 
      #    an_array += file.lines[/^\s*require/]
      #  }
      #
      #  or simply
      #
      #  an_array = rio('adir').chomp.all.files("*.rb").lines[/^\s*require/]
      #
      def chomp(arg=true,&block) target.chomp(arg,&block); self end


      # Queries the Rio's strip-mode.
      # See #strip.
      #
      def strip?() target.strip?() end


      # Sets the Rio to strip lines and returns the Rio
      # 
      # When called with a block, behaves as if strip.each(&block) had been called
      #
      # +strip+ causes lines returned by each, to_a, readlines, readline, gets, each_line etc.
      # to be stripped with String#strip before iterated over or assigned
      #
      #  ans = rio(?-).print("A Prompt> ").strip.gets # prompt the user
      #
      # See also #chomp
      def strip(arg=true,&block) target.strip(arg,&block); self end


      # Sets the Rio to gzip mode. 
      #     ario.gzip    #=> ario
      # If applied to a Rio that is being read from Reads
      # through a <tt>Zlib::GzipReader</tt>; If applied to a Rio that is being written to 
      # writes through a <tt>Zlib::GzipWriter</tt>.
      #
      # Returns the Rio
      #
      # If a block is given, acts like <tt>ario.gzip.each(&block)</tt>
      #
      #  rio('afile') > rio('afile.gz').gzip # gzip a file
      #  rio('afile.gz').gzip < rio('afile') # same thing
      #
      #  rio('afile.gz').gzip > rio('afile') # ungzip a file
      #  rio('afile') < rio('afile.gz').gzip # same thing
      #
      #  rio('afile.gz').gzip.chomp { |line| ...} # process each chomped line of a gzipped file
      #  rio('afile.gz').gzip[0..9] # an array containing the first 10 lines of a gzipped file
      #
      def gzip(&block) target.gzip(true,&block); self end


      # Queries the Rio's gzip-mode
      #  ario.gzip?     #=> true or false
      # See #gzip
      #
      def gzip?() target.gzip?() end


      # #inputmode?
      #
      #
      #def inputmode?() target.inputmode?() end



      # This causes String#split(arg) to be called on every line
      # before it is returned. An array of the split lines is
      # returned when iterating
      #
      #  rio('/etc/passwd').split(':').columns(0,2) { |ary|
      #    username,uid = ary
      #  }
      #  
      #  rio('/etc/passwd').split(':').columns(0,2).to_a #=> [[user1,uid1],[user2,uid2]]
      #
      # See also IF::Grande#split
      #  
      def splitlines(*args,&block) target.splitlines(*args,&block) end



      # #outputmode?
      #
      #
      #def outputmode?() target.outputmode?() end


    end
  end
end
module RIO
  class Rio
    include RIO::IF::GrandeStream
  end
end
