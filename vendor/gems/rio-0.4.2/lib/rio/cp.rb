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


require 'rio/exception/copy'
class String #:nodoc: all
  def clear()
    self[0..-1] = ''
    self
  end
end
require 'rio/no_warn'

module RIO
  module Cp #:nodoc: all
    module Util
      module InOut
        def cpclose(*args,&block)
          if args.empty?
            oldcoc = self.cx.get_keystate('closeoncopy')
            self.cx['closeoncopy'] = false
            rtn = yield
            rtn.cx.set_keystate(*oldcoc)
            rtn.copyclose
          else
            if (ario = args[0]).kind_of?(Rio)
              oldcoc = ario.cx.get_keystate('closeoncopy')
              ario.cx['closeoncopy'] = false
              rtn = yield
              ario.cx.set_keystate(*oldcoc)
              ario.copyclose
              rtn
            else
              yield
            end
          end
        end
        def cpclose0(*args,&block)
          if args.empty?
            oldcoc,self.cx['closeoncopy'] = self.cx['closeoncopy'],false
            rtn = yield
            rtn.cx['closeoncopy'] = oldcoc
            rtn.copyclose
          else
            if (ario = args[0]).kind_of?(Rio)
              oldcoc,ario.cx['closeoncopy'] = ario.cx['closeoncopy'],false
              rtn = yield
              ario.cx['closeoncopy'] = oldcoc
              ario.copyclose
              rtn
            else
              yield
            end
          end
        end
      end
      module Input
        include InOut
        protected

        def cpto_obj_(obj)
          self.each do |el|
            obj << el
          end
        end

      end
      module Output
        include InOut

        protected

        def cpfrom_obj_(obj)
          obj.each do |el|
            self << el
          end
        end
        def cpfrom_array_(ary)
          #p "CPFROM_ARRAY_"
          ary.inject(self) { |anio,el| anio << el }
        end
      end
    end
  end
end

module RIO
  module Cp
    module Stream
      module Input
        include Util::Input
        def >>(arg)
          cpclose(arg) {
            apto_(arg)
          }
        end
        def >(arg)
          cpclose(arg) {
            cpto_(arg)
          }
        end
        alias :copy_to :>
        alias :append_to :>>

        protected
        def cpto_(arg)
          case arg 
          when ::Array then cpto_array_(arg.clear)
          when ::String then cpto_string_(arg.clear)
          when ::IO then cpto_obj_(arg)
          else cpto_rio_(arg,:<)
          end
          self
        end
        def apto_(arg)
          case arg
          when ::Array then cpto_array_(arg)
          when ::String then cpto_string_(arg)
          when ::IO then cpto_obj_(arg)
          else cpto_rio_(arg,:<<)
          end
          self
        end

        def cpto_array_(arg)
          cpto_obj_(arg)
        end
        def cpto_string_(arg)
          cpto_obj_(arg)
        end

        def cpto_rio_(arg,sym)
          ario = ensure_rio(arg)
          #p ario
          ario = ario.join(self.filename) if ario.dir?
          ario.cpclose {
            ario = ario.iostate(sym)
            self.copying(ario).each { |el|
#              p el
              ario.putrec(el)
#              ario << el
            }.copying_done(ario)
            ario
          }
        end
      end

      module Output
        include Util::Output
        def <<(arg) cpclose { cpfrom_(arg) } end
        def <(arg) cpclose { cpfrom_(arg) } end
        alias :copy_from :<
        alias :append_from :<<

        protected

        def cpfrom_(arg)
          case arg
          when ::Array then cpfrom_array_(arg)
          when ::IO then cpfrom_obj_(arg)
          when ::String then 
            self.put_(arg)
          else cpfrom_rio_(arg)
          end
          self
        end
        def cpfrom_rio_(arg)
          ario = ensure_rio(arg)
          #p ario.cx

          ario.copying(self).each { |el|
            self << el
          }.copying_done(self)
        end
      end
    end
  end
end
module RIO
  module Cp
    module File
      module Output
        include Util::Output
        def <(arg) cpclose { self.iostate(:<) < arg } end
        def <<(arg) cpclose { self.iostate(:<<) << arg } end
        alias :copy_from :<
        alias :append_from :<<
      end
      module Input
        include Util::Input
        def >(arg)  
          spcp(arg) || cpclose(arg) { self.iostate(:>) > arg  } 
        end
        def >>(arg) 
          spcp(arg) || cpclose(arg) { self.iostate(:>>) >> arg } 
        end
        alias :copy_to :>
        alias :append_to :>>
        def copy_as_file?(arg)
          arg.kind_of?(Rio) and arg.scheme == 'ftp'
        end
        def spcp(arg)
          if arg.kind_of?(Rio) and arg.scheme == 'ftp'
            arg.copy_from(new_rio(rl.path))
            self
          else
            nil
          end
        end
      end
    end
  end
end
module RIO
  module Cp
    module Open
      module Output
        include Util::Output
        def <(arg) cpclose { self.iostate(:<) < arg } end
        def <<(arg) cpclose { self.iostate(:<<) << arg } end
        alias :copy_from :<
        alias :append_from :<<
      end
      module Input
        include Util::Input
        def >(arg) cpclose(arg) { self.iostate(:>) > arg } end
        def >>(arg) cpclose(arg) { self.iostate(:>>) >> arg } end
        alias :copy_to :>
        alias :append_to :>>
      end
    end
  end
end
module RIO
  module Cp
    module Dir
      module Output
        include Util::Output
        def <<(arg)  cpfrom_(arg); self  end
        def <(arg)  cpfrom_(arg); self end
        alias :copy_from :<
        alias :append_from :<<

        private

        def cpfrom_(arg)
          case arg
          when ::Array then cpfrom_array_(arg)
          else cpfrom_rio_(ensure_rio(arg))
          end
        end
        def cpfrom_rio_(ario)
          dest = self.join(ario.filename)
          case
          when ario.symlink?
            ::File.symlink(ario.readlink.to_s,dest.to_s)
          when ario.dir?
            dest.mkdir
            ario.nostreamenum.each do |el|
              dest < el
            end
          else
            dest < ario
          end
        end
      end
      module Input
        include Util::Input
        def >>(arg)
          case arg
          when ::Array then cpto_obj_(arg)
          else cpto_rio_(ensure_rio(arg))
          end
          self
        end
        def >(arg)
          case arg
          when ::Array then cpto_obj_(arg.clear)
          else cpto_rio_(ensure_rio(arg))
          end
          self
        end
        alias :copy_to :>
        alias :append_to :>>

        protected

        def cpto_rio_(ario)
          ario = ario.join(self.filename) if ario.exist?
          nostreamenum.cpto_obj_(ario.mkdir)
        end
      end
    end
  end
end
module RIO
  module Cp
    module NonExisting
      module Output
        include Util::Output
        def <(arg)  
          if _switch_direction?(arg)
            #arg > self
            arg.copy_to(self)
            self
          else 
            _cpsrc(arg) < arg
          end
        end
        def <<(arg)  
          if _switch_direction?(arg)
            arg >> self
            self
          else 
            _cpsrc(arg) << arg
          end
        end
        alias :copy_from :<
        alias :append_from :<<

        private

        def _cpsrc(arg)
          if arg.kind_of?(::Array) and !arg.empty? and arg[0].kind_of?(Rio)
            self.mkdir.reset
          else
            self.nfile
          end
        end
        def _switch_direction?(arg)
          arg.kind_of?(Rio) and arg.dir? and !arg.stream_iter?
        end
      end
    end
  end
end

__END__
