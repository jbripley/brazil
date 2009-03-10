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
require 'open-uri'
require 'rio/ftp/fs'
require 'rio/rl/path'
require 'rio/ftp/dir'
require 'rio/ftp/ftpfile'

module RIO
  module FTP #:nodoc: all
    #RESET_STATE = 'FTP::State::Reset'
    RESET_STATE = RIO::RL::PathBase::RESET_STATE
    
    require 'rio/rl/uri'

    class RL < RIO::RL::URIBase
      def initialize(arg0,*args)
        #p callstr('initialize',arg0,*args)
        super(*_sup_args(arg0,*args))
        @ftype = nil
        @names = nil
      end
      def _sup_args(arg0,*args)
        if arg0 == 'ftp:'
          hn = args.shift || 'localhost'
          us = args.shift 
          pw = args.shift
          pt = args.shift || ''
          ph = args.shift || '/'
          tc = args.shift || ''
          u = URI::FTP.new2(us,pw,hn,pt,ph,tc)
          return [u]
        else
          return [arg0] + args
        end
      end
#       def arg0_info_(arg0,*args)
#         #p "arg0_info_(#{arg0.inspect},#{args.inspect})"
#         vuri,vbase,vfs = nil,nil,nil
#         case arg0
#         when RIO::Rio
#           return _init_from_arg(arg0.rl)
#         when RIO::RL::URIBase,RIO::FTP::RL
#           vuri,vbase,vfs = arg0.uri,arg0.base,arg0.fs
#         when ::URI 
#           vuri = arg0
#         when ::String 
#           vuri = uri_from_string_(arg0) || ::URI.parse(arg0)
#         else
#           raise(ArgumentError,"'#{arg0}'[#{arg0.class}] can not be used to create a Rio")
#         end
#         [vuri,vbase,vfs]
#       end
#       def build_arg0_(path_str)
#         path_str
#       end
      def join(*args)
        return self if args.empty?
        join_(args.map{ |arg| RIO::RL.fs2url(arg.to_s)})
      end


      def self.splitrl(s)
        #p "splitrl(#{s})"
        sub,opq,whole = split_riorl(s)
        #p sub,opq,whole
        [whole] 
      end
      def openfs_
        #p callstr('openfs_')
        RIO::FTP::FS.create(self.uri)
      end
      def open(*args)
        IOH::Dir.new(RIO::FTP::Dir::Stream.new(self.uri))
      end
      def file_rl() 
        RIO::FTP::Stream::RL.new(self.uri) 
      end
      def dir_rl() 
        self 
      end
    end
    module Stream
      class RL < RIO::RL::URIBase
        def self.splitrl(s) 
          sub,opq,whole = split_riorl(s)
          [whole] 
        end
        def openfs_
          RIO::FTP::FS.create(@uri)
        end
        def open(m)
          case
          when m.primarily_write?
            RIO::IOH::Stream.new(RIO::FTP::FTPFile.new(fs.remote_path(@uri.to_s),fs.conn))
          else
            RIO::IOH::Stream.new(@uri.open)
          end
        end
        def file_rl() 
          self
        end
      end
    end
  end
end
