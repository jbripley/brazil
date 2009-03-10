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


require 'rio/grande'
require 'rio/cp'
require 'rio/ops/either'

module RIO
#   module Impl
#     module U
#       def self.rmdir(s) ::Dir.rmdir(s.to_s) end
#       def self.mkdir(s,*args) ::Dir.mkdir(s.to_s,*args) end
#       def self.chdir(s,&block) ::Dir.chdir(s.to_s,&block) end
#       def self.foreach(s,&block) ::Dir.foreach(s.to_s,&block) end
#       def self.entries(s) ::Dir.entries(s.to_s) end
#       def self.cp_r(s,d)
#         require 'fileutils'
#         ::FileUtils.cp_r(s.to_s,d.to_s)
#       end
#       def self.find(s,&block) 
#         require 'find'
#         Find.find(s.to_s) do |f|
#           yield f
#         end
#       end
#       def self.glob(gstr,*args,&block) 
#         ::Dir.glob(gstr,*args,&block) 
#       end
#       def self.rmtree(s)
#         require 'fileutils'
#         ::FileUtils.rmtree(s.to_s)
#       end
#       def self.mkpath(s) 
#         require 'fileutils'
#         ::FileUtils.mkpath(s.to_s) 
#       end
#     end
#   end

  module Ops
    module Dir
      module ExistOrNot
        include RIO::Ops::FileOrDir::ExistOrNot
      end
    end
  end
  module Ops
    module Dir
      module NonExisting
        include ExistOrNot
        include ::RIO::Ops::FileOrDir::NonExisting
        def mkdir(*args)
          fs.mkdir(self.to_s,*args); 
          softreset() 
        end
        def mkpath(*args) 
          #          p callstr('mkpath',*args)
          fs.mkpath(self.to_s,*args); 
          #fs.mkpath(self,*args); 
          softreset()
        end
        def rmdir(*args) self end
        def rmtree(*args) self end
        alias :delete :rmdir
        alias :unlink :rmdir
        alias :delete! :rmtree
      end
    end
  end
end
module RIO
  module Ops
    module Dir
      module Existing
        include ExistOrNot
        include FileOrDir::Existing
        include Cp::Dir::Input
        include Cp::Dir::Output
      end
    end
  end
end



module RIO
  module Ops
    module Dir
      module Existing
        def selective?
          %w[entry_sel stream_sel stream_nosel].any? { |k| cx.has_key?(k) }
        end
        def empty?() self.to_a.empty? end
        def mkdir(*args) self end
        def mkpath(*args) self end
        def rmdir(*args) 
          fs.rmdir(self.to_s,*args); 
          softreset()
        end
        def rmtree(*args) fs.rmtree(self.to_s,*args); softreset() end
        def rm(*args) fs.rm(self.to_s,*args); softreset() end
        
        alias :delete :rmdir
        alias :unlink :delete
        alias :delete! :rmtree

        def chdir(*args,&block) 
          if block_given?
            fs.chdir(self.to_s,*args) { |dir|
              yield new_rio('.')
            }
          else
            fs.chdir(self.path,*args)
            return new_rio('.')
          end
          self
        end
        
        def ensure_rio_cx(arg0)
          return arg0 if arg0.kind_of?(::RIO::Rio)
          new_rio_cx(arg0)
        end

        def glob(*args,&block) 
          chdir do
            if block_given?
              fs.glob(*args) do |ent|
                yield new_rio_cx(self,ent)
              end
            else
              return fs.glob(*args).map { |ent| new_rio_cx(self,ent) }
            end
          end
        end

      end
    end
  end
  module Ops
    module Dir
      module Stream
        include FileOrDir::Existing
        include Enumerable
        include Grande
        include Cp::Dir::Input
        include Cp::Dir::Output
        public

        def entries(*args,&block) _set_select('entries',*args,&block) end

        def each(*args,&block)
          each_(*args,&block)
        end


        def read() 
          read_()
        end

        def get()
          self.each_ent_ { |d|
            return d
          }
          return nil
        end

        def rewind() ioh.rewind(); self end
        def seek(integer) ioh.seek(integer); self end

        extend Forwardable
        def_instance_delegators(:ioh,:tell,:pos,:pos=)

        protected
        require 'rio/entrysel'
      end
    end
  end
