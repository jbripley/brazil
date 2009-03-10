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



The following examples are provided without comment

 array = rio('afile').readlines

 rio('afile') > rio('acopy')
 
 ary = rio('afile').chomp.lines[0...10]

 rio('adir').rename.all.files('*.htm') do |file| 
   file.ext = '.html'
 end

A basic familiarity with ruby and shell operations should allow a
casual reader to guess what these examples will do. How they are being
performed may not be what a casual reader might expect.  I will
explain these example to illustrate the Rio basics.

For many more examples please read the HOWTO document and the rdoc
documentation.

== Example 1.

 array = rio('afile').readlines

This uses IO#readlines to read the lines of 'afile' into an array.

=== Creating a Rio

Rio extends the module Kernel by adding one function +rio+, which acts
as a constructor returning a Rio. This constructor builds a
description of the resource the Rio will access (usually a path). It
does not open the resource, check for its existance, or do anything
except remember its specifcation. _rio_ returns the Rio which can be
chained to a Rio method as in this example or stored in a
variable. This coud have been written

 ario = rio('afile')
 array = ario.readlines

 ario = rio('afile')

In this case the resource specified is a relative path. After the
first line the Rio does know or care whether it is a path to a file
nor whether it exists. Rio provides many methods that only deal with a
resource at this level, much as the standard library classes Pathname
and URI. It should be noted at this point that Rio paths stored
internally as a URL as specified in RFC 1738 and therefore use slashes
as separators. A resource can also be specified without separators,
because _rio_ interprets multiple arguments as parts of a path to be
joined, and an array as an array of parts to be joined. So the
following all specify the same resource.

 rio('adir/afile')
 rio('adir','afile')
 rio(%w/adir afile/)

The rio constructor can be used to specify non-file-system resources,
but for this example we will restrict our discussion to paths to
entities on file-systems.

 array = ario.readlines

Now that we have a Rio, we can call one of its methods; in this case
_readlines_. This is an example of using a Rio as a proxy for the
builtin IO#readlines. Given the method _readlines_, the Rio opens
'afile' for reading, calls readlines on the resulting IO object,
closes the IO object, and returns the lines read.

== Example 2

 rio('afile') > rio('acopy')
 
This copies the file 'afile' into the file 'acopy'.

The first things that happen here are the creation of the Rios. As
described in Example 1, when created a Rio simply remembers the
specifcation of its resource. In this case, a relative path 'afile' on
the left and a relative path 'acopy' on the right.

Next the Rio#> (copy-to) method is called on the 'afile' Rio with the
'acopy' Rio as its argument. If that looks like a greater-than
operator to you, think Unix shell, with Rios '>' is the copy-to
operator.

Upon seeing the copy-to operator, the Rio has all the information it
needs to proceed. It determines that it must be opened for reading,
that its argument must be opened for writing, and that it's contents
must be copied to the resource referenced by it' argument -- and that
is what it does. Then it closes itself and its argument.

Consider if we had written this example this way.

 afile = rio('afile')
 acopy = rio('acopy')
 afile > acopy

In this case we would still have variables referencing the Rios, and
perhaps we would like do things a little differently than described
above. Be assured that the selection of mode and automatic closing of
files are the default behaviour and can be changed. Say we wanted
'afile' to remain open so that we could rewind it and make a second
copy, we might do something like this:

 afile = rio('afile').nocloseoneof
 afile > rio('acopy1')
 afile.rewind > rio('acopy2')
 afile.close

Actually the 'thinking process' of the Rio when it sees a copy-to
operator is much more complex than that described above.  If its
argument had been a rio referencing a directory, it would not have
opened itself for reading, but instead used FileUtils#cp to copy
itself; if its argument had been a string, its contents would have
ended up in the string; If its argument had been an array, its lines
would been elements of that array; if its argument had been a socket,
the its contents would have been copied to the socket. See the
documentation for details.

== Example 3.

 array = rio('afile').chomp.lines[0...10]

This fills +array+ with the first ten lines of 'afile', with each line chomped

The casual observer mentioned above might think that +lines+ returns an array of lines and that this
is a simple rewording of <tt>array = rio('afile').readlines[0...10]</tt> or even of 
<tt>array = File.new('afile').readlines[0...10]</tt>. They would be wrong.

+chomp+ is a configuration method which turns on chomp-mode and returns the Rio. Chomp-mode causes all
line oriented read operations to perform a String#chomp on each line

=== Reading files

