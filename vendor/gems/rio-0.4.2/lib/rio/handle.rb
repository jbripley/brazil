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


require 'rio/base'

module RIO
  class Handle < Base #:nodoc: all
    attr_accessor :target
    def initialize(st=nil) 
      @target = st 
    end
    def initialize_copy(*args)
      #p callstr('initialize_copy',*args)
      super
      @target = @target.clone
    end
    def method_missing(sym,*args,&block)
      #  p callstr('method_missing',*args)
      @target.__send__(sym,*args,&block)
    end
    def t_instance_of?(*args) @target.instance_of?(*args) end
    def t_kind_of?(*args) @target.kind_of?(*args) end
    def t_class(*args) @target.class(*args) end
    def to_s() @target.to_s() end
    def split(*args,&block) @target.split(*args,&block) end
    def callstr(func,*args)
      self.class.to_s+'['+self.to_s+']'+'.'+func.to_s+'('+args.join(',')+')'
    end
  end
end

if $0 == __FILE__
  eval DATA.read, nil, $0, __LINE__+4
end

__END__

require 'test/unit'

class TC_Handle < Test::Unit::TestCase
  def test_handle
    assert_nothing_raised { 
      h = Handle.new()
    }
    h = Handle.new()
    assert_nil(h.v)
    object = String.new("Zippy")
    h = FwdHandle.new(object,$stdout)
    s = "Hello World\n"

    rtn = h.fwd_rtn(:write,s)
    assert_equal(rtn,s.length)

    rtn = h.fwd_rtn_obj(:write,s)
    assert_same(rtn,object)

    rtn = h.fwd_rtn_new(:write,s)
    assert_equal(object.class,rtn.class)
    assert_not_same(object,rtn)
    assert_equal(rtn,s.length.to_s)

    rtn = h.write(s)
    p rtn
#    assert_equal(sdocdir,docdir.to_s)
#    assert_instance_of(RIO::Rio,doc,"catpath does not return an FS")
  end
end
