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
  module Filter #:nodoc: all
    def self.make_line_filter(sym)
      module_eval %{
        module #{sym.to_s.capitalize}
         module IOE
          def gets(*args) super.__send__(:#{sym}) end
          def readline(*args) super.__send__(:#{sym}) end
          def each_line(*args,&block) super { |l| yield l.__send__(:#{sym}) } end
          def readlines(*args) super.map{|el| el.__send__(:#{sym})} end
         end
         include IOE
        end
      }
    end
  end
end
module RIO
  module Cx
    module Methods
      require 'rio/context/cxx.rb'
      def self.make_filter_methods(sym)
        module_eval %{
          def #{sym}(arg=true,&block)
            cx['#{sym}'] = arg
            add_filter(Filter::#{sym.to_s.capitalize}) if arg and self.ioh
            each(&block) if block_given?
            self 
          end
          def #{sym}?() cxx?('#{sym}') end
          def no#{sym}(arg=false,&block) #{sym}(arg,&block) end
        }
      end
    end
  end
end

module RIO
  FILTER_SYMS = [:chomp, :strip, :lstrip, :rstrip]
  FILTER_SYMS.each { |sym|
    Filter.make_line_filter(sym)
    Cx::Methods.make_filter_methods(sym)
  }
  module Stream
    module Filters

      def add_line_filters()
        add_filter(Filter::Chomp) if chomp?
        add_filter(Filter::Strip) if strip?
        add_filter(Filter::Lstrip) if lstrip?
        add_filter(Filter::Rstrip) if rstrip?
      end

    end    
  end    
end

__END__
