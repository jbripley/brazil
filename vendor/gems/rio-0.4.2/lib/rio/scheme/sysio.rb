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


module RIO
  module SysIO #:nodoc: all
    require 'rio/rl/ioi'
    RESET_STATE = RL::IOIBase::RESET_STATE

    class RL < RL::SysIOBase
      RIOSCHEME = 'sysio'
      RIOPATH = RIO::RL::CHMAP.invert[RIOSCHEME].to_s.freeze
      def opaque() sprintf('0x%08x',self.ios.object_id) end
      def open(*args)
        super(*args)
      end
      # must be able to process both
      # parse('rio:sysio',ios)
      # parse('rio:sysio:0xHEXIOS')
      SPLIT_RE = %r|0x([0-9a-fA-F]+)$|
      def self.splitrl(s)
        sub,opq,whole = split_riorl(s)
        if bm = SPLIT_RE.match(opq)
          oid = bm[1].hex
          ios = ObjectSpace._id2ref(oid)
          [ios]
        end
      end
    end
  end
end
