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
module Doc #:doc:
=begin rdoc

= Rio - Ruby I/O Facilitator

Rio is a facade for most of the standard ruby classes that deal with I/O;
providing a simple, intuitive, succinct interface to the functionality
provided by IO, File, Dir, Pathname, FileUtils, Tempfile, StringIO, OpenURI
and others. Rio also provides an application level interface which allows many
common I/O idioms to be expressed succinctly.

== HOWTO...

=== Read a single file
   ario = rio('afile')
   string = ""
   array = []

* Read a file into a string.
   # method 1
   string = ario.contents
   # method 2
   ario > string

* Append a file onto a string.
   # method 1
   ario >> string
   # method 2
   string += ario.contents

* Read lines of a file into an array
   # method 1
   array = ario[]
   # method 2
   ario > array
   # method 3
   array = ario.to_a
   # method 4 
   array = ario.readlines

* Append lines of a file into an array
   # method 1
   ario >> array
   # method 2
   array += ario.lines[]

* Read the first 10 lines of a file into an array
   # method 1
   array = ario[0...10]
   # method 2
   array = ario.lines[0...10]
   # method 3
   ario.lines(0...10) > array

* Read lines of a file into an array, with each line chomped
   # method 1
   array = ario.chomp[]
   # method 2
   array = ario.chomp.lines[]
   # method 3
   ario.chomp > array

* Append the first 10 lines of a file into an array, with each line chomped
   # method 1
   array += ario.chomp[0...10]
   # method 2
   array += ario.chomp.lines[0...10]
   # method 3
   ario.chomp.lines(0...10) >> array

* Read all lines starting with 'require' into an array, with each line chomped
   # method 1
   array = ario.chomp[/^\s*require/]
   # method 2
   array = ario.chomp.lines[/^\s*require/]
   # method 3
   ario.chomp.lines(/^\s*require/) > array

* Read a gzipped file into a string
   # method 1
   rio('afile.gz').gzip > string
   # method 2
   string = rio('afile.gz').gzip.contents

* Append a gzipped file into a string
   # method 1
   rio('afile.gz').gzip >> string
   # method 2
   string += rio('afile.gz').gzip.contents

* Iterate through all the lines of a file
   # method 1
   rio('afile').lines { |line| ... }
   # method 2
   rio('afile').each { |line| ... }
   # method 3
   rio('afile').each_line { |line| ... }


* Iterate through the lines of a gzipped file
   rio('afile.gz').gzip { |line| ... }

* Iterate through all non-empty lines of a gzipped file, with each line chomped
   rio('afile.gz').gzip.chomp.skiplines(:empty?) { |line| ... }

* Iterate through the first 100 lines of a file
   # method 1
   rio('afile').lines(0...100) { |line| ... }

