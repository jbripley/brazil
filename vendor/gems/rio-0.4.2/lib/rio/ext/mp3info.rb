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


require 'mp3info'
require 'forwardable'
module RIO
  module Ext
    module Mp3Info
        def mp3info() ::Mp3Info.new(self.fspath) end

        extend Forwardable

        def_instance_delegators(:mp3info,:tag,:bitrate,:samplerate)
        def_instance_delegators(:tag,:tracknum)
        def title() _chop0(tag.title) end
        def album() _chop0(tag.album) end
        def artist() _chop0(tag.artist) end
        def year() _chop0(tag.year.to_s) end
        def mp3length() mp3info.length end
        def vbr() mp3info.vbr end
        alias :vbr? :vbr
        def time() 
          t = Time.at(mp3length).getutc
          t.strftime(t.hour == 0 ? "%M:%S" : "%H:%M:%S") 
        end

        private

        def _chop0(str)
          str && str.length > 0 && str[-1] == 0 ? str.chop : str
        end
    end
  end
end
    

module RIO
  module Ops
    module File
      module Existing
        include RIO::Ext::Mp3Info
      end
    end
  end
end

__END__
