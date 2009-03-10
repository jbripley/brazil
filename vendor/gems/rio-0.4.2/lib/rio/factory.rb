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


# class String
#  def to_fs
#    require 'rio/resource'
#    RIO::Resource::Pathname.new(self)
#  end
# end
require 'singleton'
require 'rio/handle'
require 'rio/rl/builder'
#require 'rio/state/machine'

module RIO
#   class StateDesc
#     attr_accessor :class_name,:class_file
#     def initialize(class_name,class_file)
#       @class_name = class_name
#       @class_file = class_file
#     end
#   end
#   module StateMap
#     class Base
#       STATE_FILE = {
#         'Path::Reset' => 'rio/path/reset',
#         'Path::Empty' => 'rio/path',
#         'Path::Str' => 'rio/path',
#         'Path::NonExisting' => 'rio/path',
        
#         'File::Existing' => 'rio/file',
#         'File::NonExisting' => 'rio/file',
        
#         'Dir::Existing' => 'rio/dir',
#         'Dir::Open' => 'rio/dir',
#         'Dir::Close' => 'rio/dir',
#         'Dir::Stream' => 'rio/dir',
#         'Dir::NonExisting' => 'rio/dir',
        
#         'Stream::Reset' => 'rio/stream',
#         'Stream::Open' => 'rio/stream/open',
#         'Stream::Input' => 'rio/stream',
#         'Stream::Output' => 'rio/stream',
#         'Stream::InOut' => 'rio/stream',
#         'Stream::Close' => 'rio/stream/open',
#       }
#       def class_name(state_name)
#         'State::' + state_name
#       end
#       def file_name(state_name)
#         STATE_FILE[state_name]
#       end
#       def path_reset() 'Path::Reset' end
#       def path_empty() 'Path::Empty' end
#       def path_str() 'Path::Str' end
#       def path_nonexisting() 'Path::NonExisting' end
#       def file_existing() 'File::Existing' end
#       def file_nonexisting() 'File::NonExisting' end
#       def dir_existing() 'Dir::Existing' end
#       def dir_open() 'Dir::Open' end
#       def dir_close() 'Dir::Close' end
#       def dir_stream() 'Dir::Stream' end
#       def dir_nonexisting() 'Dir::NonExisting' end
#       def stream_reset() 'Stream::Reset' end
#       def stream_open() 'Stream::Open' end
#       def stream_input() 'Stream::Input' end
#       def stream_output() 'Stream::Output' end
#       def stream_inout() 'Stream::InOut' end
#       def stream_close() 'Stream::Close' end
#     end
#   end
#   module Path
#     class StateMap < RIO::StateMap::Base
#       def stream_open() 'Path::Stream::Open' end
#     end
#   end
#   module Path
#     class StateMap < RIO::StateMap::Base
#       STATE_FILE = { 'Stream::Open' => 'rio/scheme/path' }
#       def stream_open() 'Path::Stream::Open' end
#     end
#   end
#   module CmdPipe
#     class StateMap < RIO::StateMap::Base
#       def stream_reset() 'CmdPipe::Stream::reset' end
#     end
#   end

#   module States
#     class Base
#     end
#   end

#   class StateMapper
#     include Singleton

#     STD_STATE_FILES = {
#       'Path::Reset' => 'rio/path/reset',
#       'Path::Empty' => 'rio/path',
#       'Path::Str' => 'rio/path',
#       'Path::NonExisting' => 'rio/path',

#       'File::Existing' => 'rio/file',
#       'File::NonExisting' => 'rio/file',

#       'Dir::Existing' => 'rio/dir',
#       'Dir::Open' => 'rio/dir',
#       'Dir::Close' => 'rio/dir',
#       'Dir::Stream' => 'rio/dir',
#       'Dir::NonExisting' => 'rio/dir',

#       'Stream::Reset' => 'rio/stream',
#       'Stream::Open' => 'rio/stream/open',
#       'Stream::Input' => 'rio/stream',
#       'Stream::Output' => 'rio/stream',
#       'Stream::InOut' => 'rio/stream',
#       'Stream::Close' => 'rio/stream/open',
#     }
#     SCHEME_STATE_FILES = {
#       'Stream::Duplex::Open' => 'rio/stream/duplex',

#       #'Path::Stream::Open' => 'rio/scheme/path',

#       #'StrIO::Stream::Open' => 'rio/scheme/strio',

#       #'Null::Stream::Open' => 'rio/scheme/null',

#       #'CmdPipe::Stream::Reset' => 'rio/scheme/cmdpipe',

#       #'HTTP::Stream::Input' => 'rio/scheme/http',
#       #'HTTP::Stream::Open' => 'rio/scheme/http',