Rio provides four methods to select which part of the file is read and
how the file is divided. They are +lines+, +records+, +rows+ and
+bytes+. Briefly, +lines+ specifies that the file should be read line
by line and <tt>bytes(n)</tt> specifies that the file should be read
in _n_ byte chunks. All four take arguments which can be used to
filter lines or chunks in or out. For simple Rios +records+ and +rows+
only specify the filter arguments and are provided for use be
extensions. For example, the CSV extension returns an array of the
columns in a line when +records+ is used. In the absence of an
extension +records+ and +rows+ behave like +lines+.

First lets rewrite our example as:

 array = rio('afile').chomp.lines(0...10).to_a

The arguments to lines specify which records are to be read. 
Arguments are interpreted based on their class as follows:
* Range - interpreted as a range of record numbers to be read
* Integer - interpreted as a one-element range
* RegExp - only matching records are processed
* Symbol - sent to each record, which is processed unless the result is false or nil
* Proc - called for each record, the record is processed unless the return value is false or nil
See the documentation for details and examples.

In our example we have specified the Range (0...10). The +lines+
method is just configuring the Rio, it does not trigger any IO
operation. The fact that it was called and the arguments it was called
with are stored away and the Rio is returned for further configuration
or an actual IO operation. When an IO operation is called the Range
will be used to limit processing to the first ten records. For
example:

 rio('afile').lines(0...10) { |line| ... }      # block will be called for the first 10 records
 rio('afile').lines[0...10]                     # the first 10 records will be returned in an array
 rio('afile').lines(0...10) > rio('acopy')      # the first 10 records will be copied to 'acopy'

"But wait", you say, "In our original example the range was an
argument to the subscript operator, not to +lines+".  This works
because the subscript operator processes its arguments as if they had
been arguments to the most-recently-called selection method and then
calls +to_a+ on the rio. So our rewrite of the example does precisely
the same thing as the original

The big difference between the original example and the
casual-observer's solution is that hers creates an array of the entire
contents and only returns the first 10 while the original only puts 10
records into the array.

As a sidenote, Rios also have an optimization that can really help in
certain situations. If records are only selected using Ranges, it
stops iterating when it is beyond the point where it could possibly
ever match. This can make a dramatic difference when one is only
interested in the first few lines of very large files.

== Example 4.

 rio('adir').rename.all.files('*.htm') do |file| 
   file.ext = '.html'
 end

This changes the extension of all .htm files below 'adir' to '.html'

First we create the rio as always.

Next we process the +rename+ method. When used as it is here --
without arguments -- it just turns on rename-mode and returns the Rio.

+all+ is another configuration method, which causes directories to be
processed recursively

+files+ is another configuration method. In example 3 we used +lines+
to select what to process when iterating through a file. +files+ is
used to select what to process when iterating through directories. The
arguments to +files+ can be the same as those for +lines+ except that
Ranges can not be used and globs can.

In our example, the argument to +files+ is a string which is treated
as a glob. As with +lines+, +files+ does not trigger any IO, it just
configures the Rio.

=== There's no action

The previous examples had something that triggered IO: +readlines+,
+to_a+, +each+, <tt>> (copy-to)</tt>. This example does not. This
example illustrates Rio's 'implied each'. All the configuration
methods will call each for you if a block is given. So, because a
block follows the +files+ method, it calls +each+ and passes it the
block.

Let's recap. At this point we have a Rio with a resource specified. We
have configured with a couple of modes, 'rename', and 'all', and we
have limited the elements we want to process to entries that are files
and match the glob '*.htm'. +each+ causes the Rio to open the
directory and call the block for each entry that is both a file and
matches the glob. It was also configured with +all+,so it descends
into subdirectories to find further matches and calles the block for
each of them. The argument passed to the block is a Rio referencing
the entry on the file-system.

The _rename_mode_ we set has had no effect on our iteration at all, so why is it there? In general, 
configuration options that are not applicable to a Rio are silently ignored, however, for directories
some of them are passed on to the Rios for each entry when iterating. Since +rename+ is one such option,
The example could have been written:

 rio('adir').all.files('*.htm') do |file| 
   file.rename.ext = '.html'
 end

The rename-with-no-args method affects the behaviour of the <tt>ext=</tt> option. In this case,
setting it for the directory, rather than for each file in the block seems to make the intent
of the code more clear, but that is a matter of personal taste. See the documentation for more 
information on the rename-with-no-args method

== Suggested Reading
* RIO::Doc::SYNOPSIS
* RIO::Doc::INTRO
* RIO::Doc::HOWTO
* RIO::Rio

=end
module EXAMPLES
end
end
end
