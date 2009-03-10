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


require 'rio/rl/base'
require 'rio/rl/withpath'
require 'rio/fs/url'
require 'rio/fs/native'
require 'rio/uri/file'

module RIO
  module RL
    class URIBase < WithPath
      SCHEME = URI::REGEXP::PATTERN::SCHEME
      HOST = URI::REGEXP::PATTERN::HOST

      attr_accessor :uri
      def initialize(u,*args)
        # u should be a ::URI or something that can be parsed to one
        #p callstr('initialize',u,*args)
        @base = nil
        @fs = nil
        args = _get_opts_from_args(args)
        init_from_args_(u,*args)
        super
        unless self.absolute? or @base
          @base = ::URI::parse('file://'+RL.fs2url(fs.getwd)+'/')
        end
        @uri.path = '/' if @uri.absolute? and @uri.path == ''
      end
      def arg0_info_(arg0,*args)
        #p "arg0_info_(#{arg0.inspect},#{args.inspect})"
        vuri,vbase,vfs = nil,nil,nil
        case arg0
        when RIO::Rio
          return _init_from_arg(arg0.rl)
        when URIBase
          vuri,vbase,vfs = arg0.uri,arg0.base,arg0.fs
        when ::URI 
          vuri = arg0
        when ::String 
          vuri = uri_from_string_(arg0) || ::URI.parse(arg0)
        else
          raise(ArgumentError,"'#{arg0}'[#{arg0.class}] can not be used to create a Rio")
        end
        #puts "uri.rb arg0_info_: vuri=#{vuri}"
        [vuri,vbase,vfs]
      end
      def init_from_args_(arg0,*args)
        #p "init_from_args_(#{arg0.inspect})"
        #p callstr('init_from_args_',arg0.inspect,args)
        vuri,vbase,vfs = self.arg0_info_(arg0,*args)
        #p vuri,vbase
        #p vuri
        @uri = vuri
        #p 'HERE'
        #p vuri
        #p args unless args.nil? || args.empty?
        self.join(*args)
        @base = vbase unless @base or vbase.nil?
        fs = vfs if vfs 
      end
      def _get_base_from_arg(arg)
        #p "_get_base: #{arg.inspect}"
        case arg
        when RIO::Rio
          arg.abs.to_uri
        when URIBase
          arg.abs.uri
        when ::URI 
          arg if arg.absolute?
        when ::String 
          uri_from_string_(arg) || ::URI.parse([RL.fs2url(::Dir.getwd+'/'),arg].join('/').squeeze('/'))
        else
          raise(ArgumentError,"'#{arg}' is not a valid base path")
        end
      end
      def _get_opts_from_args(args)
        if !args.empty? and args[-1].kind_of?(::Hash) 
          opts = args.pop
          if b = opts[:base]
            @base = _get_base_from_arg(b)
            #@base.path.sub!(%r{/*$},'/')
          end
          if fs = opts[:fs]
            @fs = fs
          end
        end
        args
      end
      def initialize_copy(*args)
        super
        @uri = @uri.clone unless @uri.nil?
        @base = @base.clone unless @base.nil?
      end
      def absolute?()
        uri.absolute?
      end
      alias :abs? :absolute?
      def openfs_()
        #p callstr('openfs_')
        @fs || RIO::FS::Native.create()
      end
      def url()
        self.uri.to_s
      end
      def to_s()
        self.url
      end
      def urlpath() uri.path end
      def urlpath=(arg) 
        #p uri,arg
        uri.path = arg 
      end
      def path()
        case scheme
        when 'file','path' then fspath()
        else urlpath()
        end
      end
      def path=(pth)
        case scheme
        when 'file','path' then self.fspath = pth
        else self.urlpath = pth
        end
      end
      def scheme() uri.scheme end
      def host() uri.host end
      def host=(arg) uri.host = arg end
      def opaque()
        u = uri.clone
        u.query = nil
        u.to_s.sub(/^#{SCHEME}:/,'')
      end
      def pathroot()
        u = uri.clone
        u.query = nil
        case scheme
        when 'file'
          if self.urlpath =~ %r%^(/[a-zA-Z]):% then $1+':/'
          else '/'
          end
        else
          u.path = '/'
          u.to_s
        end
      end
      def urlroot()
        return nil unless absolute?
        cp = self.clone
        cp.urlpath = self.pathroot
        cp.url
      end
      def base()
        @base || self.uri
      end
      def base=(arg)
        #p "uri.rb:base= arg=#{arg.inspect}"
        @base = _uri(arg)
      end
      def join(*args)
        return self if args.empty?
        join_(args.map{ |arg| arg.to_s})
      end
    end
  end
end

