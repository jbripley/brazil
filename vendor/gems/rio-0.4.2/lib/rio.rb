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


require 'rio/version'
require 'rio/base'
require 'rio/def'
require 'rio/exception'

require 'forwardable'

$trace_states = false

require 'rio/kernel'
require 'rio/constructor'
require 'rio/construct'

require 'rio/const'

module RIO
  class Rio #:doc:
    require 'rio/local'
    include Local
    require 'rio/factory'
    protected

    attr_reader :state

    public

    # See RIO.rio
    def initialize(*args)
      @state = Factory.instance.create_state(*args)
    end

    def initialize_copy(*args)
      #p callstr("initialize_copy",args[0].inspect)
      super
      @state = Factory.instance.clone_state(@state)
    end

    # See RIO.rio
    def self.rio(*args,&block) # :yields: self
      ario = new(*args)
      if block_given?
        old_closeoncopy = ario.closeoncopy?
        begin
          yield ario.nocloseoncopy
        ensure
          ario.reset.closeoncopy(old_closeoncopy)
        end
      end
      ario
    end

    # Returns the string representation of a Rio that is used by Ruby's libraries.
    # For Rios that exist on the file system this is Rio#fspath.
    # For FTP and HTTP Rios, this is the URL.
    #
    #  rio('/a/b/c').to_s                    ==> "/a/b/c"
    #  rio('b/c').to_s                       ==> "b/c"
    #  rio('C:/b/c').to_s                    ==> "C:/b/c"
    #  rio('//ahost/a/b').to_s               ==> "//ahost/a/b"
    #  rio('file://ahost/a/b').to_s          ==> "//ahost/a/b"
    #  rio('file:///a/b').to_s               ==> "/a/b"
    #  rio('file://localhost/a/b').to_s      ==> "/a/b"
    #  rio('http://ahost/index.html').to_s   ==> "http://ahost/index.html"
    #
    def to_s() target.to_s end

    alias :to_str :to_s
    def dup
      #p callstr('dup',self)
      self.class.new(self.to_rl)
    end
    
    def method_missing(sym,*args,&block) #:nodoc:
      #p callstr('method_missing',sym,*args)
      
      result = target.__send__(sym,*args,&block)
      return result unless result.kind_of? State::Base and result.equal? target
      
      self
    end
    
    def inspect()
      cl = self.class.to_s[5..-1]
      st = state.target.class.to_s[5..-1]
      sprintf('#<%s:0x%x:"%s" (%s)>',cl,self.object_id,self.to_url,st)
    end
    

    protected

    def target()  #:nodoc:
      @state.target 
    end

    def callstr(func,*args) #:nodoc:
      self.class.to_s+'.'+func.to_s+'('+args.join(',')+')'
    end

  end # class Rio
end # module RIO
module RIO
  class Rio
    USE_IF = true #:nodoc:
    
    if USE_IF
      include Enumerable
      require 'rio/if'
      include RIO::IF::Grande
      require 'rio/ext/if'
      include RIO::IF::Ext
    end
  end
end

#require 'rio/ext/zipfile.rb'

if $0 == __FILE__
  eval DATA.read, nil, $0, __LINE__+4
end

__END__

puts
puts("Run the tests that came with the distribution")
puts("From the distribution directory use 'test/runtests.rb'")
puts
