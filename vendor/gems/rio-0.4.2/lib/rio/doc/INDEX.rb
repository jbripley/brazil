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
module Doc
=begin rdoc

= Rio - Index

Constructors:
RIO#rio
RIO#cwd
RIO#root

Directories:
RIO::IF::Dir#chdir
RIO::IF::Dir#find
RIO::IF::Dir#glob
RIO::IF::Dir#mkdir
RIO::IF::Dir#mkpath
RIO::IF::Dir#rmdir
RIO::IF::Dir#rmtree

Files:
RIO::IF::File#clear
RIO::IF::File#rm
RIO::IF::File#touch
RIO::IF::File#truncate

Files or Directories:
RIO::IF::FileOrDir#open
RIO::IF::FileOrDir#pos
RIO::IF::FileOrDir#pos=
RIO::IF::FileOrDir#read
RIO::IF::FileOrDir#readlink
RIO::IF::FileOrDir#rename
RIO::IF::FileOrDir#rename!
RIO::IF::FileOrDir#reopen
RIO::IF::FileOrDir#rewind
RIO::IF::FileOrDir#seek
RIO::IF::FileOrDir#symlink
RIO::IF::FileOrDir#tell

Path:
RIO::IF::Path#/
RIO::IF::Path#abs
RIO::IF::Path#base
RIO::IF::Path#basename
RIO::IF::Path#basename=
RIO::IF::Path#cleanpath
RIO::IF::Path#dirname
RIO::IF::Path#dirname=
RIO::IF::Path#expand_path
RIO::IF::Path#ext
RIO::IF::Path#ext?
RIO::IF::Path#extname
RIO::IF::Path#extname=
RIO::IF::Path#filename
RIO::IF::Path#filename=
RIO::IF::Path#fspath
RIO::IF::Path#host
RIO::IF::Path#join
RIO::IF::Path#join!
RIO::IF::Path#merge
RIO::IF::Path#noext
RIO::IF::Path#opaque
RIO::IF::Path#path
RIO::IF::Path#realpath
RIO::IF::Path#rel
RIO::IF::Path#route_from
RIO::IF::Path#route_to
RIO::IF::Path#scheme
RIO::IF::Path#splitpath
RIO::IF::Path#to_uri
RIO::IF::Path#to_url
RIO::IF::Path#urlpath

String:
RIO::IF::String#+
RIO::IF::String#gsub
RIO::IF::String#sub

Grande:
RIO::IF::Grande#[]
RIO::IF::Grande#<
RIO::IF::Grande#<<
RIO::IF::Grande#>
RIO::IF::Grande#>>
RIO::IF::Grande#|
RIO::IF::Grande#append_from
RIO::IF::Grande#append_to
RIO::IF::Grande#copy_from
RIO::IF::Grande#copy_to
RIO::IF::Grande#delete
RIO::IF::Grande#delete!
RIO::IF::Grande#each
RIO::IF::Grande#empty?
RIO::IF::Grande#get
RIO::IF::Grande#skip
RIO::IF::Grande#split
RIO::IF::Grande#to_a

Grande Directory:
RIO::IF::GrandeEntry#all
RIO::IF::GrandeEntry#all?
RIO::IF::GrandeEntry#dirs
RIO::IF::GrandeEntry#entries
RIO::IF::GrandeEntry#files
RIO::IF::GrandeEntry#norecurse
RIO::IF::GrandeEntry#recurse
RIO::IF::GrandeEntry#skipdirs
RIO::IF::GrandeEntry#skipentries
RIO::IF::GrandeEntry#skipfiles

Grande Stream:
RIO::IF::GrandeStream#+@
RIO::IF::GrandeStream#a
RIO::IF::GrandeStream#a!
RIO::IF::GrandeStream#bytes
RIO::IF::GrandeStream#chomp
RIO::IF::GrandeStream#chomp?
RIO::IF::GrandeStream#closeoncopy
RIO::IF::GrandeStream#closeoncopy?
RIO::IF::GrandeStream#closeoneof
RIO::IF::GrandeStream#closeoneof?
RIO::IF::GrandeStream#contents
RIO::IF::GrandeStream#getline
RIO::IF::GrandeStream#getrec
RIO::IF::GrandeStream#getrow
RIO::IF::GrandeStream#gzip
RIO::IF::GrandeStream#gzip?
RIO::IF::GrandeStream#line
RIO::IF::GrandeStream#lines
RIO::IF::GrandeStream#noautoclose
RIO::IF::GrandeStream#nocloseoncopy
RIO::IF::GrandeStream#nocloseoneof
RIO::IF::GrandeStream#putrec
RIO::IF::GrandeStream#r
RIO::IF::GrandeStream#r!
RIO::IF::GrandeStream#record
RIO::IF::GrandeStream#records
RIO::IF::GrandeStream#row
RIO::IF::GrandeStream#rows
RIO::IF::GrandeStream#skiplines
RIO::IF::GrandeStream#skiprecords
RIO::IF::GrandeStream#skiprows
RIO::IF::GrandeStream#splitlines
RIO::IF::GrandeStream#strip
RIO::IF::GrandeStream#strip?
RIO::IF::GrandeStream#w
RIO::IF::GrandeStream#w!

