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


require 'rio/exception/state'
require 'rio/context'
require 'rio/context/methods'
require 'rio/ext'
require 'rio/symantics'
require 'rio/filter'
require 'rio/fs/native'

module RIO

                   
  module State #:nodoc: all
    # = State
    # the abstract state from which all are derived
    # this level handles 
    # * some basic house keeping methods
    # * the methods to communicate with the rio object
    # * the state changing mechanism
    # * and some basic error handling stubs
    class Base
      KIOSYMS = [:gets,:getc,:open,:readline,:readlines,:chop,:to_a,:putc,:puts,:print,:printf,
                 #:split,
                 :=~,:===,:==,:eql?,:sub,:sub!,:gsub,:gsub!,:load]
      @@kernel_cleaned ||= KIOSYMS.each { |sym| undef_method(sym) } 
      undef_method(:rio)
    end 
    
    class Base
      attr_accessor :try_state
      #attr_accessor :handled_by

      attr_accessor :rl
      attr_accessor :ioh

      attr_accessor :cx

      # Context handling
      include Cx::Methods
      include RIO::Ext::Cx

      
      def initialize(rl=nil,cx=nil,ioh=nil)
        cx ||= self.class.default_cx
        _init(rl,cx,ioh)
        #        @handled_by = self.class.to_s
      end
      
      def _init(riorl,cntx,iohandle=nil)
        @rl = riorl
        @cx = cntx
        @ioh = iohandle
#        raise Exception::FailedCheck.new(self) unless check?
        self
      end
      private :_init

      def initialize_copy(*args)
        #p callstr('initialize_copy',args[0].inspect)
        super
        @rl = @rl.clone unless @rl.nil?
        @cx = @cx.clone unless @cx.nil?
        @ioh = @ioh.clone unless @ioh.nil?
        # @fs = @fs
      end

      def self.default_cx
         Cx::Vars.new( { 'closeoneof' => true, 'closeoncopy' => true } )
      end
      def self.new_other(other)
        new(other.rl,other.cx,other.ioh)
      end

      alias :ior :ioh
      alias :iow :ioh




      # Section: State Switching

      # the method for changing states
      # it's job is create an instance of the next state
      # and change the value in the handle that is shared with the rio object
      def become(new_class,*args)
        p "become : #{self.class.to_s} => #{new_class.to_s} (#{self.mode?})" if $trace_states
        #p "BECOME #{new_class}: #{cx['ss_type']}"
        return self if new_class == self.class

        begin
          new_state = try_state[new_class,*args]
        rescue Exception::FailedCheck => ex
          p "not a valid "+new_class.to_s+": "+ex.to_s+" '"+self.to_s+"'"
          raise
        end
        became(new_state)
        new_state
      end
      def became(obj)
        #RIO::Ext.became(obj)
      end
      def method_missing_trace_str(sym,*args)
        "missing: "+self.class.to_s+'['+self.to_url+" {#{self.rl.fs}}"+']'+'.'+sym.to_s+'('+args.join(',')+')'
        #"missing: "+self.class.to_s+'['+self.to_url+""+']'+'.'+sym.to_s+'('+args.join(',')+')'
      end

      def method_missing(sym,*args,&block)
        p method_missing_trace_str(sym,*args) if $trace_states

        obj = when_missing(sym,*args)
        raise RuntimeError,"when_missing returns nil" if obj.nil?
        obj.__send__(sym,*args,&block) #unless obj == self
      end
      
      def when_missing(sym,*args) gofigure(sym,*args) end


      def base_state() Factory.instance.reset_state(@rl) end

      def softreset 
        #p "softreset(#{self.class}) => #{self.base_state}"
        cx['retrystate'] = nil
        become(self.base_state) 
      end
      def retryreset 
        #p "retryreset(#{self.class}) => #{self.base_state}"
        become(self.base_state) 
      end
      def reset
        softreset()
      end

      # Section: Error Handling
      def gofigure(sym,*args)
        cs = "#{sym}("+args.map{|el| el.to_s}.join(',')+")"
        msg = "Go Figure! rio('#{self.to_s}').#{cs} Failed"
        error(msg,sym,*args)
      end

      def error(emsg,sym,*args)
        require 'rio/state/error'
        Error.error(emsg,self,sym,*args)
      end

      def to_rl() self.rl.rl end
      def fs() self.rl.fs end

      extend Forwardable
      def_instance_delegators(:rl,:path,:to_s,:fspath,:urlpath,:length)

      def ==(other) @rl == other end
      def ===(other) self == other end
      def =~(other) other =~ self.to_str end
      def to_url() @rl.url end
      def to_uri() @rl.uri end
      alias to_str to_s

      def hash() @rl.to_s.hash end
      def eql?(other) @rl.to_s.eql?(other.to_s) end

      def stream?() false end

      # Section: Rio Interface
      # gives states the ability to create new rio objects
      # (should this be here???)
      def new_rio(arg0,*args,&block)
        Rio.rio(arg0,*args,&block)
      end
      def new_rio_cx(*args)
        n = new_rio(*args)
        n.cx = self.cx.bequeath(n.cx)
        n
      end
      def clone_rio()
        cp = Rio.new(self.rl)
        cp.cx = self.cx.clone
        cp.ioh = self.ioh.clone unless self.ioh.nil?
        cp.rl = self.rl.clone
        cp
      end
      
      def ensure_rio(arg0)
        case arg0
        when RIO::Rio then arg0
        when RIO::State::Base then arg0.clone_rio
        else new_rio(arg0)
        end
      end
      def ensure_cmd_rio(arg)
        case arg
        when ::String then new_rio(:cmdio,arg)
        when ::Fixnum then new_rio(arg)
        when Rio then arg.clone
        else ensure_rio(arg)
        end
      end

      include Symantics

      def callstr(func,*args)
        self.class.to_s+'['+self.to_url+']'+'.'+func.to_s+'('+args.join(',')+')'
      end

    end

  end

end # module RIO