#       'Temp::Reset' => 'rio/scheme/temp',
#       'Temp::Stream::Open' => 'rio/scheme/temp',

#       'Ext::YAML::Doc::Existing' => 'rio/ext/yaml/doc',
#       'Ext::YAML::Doc::Open' => 'rio/ext/yaml/doc',
#       'Ext::YAML::Doc::Stream' => 'rio/ext/yaml/doc',
#       'Ext::YAML::Doc::Close' => 'rio/ext/yaml/doc',
#     }
#     def initialize()
#       @state_cache = {}
#     end
#     def scheme_states()
#       { 
#         'path' => { 'Stream::Open' => 'Path::Stream::Open' },
#         'file' => { 'Stream::Open' => 'Path::Stream::Open' },
#         'strio' => { 'Stream::Open' => 'StrIO::Stream::Open' },
#         'cmdpipe' => { 'Stream::Reset' => 'CmdPipe::Stream::Reset' },
#         'http' => {'Stream::Input' => 'HTTP::Stream::Input', 
#                    'Stream::Open' => 'HTTP::Stream::Open' },
#       }
#     end
#     def known?(state_name)
#       STD_STATE_FILES.has_key?(state_name) or SCHEME_STATE_FILES.has_key?(state_name)
#     end
#     def std_state_name(state_name)
#       case 
#       when STD_STATE_FILES.has_key?(state_name) then 'State::'+state_name
#       when SCHEME_STATE_FILES.has_key?(state_name) then state_name
#       else raise ArgumentError,"Unknown State Name (#{state_name})" 
#       end
#     end
#     def mode_mixins()
#       { 
#         'Stream::Input' => { 'splitlines' => 'Ext::SplitLines::Stream::Input', },
#         'Stream::Output' => { 'splitlines' => 'Ext::SplitLines::Stream::Output', },
#       }
#     end
#     def mode_state_name(state_name,cx)
#       mixins = mode_mixins()
#       return state_name unless mixins.has_key?(state_name)
#       modes = mstates[state_name]
#       for mode in modes.keys
#         next unless cx[mode]
#         return modes[mode]
#       end
#     end

#     def scheme_state_name(state_name,scheme)
#       schemes = scheme_states()
#       if schemes.has_key?(scheme)
#         states = schemes[scheme]
#         if states.has_key?(state_name)
#           return scheme_states[scheme][state_name]
#         end
#       end
#       return std_state_name(state_name)
#     end
#     def state_file(state_name,rio_handle)
#       case 
#       when STD_STATE_FILES.has_key?(state_name) then STD_STATE_FILES[state_name]
#       when SCHEME_STATE_FILES.has_key?(state_name) then SCHEME_STATE_FILES[state_name]
#       else raise ArgumentError,"Unknown State Name (#{state_name})" 
#       end
#     end
#     def state2class(state_name,rio_handle=nil)
#       scheme = rio_handle.rl.scheme unless rio_handle.nil?
#       state = nil
#       if scheme_cache = @state_cache[scheme]
#         return state if state = scheme_cache[state_name]
#       end
#       mapped_name = rio_handle.nil? ? std_state_name(state_name) : scheme_state_name(state_name,rio_handle.rl.scheme)
#       if self.known?(state_name)
#         require self.state_file(state_name,rio_handle)
#         @state_cache[scheme] ||= {}
#         @state_cache[scheme][state_name] = RIO.module_eval(mapped_name)
#         return @state_cache[scheme][state_name]
#       else
#         raise ArgumentError,"Unknown State Name (#{state_name})" 
#       end
#     end
                   