Ruby I/O:
RIO::IF::RubyIO#binmode
RIO::IF::RubyIO#close
RIO::IF::RubyIO#close_write
RIO::IF::RubyIO#each_byte
RIO::IF::RubyIO#each_line
RIO::IF::RubyIO#eof?
RIO::IF::RubyIO#fcntl
RIO::IF::RubyIO#fileno
RIO::IF::RubyIO#flush
RIO::IF::RubyIO#fsync
RIO::IF::RubyIO#getc
RIO::IF::RubyIO#gets
RIO::IF::RubyIO#ioctl
RIO::IF::RubyIO#ioh
RIO::IF::RubyIO#ios
RIO::IF::RubyIO#lineno
RIO::IF::RubyIO#lineno=
RIO::IF::RubyIO#mode
RIO::IF::RubyIO#mode?
RIO::IF::RubyIO#nosync
RIO::IF::RubyIO#pid
RIO::IF::RubyIO#print
RIO::IF::RubyIO#print!
RIO::IF::RubyIO#printf
RIO::IF::RubyIO#printf!
RIO::IF::RubyIO#putc
RIO::IF::RubyIO#putc!
RIO::IF::RubyIO#puts
RIO::IF::RubyIO#puts!
RIO::IF::RubyIO#readline
RIO::IF::RubyIO#readlines
RIO::IF::RubyIO#readpartial
RIO::IF::RubyIO#recno
RIO::IF::RubyIO#sync
RIO::IF::RubyIO#sync?
RIO::IF::RubyIO#to_i
RIO::IF::RubyIO#to_io
RIO::IF::RubyIO#tty?
RIO::IF::RubyIO#ungetc
RIO::IF::RubyIO#write
RIO::IF::RubyIO#write!

Test:
RIO::IF::Test#abs?
RIO::IF::Test#absolute?
RIO::IF::Test#atime
RIO::IF::Test#blockdev?
RIO::IF::Test#chardev?
RIO::IF::Test#closed?
RIO::IF::Test#ctime
RIO::IF::Test#dir?
RIO::IF::Test#directory?
RIO::IF::Test#executable_real?
RIO::IF::Test#executable?
RIO::IF::Test#exist?
RIO::IF::Test#file?
RIO::IF::Test#fnmatch?
RIO::IF::Test#ftype
RIO::IF::Test#grpowned?
RIO::IF::Test#lstat
RIO::IF::Test#mountpoint?
RIO::IF::Test#mtime
RIO::IF::Test#open?
RIO::IF::Test#owned?
RIO::IF::Test#pipe?
RIO::IF::Test#readable_real?
RIO::IF::Test#readable?
RIO::IF::Test#root?
RIO::IF::Test#setgid?
RIO::IF::Test#setuid?
RIO::IF::Test#size
RIO::IF::Test#size?
RIO::IF::Test#socket?
RIO::IF::Test#stat
RIO::IF::Test#sticky?
RIO::IF::Test#symlink?
RIO::IF::Test#writable_real?
RIO::IF::Test#writable?
RIO::IF::Test#zero?


Basic:
RIO::Rio#==
RIO::Rio#===
RIO::Rio#=~
RIO::Rio#dup
RIO::Rio#eql?
RIO::Rio#hash
RIO::Rio#initialize_copy
RIO::Rio#inspect
RIO::Rio#length
RIO::Rio#new
RIO::Rio#rio
RIO::Rio#string
RIO::Rio#to_s
RIO::Rio#to_str

CSV:
RIO::IF::CSV#columns
RIO::IF::CSV#csv
RIO::IF::CSV#skipcolumns

YAML:
RIO::IF::YAML#document
RIO::IF::YAML#documents
RIO::IF::YAML#dump
RIO::IF::YAML#getobj
RIO::IF::YAML#load
RIO::IF::YAML#object
RIO::IF::YAML#objects
RIO::IF::YAML#putobj
RIO::IF::YAML#putobj!
RIO::IF::YAML#skipdocuments
RIO::IF::YAML#skipobjects
RIO::IF::YAML#yaml
RIO::IF::YAML#yaml?



=end
module INDEX
end
end
end

