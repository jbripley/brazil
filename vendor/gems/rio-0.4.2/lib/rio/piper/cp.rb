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
  module Piper #:nodoc: all
    module Cp
      module Util

        protected

        def process_pipe_arg_(npiper)
          end_rio = npiper.rios[-1]
          case end_rio.scheme
          when 'cmdio'
            new_rio(:cmdpipe,npiper)
          when 'cmdpipe'
            if end_rio.has_output_dest?
              npiper.run
              end_rio
            else
              new_rio(:cmdpipe,npiper)
            end
          else
            npiper.run
            end_rio
          end
        end

      end
      module Input
        include Util
        def |(arg)
          #p "#{self} | #{arg}"
          ario = ensure_cmd_rio(arg)
          #cp = Rio.new(self.rl)
          #cp.cx = self.cx.clone
          #cp.ioh = self.ioh.clone unless self.ioh.nil?
          cp = clone_rio()
          npiper = Piper::Base.new(cp,ario)
          process_pipe_arg_(npiper)
        end
      end
    end
  end
end

__END__
