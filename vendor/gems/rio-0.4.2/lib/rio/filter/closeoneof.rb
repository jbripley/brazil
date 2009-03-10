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
  module Filter
    module CloseOnEOF
      attr_accessor :oncloseproc
      attr_accessor :autoclosed
      def self.extend_object(ioh)
        super
        ioh.autoclosed = false
        ioh.oncloseproc = nil
      end
      def autoclosed?
        @autoclosed
      end
#       def close_on_eof_raise(&block)
#         begin
#           rtn = yield
#         rescue EOFError
#           close_on_eof_(rtn)
#           raise
#         end
#         rtn
#       end
      def close_on_eof(&block)
        #p callstr('close_on_eof',rtn)
        rtn = yield
        if handle.eof?
          close_on_eof_(rtn)
        end
        rtn
      end
      def close_on_eof1(&block)
        #p callstr('close_on_eof',rtn)
        if handle.eof?
          close_on_eof_(nil)
          yield
        else
          yield
        end
      end
      def close_on_eof_(rtn)
        #p callstr('close_on_eof_',rtn)
        unless @autoclosed or closed?
          #handle.close()
          @oncloseproc.call() unless @oncloseproc.nil?
          @autoclosed = true
        end
        rtn
      end
        
      def each_line(*args,&block)     close_on_eof{super} end
      def each_byte(*args,&block)     close_on_eof{super} end
      def each_bytes(nb,*args,&block) close_on_eof{super} end

      def readline(*args)             close_on_eof{super} end

      def readchar(*args)             close_on_eof{super} end
      def gets(*args)                 close_on_eof{super} end
      def readlines(*args)            close_on_eof{super} end

      def read(*args)                 close_on_eof{super} end

      def copy_stream(dst)            close_on_eof{super} end
      def contents()                  close_on_eof{super} end
    end
  end
end
__END__
