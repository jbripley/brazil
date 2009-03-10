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


require 'rio/rl/ioi'
require 'stringio'
require 'rio/stream'
require 'rio/stream/open'

module RIO
  module StrIO #:nodoc: all
    RESET_STATE = 'StrIO::Stream::Open'

    class RL < RL::IOIBase 
      RIOSCHEME = 'strio'
      RIOPATH = RIO::RL::CHMAP.invert[RIOSCHEME].to_s.freeze
      attr_accessor :str
      def initialize(str="")
        @str = str
        super
      end

      def opaque() sprintf('0x%08x',@str.object_id) end

      # must be able to process both
      # parse('rio:strio',string)
      # parse('rio:strio:0xHEXIOS')
      SPLIT_RE = %r|0x([0-9a-fA-F]+)$|
      def self.splitrl(s)
        sub,opq,whole = split_riorl(s)
        if bm = SPLIT_RE.match(opq)
          oid = bm[1].hex
          str = ObjectSpace._id2ref(oid)
          [str]
        end
      end

      def open(m,*args)
        super(::StringIO.new(@str,m.to_s,*args))
      end
    end
    module Stream
      module Ops
        def string() ioh.string end
        def string=(p1) ioh.string = p1 end
      end
      class Open < RIO::Stream::Open
        def string=(p1) rl.str = p1 end
        def string() rl.str end
        def stream_state(*args) super.extend(Ops) end
      end
    end
  end
end
__END__
