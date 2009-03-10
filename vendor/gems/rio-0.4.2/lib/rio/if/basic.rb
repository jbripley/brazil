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
  class Rio

    #def to_rl() target.to_rl end
    
    # Returns the length of the Rio's String representation
    # 
    # To get the size of the underlying file system object use RIO::IF::Test#size
    def length() target.length end

    # Equality - calls to_s on _other_ and compares its return value 
    # with the value returned by Rio#to_s
    def ==(other) target == other end

    # Equality (for case statements) same as Rio#==
    def ===(other) target === other end

    # Rios are hashed based on their String representation
    def hash() target.hash end

    # Returns true if their String representations are eql?
    def eql?(other) target.eql?(other) end

    # Match - invokes _other_.=~, passing the value returned by Rio#to_str
    def =~(other) target =~ other end
      
  end
end
