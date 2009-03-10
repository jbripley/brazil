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


# cell phone number: 954-6752.
require 'rio/state'
module RIO

  module Path
    # Base class for states that keep path information in a string
    # For now this is all states, but that could change
    class Reset < State::Base
      def base_state() 
        #p "RETURNING WIERD BASE STATE"
        'Path::Reset' 
      end

      def check?() true end
      def pathempty() become('Path::Empty')  end
      def pathstring() become('Path::Str')  end
      

      def when_missing(sym,*args)
#        p callstr('when_missing',sym,*args)
        if to_s.empty?
          pathempty()
        else
          pathstring()
        end
      end

#      extend Forwardable
#      def_instance_delegators(:path,:empty?)
    end 
  end 
    
end
