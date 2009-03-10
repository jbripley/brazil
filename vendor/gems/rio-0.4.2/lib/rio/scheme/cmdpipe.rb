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
require 'rio/stream'
require 'rio/stream/open'
require 'rio/piper'

module RIO
  module CmdPipe #:nodoc: all
    RESET_STATE = 'CmdPipe::Stream::Reset'

    class RL < RL::IOIBase 
      RIOSCHEME = 'cmdpipe'
      RIOPATH = RIO::RL::CHMAP.invert[RIOSCHEME].to_s.freeze
      attr_reader :piper

      def initialize(*args)
        case args[0]
        when CmdPipe::RL
          @piper = args[0].piper
        when Piper::Base 
          @piper = args[0]
        else
          @piper = Piper::Base.new(*args)
        end
        super
      end
      def initialize_copy(*args)
        super
        @piper = @piper.clone
      end
      def opaque()
        #p callstr('opaque')
        @piper.rios.map{|cmd| URI.escape(cmd.to_s,RIO::RL::ESCAPE)}.join('|')
      end
      def to_s()
        return "" if @piper.rios.nil? or @piper.rios.empty?
        @piper.rios.map{|cmd| cmd.to_s}.join('|')
      end
      def open(m,*args)
        @outp = rio(?")
        rp = Piper::Base.new(@piper,@outp)
        rp.run
        @outp
      end
      SPLIT_RE = %r|(?:([^\|]+)(?:\|([^\|]+))*)?$|.freeze
      def self.splitrl(s)
        #p "S='#{s}'"
        sub,opq,whole = split_riorl(s)
        if opq.nil? or opq.empty?
          []
        elsif bm = SPLIT_RE.match(opq)
          escaped_cmd = bm[1]
          cmd = URI.unescape(escaped_cmd)
          [cmd]
        else
          []
        end
      end
    end
    module Stream
      class Reset < State::Base
        include Ops::Path::URI
        include Piper::Cp::Util
        def check?() true end
        def |(arg)
          ario = ensure_cmd_rio(arg)
          npiper = Piper::Base.new(self.rl.piper,ario)
          process_pipe_arg_(npiper)
        end
        def piper
          self.rl.piper
        end
        def has_output_dest?
          piper.has_output_dest?
        end
#        def when_missing(sym,*args)
#          #p callstr('when_missing',sym,*args)
#          become 'CmdPipe::Stream::Open'
#        end
      end
    end
  end
end
