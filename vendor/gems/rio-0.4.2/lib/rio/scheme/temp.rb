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

require 'tmpdir'
module RIO
  module Temp #:nodoc: all
    RESET_STATE = 'Temp::Reset'

    require 'rio/rl/base'
    class RL < RL::Base 
      RIOSCHEME = 'temp'
      RIOPATH = RIO::RL::CHMAP.invert[RIOSCHEME].to_s.freeze
      DFLT_PREFIX = 'rio'
      DFLT_TMPDIR = ::Dir::tmpdir
      attr_reader :prefix,:tmpdir
      def initialize(file_prefix=DFLT_PREFIX,temp_dir=DFLT_TMPDIR)
        #puts "initialize(#{file_prefix.inspect},#{temp_dir.inspect})"
        @prefix = file_prefix || DFLT_PREFIX
        @tmpdir = temp_dir || DFLT_TMPDIR
        super
      end
      #def path() nil end
      def scheme() self.class.const_get(:RIOSCHEME) end
      def opaque()
        td = self.escape(@tmpdir.to_s)
        td += '/' unless td.nil? or td.empty? or (td != '/' and td[-1] == ?/)
        td + self.escape(@prefix)
      end
      
      SPLIT_RE = %r|(?:(.*)/)?([^/]*)$|.freeze
      def self.splitrl(s)
        sub,opq,whole = split_riorl(s)
        if opq.nil? or opq.empty?
          []
        elsif bm = SPLIT_RE.match(opq)
          tdir = bm[1] unless bm[1].nil? or bm[1].empty?
          tpfx = bm[2] unless bm[2].nil? or bm[2].empty?
          [tpfx,tdir]
        else
          []
        end
      end
    end
    module Dir
      require 'rio/rl/path'
      RESET_STATE = RIO::RL::PathBase::RESET_STATE
      require 'tmpdir'
      class RL < RIO::RL::PathBase 
        RIOSCHEME = 'tempdir'
        DFLT_PREFIX = Temp::RL::DFLT_PREFIX
        DFLT_TMPDIR = Temp::RL::DFLT_TMPDIR
        attr_reader :prefix,:tmpdir,:tmprl
        def initialize(file_prefix=DFLT_PREFIX,temp_dir=DFLT_TMPDIR)
          #puts "initialize(#{file_prefix.inspect},#{temp_dir.inspect})"
          @prefix = file_prefix || DFLT_PREFIX
          @tmpdir = temp_dir || DFLT_TMPDIR
          require 'rio/tempdir'
          @td = ::Tempdir.new( @prefix.to_s, @tmpdir.to_s)
          super(@td.to_s)
        end
        def dir_rl() 
          #p "temp:dir_rl: #{self.uri.inspect}"
          RIO::Dir::RL.new(self.uri, {:fs => self.fs})
          #self 
        end
        SPLIT_RE = Temp::RL::SPLIT_RE
        def self.splitrl(s)
          Temp::RL.splitrl(s)
        end
      end
    end
    module File
      require 'rio/rl/path'
      RESET_STATE = 'Temp::Stream::Open'
      class RL < RIO::RL::PathBase 
        RIOSCHEME = 'tempfile'
        DFLT_PREFIX = Temp::RL::DFLT_PREFIX
        DFLT_TMPDIR = Temp::RL::DFLT_TMPDIR
        attr_reader :prefix,:tmpdir,:tmprl
        def initialize(file_prefix=DFLT_PREFIX,temp_dir=DFLT_TMPDIR)
          #puts "initialize(#{file_prefix.inspect},#{temp_dir.inspect})"
          @prefix = file_prefix || DFLT_PREFIX
          @tmpdir = temp_dir || DFLT_TMPDIR
          require 'tempfile'
          @tf = ::Tempfile.new( @prefix.to_s, @tmpdir.to_s)
          super(@tf.path)
        end
        def file_rl() 
        RIO::File::RL.new(self.uri,{:fs => self.fs})
          #self 
        end
        def open(mode='ignored')
          #p callstr('open',mode)
          @tf
        end
        def close 
          super
          @tf = nil
        end
        SPLIT_RE = Temp::RL::SPLIT_RE
        def self.splitrl(s)
          Temp::RL.splitrl(s)
        end
      end
    end
    require 'rio/state'
    class Reset < State::Base
      def initialize(*args)
        super
        #p args
        @tempobj = nil
      end
      def self.default_cx
        Cx::Vars.new( { 'closeoneof' => false, 'closeoncopy' => false } )
      end

      def check?() true end
      def mkdir(prefix=rl.prefix,tmpdir=rl.tmpdir)
        self.rl = RIO::Temp::Dir::RL.new(prefix, tmpdir)
        become 'Dir::Existing'
      end
#      def mkdir()
#        dir()
#      end
      def chdir(&block)
        self.mkdir.chdir(&block)
      end
      def file(prefix=rl.prefix,tmpdir=rl.tmpdir)
        self.rl = RIO::Temp::File::RL.new(prefix, tmpdir)
        become 'Temp::Stream::Open'
      end
      def scheme() rl.scheme() end
      def host() rl.host() end
      def opaque() rl.opaque() end
      def to_s() rl.url() end
      def exist?() false end
      def file?() false end
      def dir?() false end
      def open?() false end
      def closed?() true end
      def when_missing(sym,*args)
        #p @rl.scheme
        if @tempobj.nil?
          file()
        else
          gofigure(sym,*args)
        end
      end
    end
    require 'rio/stream/open'
    module Stream
      class Open < RIO::Stream::Open
        def iostate(sym)
          mode_('w+').open_.inout()
        end
#        def inout() stream_state('Temp::Stream::InOut') end
      end
#      require 'rio/stream'
#      class InOut < RIO::Stream::InOut
#        def base_state() 'Temp::Stream::Close' end
#      end
#      class Close < RIO::Stream::Close
#        def base_state() 'Temp::Reset' end
#      end

    end
  end
end
