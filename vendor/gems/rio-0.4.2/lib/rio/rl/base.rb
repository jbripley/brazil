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


require 'uri'
require 'rio/local'
require 'rio/uri/file'
require 'rio/rl/chmap'
require 'rio/rl/fs2url'

module RIO
  module RL

    SCHEME = 'rio'
    SCHC = SCHEME+':'
    SPLIT_RIORL_RE = %r{\A([a-z][a-z]+)(?:(:)(.*))?\Z}.freeze
    SUBSEPAR = ':'

    class Base
      attr_accessor :fs
      def initialize(*args)
        #p callstr('Base#initialize',*args)
        @fs = openfs_
      end
      def initialize_copy(cp)
        super
      end
      def openfs_() 
        nil 
      end
      def self.subscheme(s)
        /^rio:([^:]+):/.match(s)[1]
      end

      def self.split_riorl(s)
        body = s[SCHC.length...s.length]
        m = SPLIT_RIORL_RE.match(body) 
        return [] if m.nil?
        return m[1],m[3],m[0]
      end

      def self.is_riorl?(s)
        s[0...SCHC.length] == SCHC
      end

      def self.parse(*a)
        parms = splitrl(a.shift) || []
        new(*(parms+a))
      end

      def rl() SCHC+self.url end

#      def riorl() SCHC+self.url end

      def to_s() self.fspath || '' end
      def ==(other) self.to_s == other.to_s end
      def ===(other) self == other end
      def =~(other) other =~ self.to_str end
      def length() self.to_s.length end

      def fspath() nil end
      def path() nil end

      def to_rl() self.rl end

      def url() self.scheme+SUBSEPAR+self.opaque end
      def close() 
        #p "Closing RL #{self}"
        nil 
      end

      def fs2url(pth) RL.fs2url(pth) end
      def url2fs(pth) RL.url2fs(pth) end
      def escape(pth,esc=RL::ESCAPE)
        RL.escape(pth,esc)
      end
      def unescape(pth)
        RL.unescape(pth)
      end

      def callstr(func,*args)
        self.class.to_s+'['+self.to_s+']'+'.'+func.to_s+'('+args.join(',')+')'
      end
    end
  end
end