* Iterate through the first line and all ruby comment lines in a gzipped file
   rio('afile.rb.gz').gzip.lines(0,/^\s*#/) { |line| ... }

* Iterate through the lines of a ruby file that are neither empty nor comments, with all lines chomped
   rio('afile.rb').chomp.skiplines(/^\s*#/,:empty?) { |line| ... }

* Read all the comment lines from a ruby file into an array with all lines chomped
   # method 1
   array = rio('afile.rb').chomp[/^\s*#/]
   # method 2
   array = rio('afile.rb').chomp.lines[/^\s*#/]
   # method 3
   rio('afile.rb').chomp.lines(/^\s*#/) > array
  

* Read lines of a file into an array, with each line chomped, skipping any lines longer than 1024 chars
   # method 1
   array = ario.chomp[proc{ |line| line.length <= 1024}]
   # method 2
   ario.chomp.lines(proc{ |line| line.length <= 1024}) > array
   # method 3
   array = ario.chomp.skiplines[proc{ |line| line.length > 1024}]
   # method 4
   array = ario.chomp.lines(proc{ |line| line.length <= 1024}).to_a

---

=== Write to a single file

   ario = rio('afile')
   string = "A String\n"
   array = ["Line 0\n","Line 1\n"]

* Write a string to a file, leaving the Rio open
   # method 1
   ario.puts(string)
   # method 2
   ario.print(string)
   # method 3
   ario.noautoclose < string

* Write a string to a file and close the file
   # method 1
   rio('afile') < string
   # method 2
   ario.print!(string)
   # method 3
   ario.print(string).close

* Append a string to a file, leaving the Rio open
   # method 1
   ario.a.puts(string)
   # method 2
   ario.a.print(string)
   # method 3
   ario.noautoclose << string

* Append a string to a file and close the file
   # method 1
   rio('afile') << string
   # method 2
   rio('afile').a.print!(string)
   # method 3
   rio('afile').a.print(string).close

* Write an array to a file, leaving the Rio open
   # method 1
   ario = rio('afile').nocloseoncopy
   ario << array
   # method 2
   ario.noautoclose < array

* Write an array to a file and close the file
   # method 1
   rio('afile') < array


---

=== Select records
   ario = rio('afile')
   string = ""
   array = []

* Put lines one thru ten and line 100 into an array
   # method 1
   array = ario[0..9,99]
   # method 2
   array = ario.lines[0..9,99]
   # method 3
   ario.lines(0..9,99) > array
  
* Put lines one thru ten,line 100 and lines starting with 'rio4ruby' into an array
   # method 1
   array = ario[0..9,99,/^rio4ruby/]
   # method 2
   array = ario.lines[0..9,99,/^rio4ruby/]
   # method 3
   ario.lines(0..9,99,/^rio4ruby/) > array
  
* Put lines that are longer than 128 bytes into an array
   # method 1
   array = ario[proc{ |l| l.length > 128}]
   # method 2
   array = ario.lines[proc{ |l| l.length > 128}]
   # method 3
   array = ario.skiplines[proc{ |l| l.length <= 128}]
   # method 4
   array = ario.skip.lines[proc{ |l| l.length <= 128}]
  
* Copy all lines that do not start with 'rio4ruby' into another file
   # method 1
   ario.skiplines(/^rio4ruby/) > rio('another_file')
   # method 2
   ario.lines.skiplines(/^rio4ruby/) > rio('another_file')
   # method 3
   rio('another_file') < ario.skiplines(/^rio4ruby/)
  
* Copy the first 10 lines and lines starting with 'rio4ruby', but exclude any lines longer than 128 bytes
   # method 1
   ario.lines(0...10,/^rio4ruby/).skiplines(proc{ |l| l.length > 128}] > rio('another_file')
   # method 2
   rio('another_file') < ario.lines(0...10,/^rio4ruby/).skiplines(proc{ |l| l.length > 128})
  


---

=== Select directory entries
   ario = rio('adir')
   string = ""
   array = []

* Put all entries with the extension '.txt' into an array
   # method 1
   array = ario['*.txt']
   # method 2
   array = ario[/\.txt$/]
   # method 3
   array = ario.entries['*.txt']
  
* Put all files with the extension '.txt' into an array
   # method 1
   array = ario.files['*.txt']
   # method 2
   array = ario.files[/\.txt$/]
   # method 3
   array = ario.files['*.txt']
  
* Put all entries with the extension '.txt' into an array, including those in subdirectories
   # method 1
   array = ario.all['*.txt']
   # method 2
   array = ario.all[/\.txt$/]
   # method 3
   array = ario.all.entries['*.txt']
  
* Put all entries with the extension '.txt' into an array, including those in subdirectories, except those
  in subdirectories name '.svn'
   # method 1
   array = ario.norecurse('.svn').all['*.txt']
   # method 2
   array = ario.norecurse(/^\.svn$/).all[/\.txt$/]
   # method 3
   array = ario.norecurse('.svn').entries['*.txt']
   # method 4
   array = ario.entries('*.txt').norecurse('.svn').to_a
   # method 5
   array = ario.norecurse('.svn')['*.txt']
  
* Put all directories into an array
   # method 1
   array = ario.dirs[]
   # method 2
   array = ario.dirs.to_a

* Put all directories (recursively) into an array
   # method 1
   array = ario.all.dirs[]
   # method 2
   array = ario.all.dirs.to_a

* Put all entries (recursively) into an array, but limit the depth of recursion to 2
   # method 1
   array = ario.norecurse(3).to_a


* Iterate through ruby files in a directory and subdirectories skipping 
  those in the '.svn', and 'pkg' directories
   # method 1
   is_ruby_exe = proc{ |f| f.executable? and f[0][0] =~ /^#!.+ruby/ }
   ario.norecurse('.svn','pkg').files('*.rb',is_ruby_exe) { |f| ... }
   # method 2
   is_ruby_exe = proc{ |f| f.executable? and f.gets =~ /^#!.+ruby/ }
   ario.norecurse('.svn','pkg').files('*.rb',is_ruby_exe) { |f| ... }

* Put all files excluding those that are symlinks to files in an array
   # method 1
   array = ario.skipfiles[:symlink?]
   # method 2
   array = ario.skipfiles(:symlink?).files[]
   # method 3
   array = ario.skipfiles(:symlink?).to_a
   # method 4
   array = ario.files.skipfiles[:symlink?]

* Put all entries that are not files (or symlinks to files) into an array
   # method 1
   array = ario.skipfiles[]
   # method 2
   array = ario.skipfiles.to_a

* Put all entries that are symlinks to files into an array
   # method 1
   array = ario.files[proc{|f| f.file? and f.symlink?}]
   # method 2
   array = ario.files(proc{|f| f.file? and f.symlink?}).to_a

* Put all directories except those named '.svn' into an array
   # method 1
   array = ario.skipdirs['.svn']
   # method 2
   array = ario.skipdirs[/^\.svn$/]
   # method 3
   array = ario.skipdirs('.svn').to_a
   # method 4
   array = ario.skipdirs('.svn').dirs[]
   # method 5
   array = ario.skipdirs('.svn')[]


---

=== Read and writing files
   ario = rio('afile')
   string = ""
   array = []

* Copy the contents of one file into another file
   # method 1
   rio('srcfile') > rio('dstfile')
   # method 2
   rio('dstfile') < rio('srcfile')
   # method 3
   rip('dstfile').print!(rio('srcfile').contents)

* Append the contents of one file to another file
   # method 1
   rio('srcfile') >> rio('dstfile')
   # method 2
   rio('dstfile') << rio('srcfile')
   # method 3
   rip('dstfile').a.print!(rio('srcfile').contents)

* Copy the first 10 lines of one file to another file
   # method 1
   rio('srcfile').lines(0...10) > rio('dstfile')
   # method 2
   rio('dstfile') < rio('srcfile').lines(0...10)
   # method 3
   rio('dstfile') < rio('srcfile').lines[0...10]

* Concatenate several files into one
   # method 1
   rio('dstfile') < [ rio('src1'), rio('src2'), rio('src3') ]
   # method 2
   rio('dstfile') < rio('src1') << rio('src2') << rio('src3')

* Copy a web page into a file
   # method 1
   rio('http://ruby-doc.org/') > rio('afile')
   # method 2
   rio('afile') < rio('http://ruby-doc.org/')
   # method 3
   rio('afile').print!(rio('http://ruby-doc.org/').contents)

* Append the output of the daytime server running on the localhost to a file
   # method 1
   rio("tcp://localhost:daytime") >> rio('afile')
   # method 2
   rio("tcp:",'localhost','daytime') >> rio('afile')
   # method 3
   rio('afile') << rio("tcp://:daytime")
   # method 4
   rio('afile') << rio("tcp://:13")

* Copy the first line and all lines containing 'http:' to a file
   # method 1
   rio('srcfile').lines(0,/http:/) > rio('dstfile')
   # method 2
   rio('dstfile') < rio('srcfile').lines(0,/http:/)
   # method 3
   rio('dstfile') < rio('srcfile').lines[0,/http:/]
   # method 4

* Create a gzipped copy of a file
   # method 1
   rio('afile') > rio('afile.gz').gzip
   # method 2
   rio('afile.gz').gzip < rio('afile')
   # method 3
   rio('afile.gz').gzip.print!( rio('afile').contents )

* Create an ungzipped copy of a gzipped file
   # method 1
   rio('afile') < rio('afile.gz').gzip
   # method 2
   rio('afile.gz').gzip > rio('afile')
   # method 3
   rio('afile').print!( rio('afile.gz').gzip.contents )

* Copy the first 100 lines of gzipped file on a webserver into a local file
   # method 1
   rio('http://aserver/afile.gz').gzip.lines(0...100) > rio('afile')


* Create a file composed of a header from another file, the output of the 'ps' command, some text and 
  its creation time pulled from the daytime server running on your localhost
   # method 1
   rio('out') < [ rio('header'), rio(?-,'ps'), "Created on ", rio('tcp://:daytime') ]
   # method 2
   rio('out') < rio('header') << rio(?-,'ps') << "Created on: " << rio("tcp://:daytime")


---

=== Reading multiple files 
   ario = rio('adir')
   string = ""
   array = []

* Count the lines of code in a directory tree of ruby source files
   # method 1
   cnt = ario.all.files('*.rb').skiplines[/^\s*#/,/^\s*$/].size
   # method 2
   cnt = ario.all.files('*.rb').skiplines(/^\s*#/,/^\s*$/).inject(0) { |sum,l|  sum += 1 }

* Concatanate the contents of all .txt files in a directory into an array
   # method 1
   array = ario.lines.files['*.txt']
   # method 2
   array = ario.files('*.txt').lines[]
   # method 3
   ario.files('*.txt').lines > array

* Concatanate the first line of all .txt files in a directory into an array
   # method 1
   array = ario.lines(0).files['*.txt']
   # method 2
   array = ario.files('*.txt').lines[0]
   # method 3
   ario.files('*.txt').lines(0) > array

* Copy all .txt files (but only their first ten lines) in a directory into another directiory
   # method 1
   ario.files('*.txt').lines(0...10) > rio('another_dir')

---

=== Read and write using Standard IO
   string = ""
   array = []

* Prompt for input and return what was typed
   # method 1
   ans = rio(?-).chomp.print("Type Something: ").gets
   # method 2
   stdio = rio(?-).chomp
   ans = stdio.print("Type Something: ").gets

* Create a Rio tied to stdin or stdout, depending on how it is used
   stdio = rio(?-)

* Create a Rio tied to stderr
   stderr = rio(?=)

* Write a string to stdout
   # method 1
   rio(?-).puts("Hello World")
   # method 2
   rio(?-) << "Hello World\n"
   # method 3
   rio(?-) < "Hello World\n"

* Read a string from stdin with the input chomped
   # method 1
   ans = rio(?-).chomp.gets
   # method 2
   stdio = rio(?-).chomp
   ans = stdio.gets

* Read from stdin until end of file with the result going into a string
   # method 1
   rio(?-) >> string
   # method 2
   rio(?-) > string

* Read from stdin until end of file with the chomped lines going into an array
   # method 1
   rio(?-).chomp >> array
   # method 2
   rio(?-).chomp > array

* Read from stdin until end of file with the result going into a file
   # method 1
   rio(?-) > rio('afile')
   # method 2
   rio('afile') < rio(?-)

* Read from stdin until end of file with the result appended to a file
   # method 1
   rio(?-) >> rio('afile')
   # method 2
   rio('afile') << rio(?-)

* Write a message to stderr
   # method 1
   rio(?=).puts("Hello Error")
   # method 2
   rio(?=) << "Hello Error\n"
   # method 3
   rio(?=) < "Hello Error\n"

* Dump a file to stdout
   # method 1
   rio('afile') > ?-
   # method 2
   rio('afile') > rio(?-)
   # method 3
   rio(?-) << rio('afile')
   # method 4
   rio('afile') >> ?-
   # method 5
   rio(?-) < rio('afile')
   # method 6
   rio(?-).print(rio('afile').contents)

* Emulate a simplified unix 'head' command which reads from stdin and writes the first 10 lines to stdout
   # method 1
   rio(?-).lines(0..9) > ?-

---

=== Reading and writing from processes as one might do with popen 

* Read the output of the 'ps' command into an array without the header line or the line representing
  the 'ps' command itself
   ps =  rio(?-,'ps -a').skiplines[0,/ps$/]

* Run an external program, copying its input from one location and its output to another, 
  and make it look very much like a shell command.

   infile = rio(?","Hello Kitty\n")
   outfile = rio('out.txt')

   # method 1
   cat = rio(?-,'cat').w!
   cat <infile >outfile

   # method 2
   infile | 'cat' | outfile
   
---

=== Renaming and moving files
   string = ""
   array = []

* Rename the file 'a' to 'b'
   # method 1
   rio('a').rename('b')
   # method 2
   rio('a').rename.filename = 'b'

* Rename a file and leave the Rio referencing the files old name
   ario = rio('a')
   # method 1
   ario.rename('b')

* Rename a file and change the Rio to reference the new file name
   ario = rio('a')
   # method 1
   ario.rename!('b')

* Rename the file 'index.htm' to 'index.html'
   # method 1
   rio('index.htm').rename('index.html')
   # method 2
   rio('index.htm').rename.extname = '.html'

* Rename the file 'index.html' to 'welcome.html'
   # method 1
   rio('index.html').rename('welecome.html')
   # method 2
   rio('index.htm').rename.basename = 'welcome'

* Move a file from directory 'src' to directory 'dst'
   # method 1
   rio('src/afile').rename('dst/afile')
   # method 2
   rio('src/afile').rename.dirname = 'dst'

* Change a file to have the extension '.html' leaving the rest of it as is
   # method 1
   ario.rename.extname = '.html'

* Change a files basename to 'rio4ruby' without changing its extension
   # method 1
   ario.rename.basename = 'rio4ruby'

* Change a file ending with '.tar.gz' to end with '.tgz'
   # method 1
   ario.rename.ext('.tar.gz').extname = '.tgz'

* Change the extension of all files with the extension '.htm' in a directory to have the 
  extension '.html'
   # method 1
   rio('adir').rename.files('*.htm') do |htmfile|
     htmlfile.extname = '.html'
   end
   # method 2
   rio('adir').files('*.htm') do |htmfile|
     htmlfile.rename.extname = '.html'
   end

* Change the extension of all files with the extension '.htm' in a directory and its
  subdirectories to have the extension '.html'
   # method 1
   rio('adir').rename.all.files('*.htm') do |htmfile|
     htmfile.extname = '.html'
   end
   # method 2
   rio('adir').all.files('*.htm') do |htmfile|
     htmfile.rename.extname = '.html'
   end

* Move a file in an arbitrary directory into the current working directory.
   # method 1
   rio('arb/i/trary/di/rec/tory/afile').rename.dirname = '.'


---

=== Manipulate a Rio's path
   string = ""
   array = []

* Create a Rio with an additional subdirectory appended
   ap = rio('adir')
   # method 1
   ap /= 'subdirectory'   
   # method 2
   ap = ap.join('subdirectory')
   # method 3
   ap = rio(ap,'subdirectory')

* Create a Rio from an array of subdirectories
   dirs = ['adir','subdir1','subdir2']
   # method 1
   ario = rio(dirs)

* Create an array of subdirectories from a Rio
   # method 1
   anarray = rio('adir/subdir1/subdir2').split

* Append a string to a path
   # method 1
   ario = rio('apath') + astring
   # method 2
   ario = rio('apath')
   ario += astring

* create a directory 'links' with a symlink pointing to each .rb file in directory 'lib' (including subdirectories)
   lib = rio('lib')
   links = rio('links').delete!.mkdir
   lib.all.files("*.rb") do |f|
     f.symlink( f.dirname.sub(/^#{lib}/,links).mkdir )
   end

----

Suggested Reading
* RIO::Doc::SYNOPSIS
* RIO::Doc::INTRO
* RIO::Rio

=end
module HOWTO
end
end
end
