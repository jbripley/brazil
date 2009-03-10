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
  module Cx #:nodoc: all
    class  Vars
      def initialize(h=Hash.new,exp=Hash.new)
        @values = h
        @explicit = exp
      end
      def initialize_copy(*args)
        super
        @values = @values.clone
        @explicit = @explicit.clone
      end
      BEQUEATH_KEYS = %w[chomp strip rename closeoneof closeoncopy]
      #BEQUEATH_KEYS = %w[chomp strip rename]
      def bequeath(oldcx)
        keys = BEQUEATH_KEYS
        ncx = oldcx.clone
        #ncx = Vars.new
        keys.each { |key|
          ncx.set_(key,@values[key]) if @values.has_key?(key)
        }
        ncx
      end
      def delete(key)
        @values.delete(key)
        @explicit.delete(key)
      end
      def get_keystate(key)
        key_exists = @values.key?(key)
        key_val = @values[key]
        key_explicit = @explicit[key]
        [key,key_exists,key_val,key_explicit]
      end
      def set_keystate(key,key_exists,key_val,key_explicit)
        if(key_exists) then
          @values[key] = key_val
          @explicit[key] = key_explicit
        else
          @values.delete(key)
          @explicit.delete(key)
        end
      end
      def set_(key,val)
        @values[key] = val unless @explicit[key]
      end
      def []=(key,val)
        @values[key] = val
        @explicit[key] = true
      end
      def inspect()
        str = sprintf('#<Cx:0x%08x ',self.object_id)
        vary = {}
        @values.each { |k,v|
          name = k
          name += '_' unless @explicit[k]
          if v == true
            vary[name] = nil
          elsif v == false
            vary[name] = 'false'
          else 
            vary[name] = v
          end
        }
        strs = []
        vary.each { |k,v|
         if v.nil?
           strs << k
         else
           strs << "#{k}(#{v.inspect})"
         end
        }
        str += strs.join(',')
        str +='>'
        str
      end

      extend Forwardable
      def_instance_delegators(:@values,:[],:has_key?,:values_at,:keys)
    end
  end
end  
