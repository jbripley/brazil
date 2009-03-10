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


# module RIO
#   module Impl
#     module U
#       def self.readlink(s,*args) ::File.readlink(s,*args) end
#       def self.lstat(s,*args) ::File.lstat(s,*args) end
#     end
#   end
# end
module RIO
  module Ops
    module Symlink
      module ExistOrNot
        def readlink(*args) new_rio(fs.readlink(self.to_s,*args)) end
        def lstat(*args) fs.lstat(self.to_s,*args) end

      end
      module Existing
        include ExistOrNot
        def delete(*args)
          rm(*args)
        end
        def unlink(*args)
          delete(*args)
        end
        def delete!(*args)
          delete(*args)
        end
      end
      module NonExisting
        include ExistOrNot
        def mkdir()
          rtn_reset {
            self.readlink.mkdir
          }
        end
        def mkpath()
          rtn_reset {
            self.readlink.mkpath
          }
        end
      end
    end
  end
end
