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
    class FS 
      attr_reader :uri
      def initialize(uri)
        @uri = uri.clone
        @file = ::File
        @conn = nil
      end
      def self.create(*args)
        new(*args)
      end
      def remote_root
        conn.remote_root
      end
      def conn
        @conn ||= ConnCache.instance.connect(@uri)
      end



      def root()
        uri = @uri.clone
        uri.path = '/'
        uri.to_s
      end
      include RIO::FS::Str

      
      def pwd() conn.pwd end
      def getwd()
        self.pwd
      end
      def cwd()
        remote_wd = self.pwd
        remote_rel = remote_wd.sub(/^#{self.remote_root}/,'')
        wduri = uri.clone
        wduri.path = remote_rel
        wduri.to_s
      end
      def remote_path(url)
        self.remote_root+RIO::RL.url2fs(URI(url).path)
      end
      def chdir(url,&block)
        if block_given?
          wd = conn.pwd
          conn.chdir(remote_path(url))
          begin
            rtn = yield remote_path(url)
          ensure
            conn.chdir(wd)
          end
          return rtn
        else
          conn.chdir(remote_path(url))
        end
      end
      def mkdir(url)
        conn.mkdir(remote_path(url))
      end
      def mv(src_url,dst_url)
        conn.rename(remote_path(src_url),remote_path(dst_url))
      end
      def size(url)
        conn.size(remote_path(url))
      end
      def zero?(url)
        size(url) == 0
      end
      def mtime(url)
        conn.mtime(remote_path(url))
      end
      def rmdir(url)
        conn.rmdir(remote_path(url))
      end
      def rm(url)
        conn.delete(remote_path(url))
      end

      def get_ftype(url)
        pth = remote_path(url)
        #p url,pth
        ftype = nil
        begin
          conn.mdtm(pth)
          ftype = 'file'
        rescue Net::FTPPermError
          wd = conn.pwd
          begin
            conn.chdir(pth)
            ftype = 'dir'
          rescue Net::FTPPermError
            ftype = 'nada'
          ensure
            conn.chdir(wd)
          end
        end
        ftype
      end
      def file?(url)
        get_ftype(url) == 'file'
      end
      def directory?(url)
        get_ftype(url) == 'dir'
      end
      def exist?(url)
        get_ftype(url) != 'nada'
      end
      def symlink?(url)
        false
      end
      def mkpath(url)
        tpath = rio(url)
        tmprio = tpath.root
        pathparts = tpath.path.split('/')[1..-1]
        pathparts.each do |part|
          tmprio.join!(part)
          tmprio.mkdir
        end
      end
      def rmtree(url)
        ario = rio(url)
        _rment(ario)
      end

      private

      def _rment(ario)
        if ario.file?
          ario.rm
        else
          ario.each do |ent|
            _rment(ent)
          end
          ario.rmdir
        end
      end
    end
  end
end
