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

#

require 'rio'

module RIO
  # Rio Constructor 
  #
  # For purposes of discussion, we divide Rios into two catagories, those that have a path
  # and those that don't.
  #
  # ==== Creating a Rio that has a path
  #
  # To create a Rio that has a path the arguments to +rio+ may be:
  #
  # * a string representing the entire path. The separator used for Rios is as specified in RFC1738 ('/').
  #    rio('adir/afile')
  # * a string representing a fully qualified +file+ URL as per RFC1738
  #    rio('file:///atopleveldir/adir/afile')
  # * a +URI+ object representing a +file+ or generic +URL+
  #    rio(URI('adir/afile'))
  # * the components of a path as separate arguments
  #    rio('adir','afile')
  # * the components of a path as an array of separate arguments
  #    rio(%w/adir afile/)
  # * another Rio
  #    another_rio = rio('adir/afile')
  #    rio(another_rio)
  # * any object whose +to_s+ method returns one of the above
  #    rio(Pathname.new('apath'))
  # * any combination of the above either as separate arguments or as elements of an array,
  #    another_rio = rio('dir1/dir2')
  #    auri = URI('dir4/dir5)
  #    rio(another_rio,'dir3',auri,'dir6/dir7')
  #
  # ===== Creating a Rio that refers to a web page
  #
  # To create a Rio that refers to a web page the arguments to +rio+ may be:
  #
  # * a string representing a fully qualified +http+ URL
  #    rio('http://ruby-doc.org/index.html')
  # * a +URI+ object representing a +http+ +URL+
  #    rio(URI('http://ruby-doc.org/index.html'))
  # * either of the above with additional path elements
  #    rio('http://www.ruby-doc.org/','core','classes/Object.html')
  #
  # ===== Creating a Rio that refers to a file or directory on a FTP server
  #
  # To create a Rio that refers to a file on a FTP server the arguments to +rio+ may be:
  #
  # * a string representing a fully qualified +ftp+ URL
  #    rio('ftp://user:password@ftp.example.com/afile.tar.gz')
  # * a +URI+ object representing a +ftp+ +URL+
  #    rio(URI('ftp://ftp.example.com/afile.tar.gz'))
  # * either of the above with additional path elements
  #    rio('ftp://ftp.gnu.org/pub/gnu','emacs','windows','README')
  #
  # ==== Creating Rios that do not have a path
  #
  # To create a Rio without a path, the first argument to +rio+ is usually 
  # either a single character or a symbol.
  #
  # ===== Creating a Rio that refers to a clone of your programs stdin or stdout.
  # 
  # <tt>rio(?-)</tt> (mnemonic: '-' is used by some Unix programs to specify stdin or stdout in place of a file)
  #
  # <tt>rio(:stdio)</tt>
  # 
  # Just as a Rio that refers to a file, does not know whether that file will be opened for reading or
  # writing until an I/O operation is specified, a <tt>stdio:</tt> Rio does not know whether it will connect
  # to stdin or stdout until an I/O operation is specified. 
  #
  # Currently :stdin and :stdout are allowed as synonyms for :stdio. This allows one to write
  #  rio(:stdout).puts("Hello :stdout")
  # which is reasonable. It also allows one to write 
  #  rio(:stdin).puts("Hello :stdin")
  # which is not reasonable and will be disallowed in future releases.
  #
  # ===== Creating a Rio that refers to a clone of your programs stderr.
  #
  # <tt>rio(?=)</tt> (mnemonic: '-' refers to fileno 1, so '=' refers to fileno 2)
  #
  # <tt>rio(:stderr)</tt>
  #
  # ===== Creating a Rio that refers to an arbitrary IO object.
  #
  #  an_io = ::File.new('afile')
  #  rio(an_io)
  #
  # ===== Creating a Rio that refers to a file descriptor
  #
  # <tt>rio(?#,file_descriptor)</tt> (mnemonic: a file descriptor is a number '#')
  #
  # <tt>rio(:fd,file_descriptor)</tt>
  #
  #  an_io = ::File.new('afile')
  #  fnum = an_io.fileno
  #  rio(?#,fnum)
  #
  # ===== Creating a Rio that refers to a StringIO object
  #
  # <tt>rio(?")</tt> (mnemonic: '"' surrounds strings)
  #
  # <tt>rio(:string)</tt>
  #
  # <tt>rio(:strio)</tt>
  #
  # <tt>rio(:stringio)</tt>
  #
  #
  # * create a Rio that refers to a string that it creates
  #    rio(?")
  # * create a Rio that refers to a string of your choosing
  #    astring = ""
  #    rio(?",astring)
  #
  # ===== Creating a Rio that refers to a temporary object
  #
  # To create a temporary object that will become a file (Tempfile)
  # or a temporary directory, depending on how it is used.
  #
  # <tt>rio(??)</tt> (mnemonic: '?' you don't know its name)
  #
  # <tt>rio(:temp)</tt>
  #
  # The following are also supported, to specify file or directory
  #
  # <tt>rio(:tempfile)</tt>
  #
  # <tt>rio(:tempdir)</tt>
  # 
  #  rio(??)
  #  rio(??,basename='rio',tmpdir=Dir::tmpdir)
  #
  # To create a temporary object that will become a file
  # or a directory, depending on how you use it:
  #  rio(??)
  #  rio(??,basename='rio',tmpdir=Dir::tmpdir)
  #
  # To force it to become a file
  #  rio(??).file
  # or just write to it.
  #
  # To force it to become a directory:
  #  rio(??).mkdir
  # or
  #  rio(??).chdir
  #
  #
  # ===== Creating a Rio that refers to an arbitrary TCPSocket
  #
  # <tt>rio('tcp:',hostname,port)</tt>
  #
  # <tt>rio('tcp://hostname:port')</tt>
  #
  # <tt>rio(:tcp,hostname,port)</tt>
  #
  # ===== Creating a Rio that runs an external program and connects to its stdin and stdout
  #
  # <tt>rio(?-,cmd)</tt> (mnemonic: '-' is used by some Unix programs to specify stdin or stdout in place of a file)
  #
  # <tt>rio(?`,cmd)</tt> (mnemonic: '`' (backtick) runs an external program in ruby)
  #
  # <tt>rio(:cmdio,cmd)</tt>
  #
  # This is Rio's interface to IO#popen
  #
  # ===== Creating a Rio that acts like /dev/null
  #
  # <tt>rio(nil)</tt>
  #
  # <tt>rio(:null)</tt>
  #
  # This rio behaves like the Unix file /dev/null, but does depend on it -
  # and thus will work on non-Unix systems. Reading behaves as if reading from
  # an empty file, and writing to it discards anything written.
  #
  # ===== Creating a Rio Pipe
  #
  # A Rio Pipe is a sequence of Rios that are run with the output of each being
  # copied to the input of the next.
  #
  # <tt>rio(?|, ario, ...)</tt> (mnemonic: '|' is the Unix pipe operator)
  #
  # <tt>rio(:cmdpipe, ario, ...)</tt>
  #
  #
  # See also IF::Grande#|
  #
  #
  def rio(*args,&block)  # :yields: self
    Rio.rio(*args,&block) 
  end
  module_function :rio

  # Create a Rio as with RIO#rio which refers to the current working directory 
  #   wd = RIO.cwd
  # If passed arguments they are treated as if
  #   rio(RIO.cwd,*args)
  # had been called
  def cwd(*args,&block)  # :yields: self
    Rio.new.getwd(*args,&block) 
  end
  module_function :cwd

  # Create a Rio as with RIO#rio which refers to a directory at the root of the file system
  #  tmpdir = RIO.root('tmp') #=> rio('/tmp')
  def root(*args,&block) # :yields: self
    Rio.new.rootpath(*args,&block) 
  end
  module_function :root

end

if $0 == __FILE__
  eval DATA.read, nil, $0, __LINE__+4
end

__END__

puts
puts("Run the tests that came with the distribution")
puts("From the distribution directory use 'test/runtests.rb'")
puts
