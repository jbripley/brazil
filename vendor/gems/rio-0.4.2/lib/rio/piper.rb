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
    class Base
      attr_reader :rios
      def initialize(r1,r2,*args)
        @rios = []
        add_arg(r1)
        add_arg(r2)
        args.each { |r|
          add_arg(r)
        }
      end
      def add_arg(arg)
        case arg
        when Base
          @rios += arg.rios
        when Rio
          case arg.scheme
          when 'cmdpipe'
            arg_piper = arg.rl.piper
            @rios += arg_piper.rios
          else
            @rios << arg
          end
        else
          raise ArgumentError,"Argument (#{arg}) is a #{arg.class}, should be a Rio or a Piper"
        end
      end
      def initialize_copy(*args)
        super
        @rios = @rios.map{ |r| r.clone }
      end
      def has_output_dest?
        case @rios[-1].scheme
        when 'cmdio' then false
        else true
        end
      end
      def new_with(*args)
        cp = self.clone
        args.each { |r|
          cp.push(r)
        }
        cp
      end
      def push(r)
        @rios << r
      end
      def run_to(r)
        @rios << r
        run
        self
      end
      def rd() @rios[-1] end
      def wr() @rios[0] end
      
      def run
        #dups = @rios.map { |r| r.clone }
        dups = @rios
        (1...dups.size-1).each { |i| dups[i].w! }
        (1...dups.size).each { |i|
          #p "#{dups[i-1].cx.inspect} > #{dups[i].cx.inspect}"
          dups[i-1] > dups[i]
          #p dups[i-1].closed?
        }
        dups.each { |r| r.close.softreset }
        dups[-1]
      end

      def runeth
        dups = @rios.map { |r| r.clone }

        (1...dups.size-1).each { |i| dups[i].w! }
        
        threads = []
        (1...dups.size).each { |i|
          threads << Thread.new(dups[i-1],dups[i]) { |src,dst|
            src > dst
          } 
        }
        threads.each { |aThread| aThread.join }
      end
    end
    
  end
end
