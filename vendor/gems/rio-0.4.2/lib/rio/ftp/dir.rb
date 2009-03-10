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

require 'net/ftp'
require 'uri'
require 'rio/fs/native'
require 'rio/ftp/conncache'

module RIO
  module FTP
    module Dir
      class Stream
        attr_reader :uri,:netftp,:remote_root
        def initialize(uri)
          @uri = uri.clone
          @conn = ConnCache.instance.connect(uri)
          @remote_root = @conn.remote_root
          @remote_root = '' if @remote_root == '/'
          @names = nil
          @entidx = 0
        end
        def url_root()
          root_uri = @uri.clone
          root_uri.path = ''
          root_uri.to_s
        end
        def close()
          ConnCache.instance.close(uri)
        end
        def remote_path()
          self.remote_root+@uri.path
        end
        def names()
          @names ||= begin
                       @conn.nlst(remote_path())
                     rescue ::Net::FTPPermError
                       []
                     end
        end
        def entpath(ent)
          ent.sub(/^#{remote_path}/,'')
        end
        def read()
          name = names[@entidx]
          if name
            rtn = entpath(name)
            @entidx +=1
            rtn
          end
        end
        def each(&block)
          p "Hello Mr. Phelps"
          names.each { |ent|
            @entidx += 1
            yield entpath(ent)
          }
          self
        end
      end
    end
  end
end
