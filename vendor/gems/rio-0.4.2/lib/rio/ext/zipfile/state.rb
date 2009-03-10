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


require 'rio/ops/path'
require 'rio/ops/dir'
require 'rio/filter/closeoneof'
require 'rio/ioh'
module RIO
  module ZipFile
    module State
      class Reset < RIO::State::Base
        def check?() true  end
        def when_missing(sym,*args)  
          if rl.to_s.empty?
            become('Dir::Open')
          else
            become('Path::Reset')
          end
          #gofigure(sym,*args) 
        end
      end
    end
  end
end
__END__
        class Base < State::Base
          include Ops::Path::Str
          def open?() !ioh.nil? end
        end

        class NonExisting < Base
          include Ops::Dir::NonExisting
          def check?() not self.exist?  end
          def when_missing(sym,*args)  gofigure(sym,*args) end
        end 
        
        class Existing < Base
          include Ops::Dir::Existing
          
          def check?() self.directory? end
          def when_missing(sym,*args) dopen() end
          
          protected
          
          def stream_rl_
            self.rl.dir_rl()
            #RIO::Dir::RL.new(self.to_uri, {:fs => self.fs})
          end
          
          public
          
          def dopen() 
            self.rl = self.stream_rl_
            become 'Dir::Open'
          end
        end 
        class Open < Base
          def check?() true  end
          def open(m=nil,*args) open_(*args) end
          def open_(*args) 
            unless open?
              self.ioh = self.rl.open()
            end
            self 
          end
          def when_missing(sym,*args) 
            nobj = open_.dstream() 
            return nobj unless nobj.nil?
            gofigure(sym,*args)
          end
          
          def dstream() 
            cl = 'Dir::Stream'
            #p "LOOP: retry: #{cx['retrystate'].inspect} => #{cl}" 
            return nil if cx['retrystate'] == cl
            cx['retrystate'] = cl
            
            become(cl)
          end
        end
        class Stream < Base
          include Ops::Dir::Stream
          def check?() open? end
          def when_missing(sym,*args) retryreset() end
          def base_state() 'Dir::Close' end
          def reset() self.close.softreset() end
          alias :copyclose :reset
        end
        class Close < Base
          def reopen(*args) self.close_.softreset.open(*args) end
          
          def close() 
            #p callstr('close')+" mode='#{mode?}' ioh=#{self.ioh} open?=#{open?}"
            return self unless self.open? 
            self.close_
            cx['retrystate'] = nil
            self
          end
          
          def close_() 
            #p callstr('close_')+" ioh=#{self.ioh} open?=#{open?}"
            return self unless self.open? 
            self.clear_selection
            self.ioh.close 
            self.ioh = nil
            self.rl.close
            self
          end
          protected :close_
          
          CX_ENTRY_SEL_KEYS = %w[nostreamenum entry_sel skip_args ss_skipped]
          def clear_selection()
            CX_ENTRY_SEL_KEYS.each { |k|
              cx.delete(k)
            }
            self
          end
          
          def check?() true end
          def when_missing(sym,*args) 
            #        p callstr('when_missing',sym,*args)
            self.close_.retryreset()
          end
        end
      end 
    end
  end
end # module RIO
