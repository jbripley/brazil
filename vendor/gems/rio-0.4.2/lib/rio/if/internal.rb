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
    # This is an internal function and is not needed in client code.
    # It returns the internal 'Context' object.
    #def cx() target.cx() end
    
    # This is an internal function and should not normally be needed in client code.
    # It closes a Rio and returns it to its 'reset' state.
    def reset() # :nodoc:
      target.reset() 
    end
    
    # This is an internal function and is not needed in client code.
    # It returns the internal 'Rio Resource Locator' object.
    def rl() # :nodoc:
      target.rl() 
    end

    # This is an internal function and is not needed in client code.
    # It returns the internal 'Rio Resource Locator' object.
    def to_rl() # :nodoc:
      target.to_rl() 
    end

    # This is an internal function and is not needed in client code.
    # It returns the internal 'Rio Context' object.
    def cx() # :nodoc:
      target.cx() 
    end

    # This is an internal function and is not needed in client code.
    def cx=(arg) # :nodoc:
      target.cx = arg 
    end

    # This is an internal function and is not needed in client code.
    def copyclose() # :nodoc:
      target.copyclose 
    end

    # This is an internal function and is not needed in client code.
    def nostreamenum() # :nodoc:
      target.nostreamenum 
    end

    # This is an internal function and is not needed in client code.
    def cpclose(*args,&block) # :nodoc:
      target.cpclose(*args,&block) 
    end

    # This is an internal function and is not needed in client code.
    def each_record(*args,&block) # :nodoc:
      target.each_record(*args,&block) 
    end

    # This is an internal function and is not needed in client code.
    def each_row(*args,&block) # :nodoc:
      target.each_row(*args,&block) 
    end

    # This is an internal function and is not needed in client code.
    def outputmode?() # :nodoc:
      target.outputmode? 
    end

    # This is an internal function and is not needed in client code.
    def inputmode?() # :nodoc:
      target.inputmode? 
    end

    # This is an internal function and is not needed in client code.
    def iostate(sym) # :nodoc:
      target.iostate(sym) 
    end

    # This is an internal function and is not needed in client code.
    def getwd(*args) # :nodoc:
      target.getwd(*args) 
    end

    # This is an internal function and is not needed in client code.
    def stream_iter?() # :nodoc:
      target.stream_iter? 
    end

    

  end
end
