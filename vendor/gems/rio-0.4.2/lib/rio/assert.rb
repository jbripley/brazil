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


#!/usr/bin/env ruby

require 'rio/kernel'
module RIO
  module Assert #:nodoc: all
    def ok(a,b,msg=nil)
      puts "PASS" + (msg.nil? ? "" : ": #{msg}")
    end
    def nok(a,b,msg=nil)
      puts "FAIL" + (msg.nil? ? "" : ": #{msg}")
      puts "   exp: #{a.inspect}"
      puts "   was: #{b.inspect}"
    end
    
    def assert(a,msg=nil)
      assert_equal(true,a,msg)
    end
    def assert_equal(a,b,msg=nil)
      if a == b
        ok(a,b,msg)
      else
        nok(a,b,msg)
      end
    end
    def assert_case_equal(a,b,msg=nil)
      if a == b
        ok(a,b,msg)
      else
        nok(a,b,msg)
      end
    end
    def assert_block(msg=nil)
      if yield
        ok(nil,nil,msg)
      else
        nok(nil,nil,msg)
      end
    end
      
    def assert_not_equal(a,b,msg=nil)
      if a != b
        ok(a,b,msg)
      else
        nok(a,b,msg)
      end
    end
    def assert_nil(a,msg=nil)
      if a.nil?
        ok(nil,a)
      else
        nok(nil,a)
      end
    end
    def assert_same(a,b,msg=nil)
      if a.equal? b
        ok(a,b)
      else
        nok(a,b)
      end
    end
    def assert_match(a,b,msg=nil)
      if a =~ b
        ok(a,b)
      else
        nok(a,b)
      end
    end
    def assert_kind_of(a,b,msg=nil)
      if b.kind_of?(a)
        ok(a,b.class)
      else
        nok(a,b.class)
      end
    end
    def assert_equal_s(a,b,msg=nil) assert_equal(a.to_s,b.to_s,msg) end
    def assert_equal_a(a,b,msg=nil) assert_equal(a.sort,b.sort,msg) end
  end
end
