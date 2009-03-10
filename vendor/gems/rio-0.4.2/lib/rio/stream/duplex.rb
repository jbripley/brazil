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


require 'rio/stream'
require 'rio/stream/open'

module RIO
  module Stream
    module Duplex
      module Ops
        module Output
          def wclose()
            #p "wclose #{self}"
            ioh.close_write
            return self.close.softreset if ioh.closed?
            self
          end
        end
      end
      class Open < RIO::Stream::Open
        def output() super.extend(Ops::Output) end
        def inout() super.extend(Ops::Output) end
      end
    end
  end
end
__END__
module RIO
  module Stream
    module Duplex

      class Input < RIO::Stream::Input
        include Ops::Input
      end

      class Output < RIO::Stream::Output
        include Ops::Output
      end
      
      class InOut < RIO::Stream::InOut
        include Ops::Output
        include Ops::Input
      end
    end
  end
end
