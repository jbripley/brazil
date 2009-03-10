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


require 'rio/cp'

module RIO
  module Impl
    module U
      def self.copy_stream(s,d)
        require 'fileutils'
        ::FileUtils::copy_stream(s,d)
      end
    end
  end
end
module RIO
  module Ops
    module Stream
      module Output
        include Status
        require 'rio/ops/stream/write'
        include Ops::Stream::Write
        include Cp::Stream::Output
        def putrec(rec,*args)
          self.put_(rec,*args)
          self
        end

        def putrec!(rec,*args)
          rtn_close { self.put_(rec,*args) }
        end

        def close_write(&block)
          self.iow.close_write
          each(&block) if block_given?
          self
        end

        def wclose
          self.close.softreset
        end

        def then_close(*args,&block) 
          rtn = yield(*args)
          wclose
          rtn
        end

        def rtn_close(*args,&block) 
          yield(*args)
          wclose
        end

        def copyclose()
          #p "#{callstr('copyclose')} closeoncopy=#{cx['closeoncopy']} iow=#{iow}"
          #raise RuntimeError,"copclose"
          if cx['closeoncopy']
            wclose
          else
            self
          end
        end

      end
    end
  end
end