#   end


  class Factory  #:nodoc: all
    include Singleton
    def initialize()
      @ss_module = {}
      @reset_class = {}
      @state_class = {}
      @ss_class = {}
    end

    def subscheme_module(sch)
      #p "subscheme_module(#{sch})"
      @ss_module[sch] ||= case sch
                          when 'file','path'
                            require 'rio/scheme/path'
                            Path
                          when 'zipfile'
                            require 'rio/ext/zipfile/rl'
                            ZipFile::RootDir
                          when 'stdio','stdin','stdout'
                            require 'rio/scheme/stdio'
                            StdIO
                          when 'stderr'
                            require 'rio/scheme/stderr'
                            StdErr
                          when 'null'
                            require 'rio/scheme/null'
                            Null
                          when 'tempfile'
                            require 'rio/scheme/temp'
                            Temp::File
                          when 'temp'
                            require 'rio/scheme/temp'
                            Temp
                          when 'tempdir'
                            require 'rio/scheme/temp'
                            Temp::Dir
                          when 'strio','stringio','string'
                            require 'rio/scheme/strio'
                            StrIO
                          when 'cmdpipe'
                            require 'rio/scheme/cmdpipe'
                            CmdPipe
                          when 'aryio'
                            require 'rio/scheme/aryio'
                            AryIO
                          when 'http','https'
                            require 'rio/scheme/http'
                            HTTP
                          when 'ftp'
                            require 'rio/scheme/ftp'
                            FTP
                          when 'tcp'
                            require 'rio/scheme/tcp'
                            TCP
                          when 'sysio'
                            require 'rio/scheme/sysio'
                            SysIO
                          when 'fd'
                            require 'rio/scheme/fd'
                            FD
                          when 'cmdio'
                            require 'rio/scheme/cmdio'
                            CmdIO
                          else
                            require 'rio/scheme/path'
                            Path
                          end
    end

    STATE2FILE = {
      'Path::Reset' => 'rio/path/reset',
      'Path::Empty' => 'rio/path',
      'Path::Str' => 'rio/path',
      'Path::NonExisting' => 'rio/path',

      'File::Existing' => 'rio/file',
      'File::NonExisting' => 'rio/file',

      'Dir::Existing' => 'rio/dir',
      'Dir::Open' => 'rio/dir',
      'Dir::Close' => 'rio/dir',
      'Dir::Stream' => 'rio/dir',
      'Dir::NonExisting' => 'rio/dir',

      'Stream::Close' => 'rio/stream/open',
      'Stream::Reset' => 'rio/stream',
      'Stream::Open' => 'rio/stream/open',
      'Stream::Input' => 'rio/stream',
      'Stream::Output' => 'rio/stream',
      'Stream::InOut' => 'rio/stream',

      'Stream::Duplex::Open' => 'rio/stream/duplex',

      'Path::Stream::Open' => 'rio/scheme/path',

      'StrIO::Stream::Open' => 'rio/scheme/strio',

      'Null::Stream::Open' => 'rio/scheme/null',

      'CmdPipe::Stream::Reset' => 'rio/scheme/cmdpipe',

      'HTTP::Stream::Input' => 'rio/scheme/http',
      'HTTP::Stream::Open' => 'rio/scheme/http',

      'Temp::Reset' => 'rio/scheme/temp',
      'Temp::Stream::Open' => 'rio/scheme/temp',

      'Ext::YAML::Doc::Existing' => 'rio/ext/yaml/doc',
      'Ext::YAML::Doc::Open' => 'rio/ext/yaml/doc',
      'Ext::YAML::Doc::Stream' => 'rio/ext/yaml/doc',
      'Ext::YAML::Doc::Close' => 'rio/ext/yaml/doc',


    }
    def riorl_class(sch)
      subscheme_module(sch).const_get(:RL) 
    end

    def reset_state(rl)
      mod = subscheme_module(rl.scheme)
      mod.const_get(:RESET_STATE) unless mod.nil?
    end

    def state2class(state_name)
      return @state_class[state_name] if @state_class.has_key?(state_name)
      if STATE2FILE.has_key?(state_name)
        require STATE2FILE[state_name]
        return @state_class[state_name] = RIO.module_eval(state_name)
      else
        raise ArgumentError,"Unknown State Name (#{state_name})" 
      end
    end
    def try_state_proc1(current_state,rio_handle)
      #p "try_state_proc cur=#{current_state}[#{current_state.class}] han=#{rio_handle}[#{rio_handle.class}]"
      proc { |new_state_name|
#        new_state_class = state2class(new_state_name)
        _change_state(state2class(new_state_name,rio_handle),current_state,rio_handle)
      }
    end
    def try_state_proc(current_state,rio_handle)
      proc { |new_state_name|
#        new_state_class = state2class(new_state_name)
        _change_state(state2class(new_state_name),current_state,rio_handle)
      }
    end

    def _change_state(new_state_class,current_state,rio_handle)
      # wipe out the reference to this proc so GC can get rid of rsc
      current_state.try_state = proc { p "try_state for "+current_state.to_s+" used already??" }
      new_state = new_state_class.new_other(current_state)
      new_state.try_state = try_state_proc(new_state,rio_handle)
      
      rio_handle.target = new_state
      return rio_handle.target
    end
    private :_change_state

    # factory creates a state from args
    def create_state1(*args)
      riorl = RIO::RL::Builder.build(*args)
      create_handle(state2class(reset_state(riorl)).new(riorl))
    end
    def create_state(*args)
      riorl = RIO::RL::Builder.build(*args)
      create_handle(state2class(reset_state(riorl)).new(riorl))
    end
    def clone_state(state)
      create_handle(state.target.clone)
    end
    def create_handle(new_state)
      hndl = Handle.new(new_state)
      new_state.try_state = try_state_proc(new_state,hndl)
      hndl
    end

  end
end


if $0 == __FILE__
  eval DATA.read, nil, $0, __LINE__+4
end

__END__

require 'test/unit'

