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
    module RubyIO
      # Calls IO#gets
      #
      # Reads the next line from the Rio; lines are separated by sep_string. 
      # A separator of nil reads the entire contents, and a zero-length separator reads 
      # the input a paragraph at a time (two successive newlines in the input separate paragraphs). 
      #
      # Returns nil if called at end of file.
      # 
      #  astring  = rio('afile.txt').gets # read the first line of afile.txt into astring
      #
      def gets(sep_string=$/) target.gets(sep_string) end

      # IF::Grande#each_record
      # 
      #
      #def each_record(&block) target.each_record(&block); self end


      # IF::Grande#each_row
      #
      #
      #def each_row(&block) target.each_row(&block); self end


      # Calls IO#lineno
      #
      # Returns the current line number of a Rio.
      #
      # The Rio will be opened for reading if not already.
      # lineno counts the number of times gets is called, rather than the number of newlines encountered --
      # so lineno will only be accurate if the file is read exclusively with line-oriented methods 
      # (IF::RubyIO#readline, IF::GrandeStream#each_line, IF::RubyIO#gets etc.)
      # 
      # See also the $. variable and IF::RubyIO#recno
      #  f = rio("testfile")
      #  f.lineno   #=> 0
      #  f.gets     #=> "This is line one\n"
      #  f.lineno   #=> 1
      #  f.gets     #=> "This is line two\n"
      #  f.lineno   #=> 2
      def lineno() target.lineno() end

      # Calls IO#lineno=
      #  ario.lineno = integer    => integer
      # Manually sets the current line number to the given value. <tt>$.</tt> is
      # updated only on the next read.
      #
      # f = rio("testfile")
      # f.gets                     #=> "This is line one\n"
      # $.                         #=> 1
      # f.lineno = 1000
      # f.lineno                   #=> 1000
      # $. # lineno of last read   #=> 1
      # f.gets                     #=> "This is line two\n"
      # $. # lineno of last read   #=> 1001
      #
      #
      def lineno=(integer) target.lineno = integer end

      # Returns the current record number of a Rio. The +recno+ is the index 
      # used by the grande selection methods. It represents the zero-based index of the
      # last record read. Returns nil until a record has been read.
      # 
      # see IF::GrandeStream#lines IF::GrandeStream#bytes and IF::GrandeStream#records
      #
      # To illustrate: Given a file containing three lines "L0\n","L1\n","L2\n"
      # and a Range (0..1)
      # Each of the following would fill anarray with ["L0\n", "L1\n"]
      #
      # Given:
      #  anarray = []
      #  range = (0..1)
      #
      #  all_lines = rio('afile').readlines
      #  all_lines.each_with_index do |line,i|
      #    anarray << line if range === i
      #  end
      #  # anarray == ["L0\n", "L1\n"]
      #
      #  anarray = rio('afile').lines[0..1] # anarray == ["L0\n", "L1\n"]
      #
      # +recno+ counts the number of times IF::GrandeStream#getrec or IF::Grande#each is used to get a record. 
      # so +recno+ will only concern parts of the file read with grande methods 
      # IF::Grande#each, IF::Grande#[], IF::GrandeStream#getrec 
      # 
      # See also IF::RubyIO#lineno
      def recno() target.recno() end


      # Calls IO#binmode
      #
      # Puts rio into binary mode. This is useful only in MS-DOS/Windows environments. 
      # Once a stream is in binary mode, it cannot be reset to nonbinary mode.    
      # 
      # Returns the Rio.
      #
      #  rio('afile.exe').binmode.bytes(512).to_a # read a file in 512 byte blocks
      #
      def binmode() target.binmode(); self end


      # Calls IO#flush
      #  ario.flush    => ario
      # Flushes any buffered data within _ario_ to the underlying operating
      # system (note that this is Ruby internal buffering only; the OS may
      # buffer the data as well).
      #
      def flush() target.flush(); self end


      # Calls IO#each_byte
      #  ario.each_byte {|byte| block }  => ario
      # Calls the given block once for each byte (0..255) in _ario_, passing
      # the byte as an argument.
      #
      def each_byte(*args,&block) target.each_byte(*args,&block); self end


      # IF::RubyIO#each_bytes
      #
      #
      #def each_bytes(nb,*args,&block) target.each_bytes(nb,*args,&block); self end


      # Calls IO#each_line
      #  ario.each_line(sep_string=$/) {|line| block }  => ario
      # Executes the block for every line in _ario_, where lines are
      # separated by _sep_string_.
      #
      def each_line(*args,&block) target.each_line(*args,&block); self end


      # Calls IO#readlines
      #
      # Reads all of the lines in a Rio, and returns them in anArray. 
      # Lines are separated by the optional aSepString. 
      # The stream must be opened for reading or an IOerror will be raised.
      #
      #  an_array = rio('afile.txt').readlines # read afile.txt into an array
      #  an_array = rio('afile.txt').chomp.readlines # read afile.txt into an array with each line chomped
      #
      def readlines(*args,&block) target.readlines(*args,&block) end
      
      # Calls IO#readline
      #  ario.readline(sep_string=$/)   => string
      # Reads a line as with +IO#gets+, but raises an +EOFError+ on end of
      # file.
      #
      def readline(*args) target.readline(*args) end


      # Calls IO#readpartial
      #
      # Reads at most maxlen bytes from the I/O stream but it blocks
      # only if ios has no data immediately available. If the optional
      # outbuf argument is present, it must reference a String, which
      # will receive the data. It raises EOFError on end of file.
      #
      # readpartial is designed for streams such as pipe, socket, tty, etc. It
      # blocks only when no data immediately available. This means that it
      # blocks only when following all conditions hold.
      #
      # * the buffer in the IO object is empty.
      # * the content of the stream is empty.
      # * the stream is not reached to EOF.
      #
      # When readpartial blocks, it waits data or EOF on the stream. If some
      # data is reached, readpartial returns with the data. If EOF is reached,
      # readpartial raises EOFError.
      #
      # When readpartial doesn’t blocks, it returns or raises immediately. If
      # the buffer is not empty, it returns the data in the buffer. Otherwise
      # if the stream has some content, it returns the data in the
      # stream. Otherwise if the stream is reached to EOF, it raises EOFError.
      #
      #    r, w = IO.pipe           #               buffer          pipe content
      #    w << "abc"               #               ""              "abc".
      #    r.readpartial(4096)      #=> "abc"       ""              ""
      #    r.readpartial(4096)      # blocks because buffer and pipe is empty.
      #
      #    r, w = IO.pipe           #               buffer          pipe content
      #    w << "abc"               #               ""              "abc"
      #    w.close                  #               ""              "abc" EOF
      #    r.readpartial(4096)      #=> "abc"       ""              EOF
      #    r.readpartial(4096)      # raises EOFError
      #
      #    r, w = IO.pipe           #               buffer          pipe content
      #    w << "abc\ndef\n"        #               ""              "abc\ndef\n"
      #    r.gets                   #=> "abc\n"     "def\n"         ""
      #    w << "ghi\n"             #               "def\n"         "ghi\n"
      #    r.readpartial(4096)      #=> "def\n"     ""              "ghi\n"
      #    r.readpartial(4096)      #=> "ghi\n"     ""              ""
      #
      # Note that readpartial is nonblocking-flag insensitive. It blocks even
      # if the nonblocking-flag is set.
      #
      # Also note that readpartial behaves similar to sysread in blocking
      # mode. The behavior is identical when the buffer is empty.
      # ios.reopen(other_IO) => ios ios.reopen(path, mode_str) => ios
      #
      # Reassociates ios with the I/O stream given in other_IO or to a new
      # stream opened on path. This may dynamically change the actual class of
      # this stream.
      #
      #    f1 = File.new("testfile")
      #    f2 = File.new("testfile")
      #    f2.readlines[0]   #=> "This is line one\n"
      #    f2.reopen(f1)     #=> #<File:testfile>
      #    f2.readlines[0]   #=> "This is line one\n"
      #
      def readpartial(*args) target.readpartial(*args) end


      # Calls IO::print
      #
      # Writes the given object(s) to the Rio.  If the output record separator ($\) is not nil, 
      # it will be appended to the output. If no arguments are given, prints $_. 
      # Objects that aren't strings will be converted by calling their to_s method. 
      # Returns the Rio.
      #
      #  rio('f.txt').print("Hello Rio\n") # print the string to f.txt
      #  rio(?-).print("Hello Rio\n") # print the string to stdout
      # 
      def print(*args,&block) target.print(*args,&block); self end

      # Writes the given objects to the rio as with IF::RubyIO#print and then closes the Rio. 
      # Returns the Rio.
      #
      # Equivalent to rio.print(*args).close
      #
      #  rio('f.txt').print!("Hello Rio\n") # print the string to f.txt then close it
      #
      def print!(*args,&block) target.print!(*args,&block); self end


      # Writes the given objects to the rio as with IF::RubyIO#printf and then closes the rio. 
      # Returns the rio.
      #
      # Equivalent to rio.printf(*args).close
      #
      def printf!(*argv) target.printf!(*argv); self end


      # Calls IO#printf
      #  ario.printf(format_string [, obj, ...] )   => ario
      # Formats and writes to _ario_, converting parameters under control of
      # the format string. See +Kernel#sprintf+ for details.
      #
      def printf(*argv) target.printf(*argv); self end


      # Writes the given objects to the rio as with IF::RubyIO#putc and then closes the rio. 
      # Returns the rio.
      #
      # Equivalent to rio.putc(*args).close
      #
      def putc!(*argv) target.putc!(*argv); self end


      # Calls IO#putc
      #  ario.putc(obj)    => ario
      # If _obj_ is +Numeric+, write the character whose code is _obj_,
      # otherwise write the first character of the string representation of
      # _obj_ to _ario_.
      #
      #  stdout = rio(?-)
      #  stdout.putc "A"
      #  stdout.putc 65
      #
      # _produces:_
      #
      #  AA
      #
      def putc(*argv) target.putc(*argv); self end


      # Calls IO#puts
      #
      # Writes the given objects to the rio as with IF::RubyIO#print. 
      # Writes a record separator (typically a newline) after any that do not already end with a newline sequence. 
      # If called with an array argument, writes each element on a new line. 
      # If called without arguments, outputs a single record separator.
      # Returns the rio.
      def puts(*args) target.puts(*args); self end

      # Writes the given objects to the rio as with IF::RubyIO#puts and then closes the rio. 
      # Returns the rio.
      #
      # Equivalent to rio.puts(*args).close
      #
      #  rio('f.txt').puts!('Hello Rio') # print the string to f.txt then close it
      #
      def puts!(*args) target.puts!(*args); self end


      # Writes the given objects to the rio as with IF::RubyIO#write and then closes the rio. 
      #
      # Equivalent to
      #  ario.write(*args)
      #  ario.close
      #
      def write!(*argv) target.write!(*argv) end


      # Calls IO#write
      #  ario.write(string)    => integer
      # Writes the given string to _ario_. If the argument is not a string, 
      # it will be converted to a
      # string using +to_s+. Returns the number of bytes written.
      #
      def write(*argv) target.write(*argv) end


      # Calls IO#eof?
      #  ario.eof     => true or false
      # Returns true if _ario_ is at end of file. The stream must be opened
      # for reading or an +IOError+ will be raised.
      #
      def eof?() target.eof? end

      # Provides direct access to the IO handle (as would be returned by ::IO#new) *with* filtering. 
      # Reading from and writing to this handle will be affected
      # by such things as IF::GrandeStream#gzip and IF::GrandeStream#chomp if they were specified for the Rio. 
      # 
      # Compare this with IF::RubyIO#ios
      #
      def ioh(*args) target.ioh() end

      # Provides direct access to the IO handle (as would be returned by ::IO#new) 
      # Reading from and writing to this handle 
      # is *not* affected by such things as IF::GrandeStream#gzip and IF::GrandeStream#chomp.
      #
      # Compare this with IF::RubyIO#ioh
      #
      def ios(*args) target.ios() end

      #def open(m,*args) target.open(m,*args); self end

      # Explicitly set the mode with which a Rio will be opened.
      #   ario.mode('r+')   => ario
      # Normally one needs never open a Rio or specify its mode -- the mode is determined by the
      # operation the Rio is asked to perform. (i.e. IF::RubyIO#print requires write access, IF::RubyIO#readlines requires
      # read access). However there are times when one wishes to be specific about the mode with which a Rio
      # will be opened. Note that explicitly setting the mode overrides all of Rio's internal mode
      # logic. If a mode is specified via IF::RubyIO#mode or IF::FileOrDir#open that mode will be used. Period.
      #
      # Returns the Rio.
      #
      # See also IF::RubyIO#mode?
      # 
      # If the mode is given as a String, it must be one of the values listed in the following table.
      #
      #   Mode |  Meaning
      #   -----+--------------------------------------------------------
      #   "r"  |  Read-only, starts at beginning of file  (default mode).
      #   -----+--------------------------------------------------------
      #   "r+" |  Read-write, starts at beginning of file.
      #   -----+--------------------------------------------------------
      #   "w"  |  Write-only, truncates existing file
      #        |  to zero length or creates a new file for writing.
      #   -----+--------------------------------------------------------
      #   "w+" |  Read-write, truncates existing file to zero length
      #        |  or creates a new file for reading and writing.
      #   -----+--------------------------------------------------------
      #   "a"  |  Write-only, starts at end of file if file exists,
      #        |  otherwise creates a new file for writing.
      #   -----+--------------------------------------------------------
      #   "a+" |  Read-write, starts at end of file if file exists,
      #        |  otherwise creates a new file for reading and
      #        |  writing.
      #   -----+--------------------------------------------------------
      #    "b" |  (DOS/Windows only) Binary file mode (may appear with
      #        |  any of the key letters listed above).
      #
      #  ario = rio('afile').mode('r+').nocloseoneof # file will be opened in r+ mode
      #                                             # don't want the file closed at eof
      #  ario.seek(apos).gets # read the string at apos in afile
      #  ario.rewind.gets # read the string at the beginning of the file
      #  ario.close
      #
      # TODO:
      # * Add support for integer modes
      #
      def mode(m,*args) target.mode(m,*args); self end

      # Query a Rio's mode
      #    ario.mode?      #=> a mode string
      #
      # See IF::RubyIO#mode
      #
      #  ario = rio('afile')
      #  ario.puts("Hello World") 
      #  ario.mode?      #=> 'w' IF::RubyIO#puts requires write access
      #
      #  ario = rio('afile')
      #  ario.gets
      #  ario.mode?      #=> 'r' IF::RubyIO#gets requires read access
      #
      #  ario = rio('afile').mode('w+').nocloseoneof
      #  ario.gets
      #  ario.mode?      #=> 'w+' Set explictly
      #
      def mode?() target.mode?() end



      # Calls IO#close
      #      ario.close   => nil
      # Closes _ario_ and flushes any pending writes to the operating
      # system. The stream is unavailable for any further data operations;
      # an +IOError+ is raised if such an attempt is made. I/O streams are
      # automatically closed when they are claimed by the garbage
      # collector.
      #
      def close() target.close(); self end
      def close_write() target.close_write(); self end

      # Calls IO#fcntl
      #      ario.fcntl(integer_cmd, arg)    => integer
      # Provides a mechanism for issuing low-level commands to control or
      # query file-oriented I/O streams. Arguments and results are platform
      # dependent. If _arg_ is a number, its value is passed directly. If
      # it is a string, it is interpreted as a binary sequence of bytes
      # (<tt>Array#pack</tt> might be a useful way to build this string). On Unix
      # platforms, see <tt>fcntl(2)</tt> for details. Not implemented on all
      # platforms.
      #
      #
      def fcntl(integer_cmd,arg) target.fcntl(integer_cmd,arg) end

      # Calls IO#ioctl
      #      ario.ioctl(integer_cmd, arg)    => integer
      # Provides a mechanism for issuing low-level commands to control or
      # query I/O devices. Arguments and results are platform dependent. If
      # _arg_ is a number, its value is passed directly. If it is a string,
      # it is interpreted as a binary sequence of bytes. On Unix platforms,
      # see +ioctl(2)+ for details. Not implemented on all platforms.
      #
      #
      def ioctl(integer_cmd,arg) target.ioctl(integer_cmd,arg) end

      # Calls IO#fileno
      #      ario.fileno    => fixnum
      #      ario.to_i      => fixnum
      # Returns an integer representing the numeric file descriptor for
      # _ario_.
      #
      def fileno() target.fileno() end


      # Calls IO#fsync
      #      ario.fsync   => ario
      # Immediately writes all buffered data in _ario_ to disk and
      # return _ario_. 
      # Does nothing if the underlying operating system does not support
      # _fsync(2)_. Note that +fsync+ differs from using IF::RubyIO#sync. The
      # latter ensures that data is flushed from Ruby's buffers, but
      # doesn't not guarantee that the underlying operating system actually
      # writes it to disk.
      #
      def fsync() target.fsync end

      # Calls IO#pid
      #  ario.pid    => fixnum
      # Returns the process ID of a child process associated with _ario_.
      # This will be set by <tt>IO::popen</tt>.
      #
      #  pipe = IO.popen("-")
      #  if pipe
      #    $stderr.puts "In parent, child pid is #{pipe.pid}"
      #  else
      #    $stderr.puts "In child, pid is #{$$}"
      #  end
      #
      # produces:
      #
      #  In child, pid is 26209
      #  In parent, child pid is 26209
      #
      #
      def pid() target.pid end


      # Calls IO#putc
      #      ario.putc(obj)    => obj
      # If _obj_ is +Numeric+, write the character whose code is _obj_,
      # otherwise write the first character of the string representation of
      # _obj_ to _ario_.
      #
      # $stdout.putc "A"
      # $stdout.putc 65
      #
      # _produces:_
      #
      # AA
      #
      #


      # Calls IO#getc
      #      ario.getc   => fixnum or nil
      # Gets the next 8-bit byte (0..255) from _ario_. Returns +nil+ if
      # called at end of file.
      #
      # f = File.new("testfile")
      # f.getc   #=> 84
      # f.getc   #=> 104
      #
      #
      def getc() target.getc() end

      # Calls IO#readchar
      #      ario.readchar   => fixnum
      # Reads a character as with +IO#getc+, but raises an +EOFError+ on
      # end of file.
      #
      #

      # Calls IO#reopen
      #      ario.reopen(other_IO)         => ios 
      #      ario.reopen(path, mode_str)   => ios
      # Reassociates _ario_ with the I/O stream given in _other_IO_ or to a
      # new stream opened on _path_. This may dynamically change the actual
      # class of this stream.
      #
      # f1 = File.new("testfile")
      # f2 = File.new("testfile")
      # f2.readlines[0]   #=> "This is line one\n"
      # f2.reopen(f1)     #=> #<File:testfile>
      # f2.readlines[0]   #=> "This is line one\n"
      #
      #
      #def reopen(m) target.reopen(m) end


      # Calls IO#stat
      #      ario.stat    => stat
      # Returns status information for _ario_ as an object of type
      # +File::Stat+.
      #
      # f = File.new("testfile")
      # s = f.stat
      # "%o" % s.mode   #=> "100644"
      # s.blksize       #=> 4096
      # s.atime         #=> Wed Apr 09 08:53:54 CDT 2003
      #
      #

      # Calls IO#to_i
      #   to_i()
      # Alias for #fileno
      #
      #
      def to_i() target.to_i() end

      # Calls IO#to_io
      #  ario.to_io -> ios
      # Returns _ario_.
      #
      #
      def to_io() target.to_io() end

      # Calls IO#tty?
      #  ario.tty?     => true or false
      # Returns +true+ if _ario_ is associated with a terminal device (tty),
      # +false+ otherwise.
      #
      #  rio("testfile").tty?   #=> false
      #  rio("/dev/tty").tty?   #=> true
      #
      #
      def tty?() target.tty?() end

      # Calls IO#ungetc
      #  ario.ungetc(integer)   => ario
      # Pushes back one character (passed as a parameter) onto _ario_, such
      # that a subsequent buffered read will return it. Only one character
      # may be pushed back before a subsequent read operation (that is, you
      # will be able to read only the last of several characters that have
      # been pushed back).
      #
      #  f = rio("testfile")        #=> #<Rio:testfile>
      #  c = f.getc                 #=> 84
      #  f.ungetc(c).getc           #=> 84
      #
      def ungetc(*args) target.ungetc(*args); self end
      
      # Sets the 'sync-mode' of the underlying IO using IO#sync=
      #      ario.sync(boolean=true,&block)   => ario
      # Sets the Rio so that its 'sync mode' will be set to +true+ or +false+ when opened, or set
      # it immediately if already open. When sync mode is
      # true, all output is immediately flushed to the underlying operating
      # system and is not buffered internally. Returns the rio. See
      # also IF::RubyIO#fsync, IF::RubyIO#nosync, IF::RubyIO#sync?.
      #
      # If a block is given behaves like <tt>ario.sync(arg).each(&block)</tt>
      #
      #  f = rio("testfile").sync.puts("Hello World")
      #  f.sync?     # => true
      #
      def sync(arg=true,&block) target.sync(arg,&block); self end

      # Similar to IO#sync= false
      #      ario.nosync(&block)   => ario
      # Sets the Rio so that its 'sync mode' will be set to +false+ when opened, or set
      # it immediately if already open. When sync mode is
      # true, all output is immediately flushed to the underlying operating
      # system and is not buffered internally. Returns the rio. See
      # also IF::RubyIO#fsync, IF::RubyIO#sync, IF::RubyIO#sync?.
      #
      # If a block is given behaves like <tt>ario.nosync.each(&block)</tt>
      #
      #  f = rio("testfile").sync.puts("Hello World")
      #  f.sync?     # => true
      #  f.nosync
      #  f.sync?     # => false
      #
      def nosync(arg=false,&block) target.nosync(arg,&block); self end

      # Query the current "sync mode" with IO#sync
      #      ario.sync?    => true or false
      # Returns the current "sync mode" of _ario_. When sync mode is true,
      # all output is immediately flushed to the underlying operating
      # system and is not buffered by Ruby internally. See also IF::RubyIO#fsync,
      # IF::RubyIO#sync, IF::RubyIO#nosync
      #
      #  f = rio("testfile")
      #  f.sync?   #=> false
      #
      def sync?() target.sync?() end



    end
  end
end

module RIO
  class Rio
    include RIO::IF::RubyIO
  end
end