end
module RIO
  module Ops
    module Dir
      module Stream

        protected

        def read_() 
          if ent = ioh.read()
            new_rio_cx(ent) 
          else
            self.close if closeoneof?
            nil
          end
        end
        def handle_skipped
          #return unless cx.has_key?('skip_args') or cx['skipping']
          return self unless cx.has_key?('skip_args')
          args = cx['skip_args'] || []
          self.skipentries(*args)
        end
        def ent_to_rio_(ent,indir)
          #p "ent_to_rio: ent=#{ent.inspect} indir=#{indir}"
          if ent.kind_of?(RIO::Rio)
            oldpath = ent.to_s
            ent.rl.urlpath = indir.to_s
            ent.join!(oldpath)
            ent.cx = self.cx.bequeath(ent.cx)
            ent
          else
            # KIT: should this be RL.fs2url(ent) ???
            if indir
              new_rio_cx(indir.rl,ent)
            else
              new_rio_cx(ent)
            end
          end
        end
        def handle_ent_(ent,indir,sel,&block)
          begin
            erio = ent_to_rio_(ent,indir)
            #p "handle_ent_1: #{erio.cx.inspect}"
            if stream_iter?
              # case for iterating files in a directory (e.g. rio('adir').lines) 
              _add_stream_iter_cx(erio).each(&block) if erio.file? and sel.match?(erio)
            else
              yield _add_iter_cx(erio) if sel.match?(erio)
            end
            #p "handle_ent_2: #{erio.cx.inspect}"
            
            if cx.has_key?('all') and erio.directory?
              rsel = Match::Entry::SelectorClassic.new(cx['r_sel'],cx['r_nosel'])
              _add_recurse_iter_cx(erio).each(&block) if rsel.match?(erio)
            end
            
          rescue ::Errno::ENOENT, ::URI::InvalidURIError => ex
            $stderr.puts(ex.message+". Skipping.")
          end
        end
        def each_(*args,&block)
          #p "#{callstr('each_',*args)} sel=#{cx['entry_sel'].inspect}"
          handle_skipped()
          sel = Match::Entry::Selector.new(cx['entry_sel'])
          indir = (self.to_s == '.' ? nil : self)
          self.ioh.each do |ent|
            #next if 
            handle_ent_(ent,indir,sel,&block) unless ent =~ /^\.(\.)?$/
          end
          closeoneof? ? self.close : self
        end
        def each_ent_(*args,&block)
          #p "#{callstr('each_',*args)} sel=#{cx['sel'].inspect} nosel=#{cx['nosel'].inspect}"
          handle_skipped()
          sel = Match::Entry::Selector.new(cx['entry_sel'])
          indir = (self.to_s == '.' ? nil : self)
          while ent = self.ioh.read
            handle_ent_(ent,indir,sel,&block) unless ent =~ /^\.(\.)?$/
          end
          closeoneof? ? self.close : self
        end

      end
    end
  end
end

module RIO
  module Ops
    module Dir
      module Stream

        private

        def _ss_keys()  Cx::SS::ENTRY_KEYS + Cx::SS::STREAM_KEYS end
        CX_ALL_SKIP_KEYS = ['retrystate']
        def _add_recurse_iter_cx(ario)
          new_cx = ario.cx
          cx.keys.reject { |k| 
            CX_ALL_SKIP_KEYS.include?(k) 
          }.each { |k|
            new_cx.set_(k,cx[k])
          }
          ario.cx = new_cx
          ario
        end
        def _add_cx(ario,keys)
          new_cx = ario.cx
          keys.each {|k|
            next unless cx.has_key?(k)
            new_cx.set_(k,cx[k])
          }
          ario.cx = new_cx
        end
        CX_DIR_ITER_KEYS = %w[entry_sel]
        CX_STREAM_ITER_KEYS = %w[stream_rectype stream_itertype stream_sel stream_nosel]
        def _add_iter_cx(ario)
          if nostreamenum?
            _add_cx(ario,CX_DIR_ITER_KEYS)
          end
          _add_stream_iter_cx(ario)
        end
        def _add_stream_iter_cx(ario)
          _add_cx(ario,CX_STREAM_ITER_KEYS)
          new_cx = ario.cx
          if stream_iter?
            new_cx.set_('ss_args',cx['ss_args']) if cx.has_key?('ss_args')
            new_cx.set_('ss_type',cx['ss_type']) if cx.has_key?('ss_type')
          end
          ario.cx = new_cx
          ario
        end
      end
    end
  end
end
