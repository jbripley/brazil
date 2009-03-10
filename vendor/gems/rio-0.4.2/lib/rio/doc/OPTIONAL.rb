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

Please read the following first:
* RIO::Doc::INTRO
* RIO::Doc::SYNOPSIS
* RIO::Doc::HOWTO
* RIO::Rio

= Rio Optional Components

This document describes various optional Rio components, that must be
explicitly 'required' to be available. These are not included in
rio.rb either because they change classes that should not be changed
without the developers explicit permission, or because they are not of
general enough interest.

== to_rio

This option comprises 4 options
* Object#to_rio

    require 'rio/to_rio/object' 
    ario = any_object.to_rio

  This option adds a to_rio method to the Object class which calls the
  object's #to_s method and passes it to the Rio constructor. Like:

    ario = rio(any_object.to_s)

* String#to_rio and String#/

    require 'rio/to_rio/string'
    ario = "a/file/represented/as/a/string".to_rio
    ario = 'strings'/'used'/'with'/'subdirectory'/'operator'

  This option adds a to_rio method and the subdirectory operator '/'
  to the String class. Note that due to operator precedance one must
  use parenthesis when calling a method directly on a Rio created
  using the subdirectory operator with Strings

    array_of_first_ten_lines = ('adir'/'asubdir'/'afile').lines[0...10]  

* Array#to_rio

    require 'rio/to_rio/array'
    ario = %w[an array of path components].to_rio #=> rio('an/array/of/path/components')

  This option adds a to_rio method to the Array class. This behaves as
  if 
   rio(%w[an array of path components]) had been called.

* require 'rio/to_rio/all' will make all of the above available.

== RIO.ARGV

 require 'rio/argv'
 arguments_as_rios = RIO.ARGV

This option provides a function which converts each element of ruby's
ARGV into a Rio.  Useful when writing a program which takes a list of
files as its arguments

== RIO.popen3

 require 'rio/open3'
 input,output,errput = RIO.popen3
 RIO.popen3 { |input,output,errput| ... }

This options provides a wrapper around the Open3#popen3 call with the
IO objects converted to Rios

== RIO.prompt

 require 'rio/prompt'
 the_anwser = RIO.prompt('What is the answer? ')

This option provides a module function to prompt for input.


=end
module OPTIONAL
end
end
end
