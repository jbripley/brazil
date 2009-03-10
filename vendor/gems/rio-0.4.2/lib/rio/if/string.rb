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
    # Returns the String associated with a Rio which references a StringIO object.
    # For any other type of Rio, is undefined.
    def string() target.string end
  end
end

module RIO
  module IF
    module String

      # Create a Rio referencing Rio#to_str + arg.to_str
      #
      #  rio('afile') + '-0.1'   #=> rio('afile-0.1')
      #
      def +(arg) target + arg end

      # Create a new Rio referencing the result of applying ::String#sub to the 
      # value returned by Rio#to_s. So:
      #
      #  ario.sub(re,string)
      # is equivelent to
      #  rio(ario.to_s.sub(re,string))
      #
      # See also #gsub, #+
      def sub(re,string) target.sub(re,string) end

      # Create a new Rio referencing the result of applying ::String#gsub to the 
      # value returned by Rio#to_s. So:
      #
      #  ario.gsub(re,string)
      # is equivelent to
      #  rio(ario.to_s.gsub(re,string))
      #
      # See also #sub #+
      def gsub(re,string) target.gsub(re,string) end
      
      
    end
  end
end
module RIO
  class Rio
    include RIO::IF::String
  end
end
