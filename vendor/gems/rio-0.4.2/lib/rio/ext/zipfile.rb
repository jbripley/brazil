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

require 'rio/ext/zipfile/rl'
module RIO
  module ZipFile
    module Cx
      def zipfile(arg=true,&block)
        rootdir = new_rio_cx(:zipfile,self.to_s)
        return rootdir.each(&block) if block_given?
        rootdir
      end
    end
  end
end
module RIO
  module State
    class Base
      include RIO::ZipFile::Cx
    end
  end
end
__END__
module RIO
  module_function
  def load_lib(lib)
    begin 
      require lib
    rescue LoadError => ex
      begin
        p "using Gem for #{lib}" if $DEBUG
        require 'rubygems'
        require_gem lib
      rescue
        raise ex
      end
    end
  end
end

begin
  RIO.load_lib('zip/zip')
  require 'zip/zipfilesystem'
  require 'rio/ext/zipfile/opt'
  RIO::Ext::ZipFile.load_extension
rescue LoadError
  p "No zipfile support"  if $DEBUG
end


# module RIO
#   module Ext
#     module ZipFile
#       module Cx
#         def zipfile(&block) 
#           #require 'rio/ext/zipfile/state'
#           cxx('zipfile',true,&block)
#           #self.extend(ZipFile::State).fstream
#         end
#         def zipfile?() cxx?('zipfile') end 
#         def zipfile_() 
#           cxx_('zipfile',true) 
#         end
#         protected :zipfile_

#         def zipent(&block) 
#           cxx('zipent',true,&block)
#         end
#         def zipent?() cxx?('zipent') end 
#         def zipent_() 
#           cxx_('zipent',true) 
#         end
#         protected :zipent_
#       end
#     end
#   end
# end
__END__
