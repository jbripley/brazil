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


# :title: Rio

module RIO
# Copyright (c) 2005,2006,2007,2008 Christopher Kleckner.
# All rights reserved
#
# This file is part of the Rio library for ruby.
# Rio is free software; you can redistribute it and/or modify it under the terms of 
# the {GNU General Public License}[http://www.gnu.org/licenses/gpl.html] as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
module Doc #:doc:
=begin rdoc

= Rio - Ruby I/O Facilitator

fa-cil-i-tate:  To make easy or easier.

Rio is a facade for most of the standard ruby classes that deal with I/O;
providing a simple, intuitive, succinct interface to the functionality
provided by IO, File, Dir, Pathname, FileUtils, Tempfile, StringIO, OpenURI
and others. Rio also provides an application level interface which allows many
common I/O idioms to be expressed succinctly.


== SYNOPSIS

For the following assume:
 astring = ""
 anarray = []

Iterate over the .rb files in a directory.
 rio('adir').files('*.rb') { |entrio| ... }

Return an array of the .rb files in a directory.
 rio('adir').files['*.rb']

Copy the .rb files in a directory.to another directory.
 rio('adir').files('*.rb') > rio('another_directory')

Iterate over the .rb files in a directory and its subdirectories.
 rio('adir').all.files('*.rb') { |entrio| ... }

Return an array of the .rb files in a directory and its subdirectories.
 rio('adir').all.files['*.rb']

Copy or append a file to a string
 rio('afile') > astring      # copy
 rio('afile') >> astring     # append

Copy or append a string to a file
 rio('afile') < astring      # copy
 rio('afile') << astring     # append

Copy or append the lines of a file to an array
 rio('afile') > anarray     
 rio('afile') >> anarray
 
Copy or append a file to another file
 rio('afile') > rio('another_file')  
 rio('afile') >> rio('another_file') 

Copy a file to a directory
 rio('adir') << rio('afile')

Copy a directory to another directory
 rio('adir') >> rio('another_directory')

Copy a web-page to a file
 rio('http://rubydoc.org/') > rio('afile')

Read a web-page into a string
 astring = rio('http://rubydoc.org/').read

Ways to get the chomped lines of a file into an array
 anarray = rio('afile').chomp[]         # subscript operator
 rio('afile').chomp > anarray           # copy-to operator
 anarray = rio('afile').chomp.to_a      # to_a
 anarray = rio('afile').chomp.readlines # IO#readlines
 
Iterate over selected lines of a file
 rio('adir').lines(0..3) { |aline| ... }       # a range of lines
 rio('adir').lines(/re/) { |aline| ... }       # by regular expression
 rio('adir').lines(0..3,/re/) { |aline| ... }  # or both
 
Return selected lines of a file as an array
 rio('adir').lines[0..3]       # a range of lines
 rio('adir').lines[/re/]       # by regular expression
 rio('adir').lines[0..3,/re/]  # or both
 
Iterate over selected chomped lines of a file
 rio('adir').chomp.lines(0..3) { |aline| ... }       # a range of lines
 rio('adir').chomp.lines(/re/) { |aline| ... }       # by regular expression

Return selected chomped lines of a file as an array
 rio('adir').chomp[0..3]  # a range of lines
 rio('adir').chomp[/re/]  # by regular expression
 
Copy a gzipped file un-gzipping it
 rio('afile.gz').gzip > rio('afile')

Copy a plain file, gzipping it
 rio('afile.gz').gzip < rio('afile')

Copy a file from a ftp server into a local file un-gzipping it
 rio('ftp://host/afile.gz').gzip > rio('afile')

Return an array of .rb files excluding symlinks to .rb files
 rio('adir').files('*.rb').skip[:symlink?]

Put the first 10 chomped lines of a gzipped file into an array
 anarray =  rio('afile.gz').chomp.gzip[0...10] 

Copy lines 0 and 3 thru 5 of a gzipped file on an ftp server to stdout
 rio('ftp://host/afile.gz').gzip.lines(0,3..5) > ?-

Return an array of files in a directory and its subdirectories, without descending into .svn directories. 
 rio('adir').norecurse(/^\.svn$/).files[]

Iterate over the non-empty, non-comment chomped lines of a file
 rio('afile').chomp.skip(:empty?,/^\s*#/) { |line| ... }

Copy the output of th ps command into an array, skipping the header line and the ps command entry
 rio(?-,'ps -a').skiplines(0,/ps$/) > anarray 

Prompt for input and return what was typed
 ans = rio(?-).print("Type Something: ").chomp.gets 

Change the extension of all .htm files in a directory and its subdirectories to .html
 rio('adir').rename.all.files('*.htm') do |htmfile|
   htmfile.extname = '.html'
 end

=== SUGGESTED READING

* RIO::Doc::INTRO
* RIO::Doc::HOWTO
* RIO::Rio
* RIO::Doc::EXAMPLES
* RIO::Doc::OPTIONAL

=end
module SYNOPSIS #:doc:
end
end
end
