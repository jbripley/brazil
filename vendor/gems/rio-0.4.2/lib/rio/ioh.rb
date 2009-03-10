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


#require 'fileutils'

module RIO
  module IOH #:nodoc: all
    class Base
      attr :ios
      def initialize(ios,*args)
        @ios = ios
      end
      def initialize_copy(other)
        #p callstr('ioh:initialize_copy',other)
        super
        #p @ios
        @ios = other.ios.clone unless other.ios.nil?
      end
      def callstr(func,*args)
        self.class.to_s+'['+self.to_s+']'+'.'+func.to_s+'('+args.join(',')+')'
      end
      def handle() @ios end
      def open?() not closed? end
    end
    class Stream < Base
      attr_reader :iostack
      attr_accessor :hindex
      def initialize(iosp,*args)
        super
        @iostack = [@ios]
        @hindex = -1
      end
      def initialize_copy(*args)
        #p callstr('ioh_stream:initialize_copy',*args)
        super
        @iostack = @iostack.map { |io| io.nil? || io.equal?(@ios) ? io : io.clone }
      end
      def copy_blksize() 
        if @ios.respond_to? :stat
          sz = @ios.stat.blksize
          sz = nil if sz.nil? || sz == 0
        end
        sz || 512 
      end

      def handle() @iostack[@hindex] end
      def close()  handle.close unless self.closed? end
      def closed?() handle.nil? or handle.closed? end
      def eof?() closed? or handle.eof? end
      def copy_stream(dst)
        #p callstr('copy_stream',dst)
        blksize = _stream_blksize(handle,dst)
        until handle.eof?
          dst.print(handle.read(blksize))
        end
        self
      end
      def puts(*args)
        handle.puts(*args)
      end
      def each_bytes(nb,&block)
        until handle.eof?
          break unless s = handle.read(nb)
          yield s
        end
        self
      end
      def each_line(*args,&block)
        handle.each_line(*args,&block)
      end
      extend Forwardable
      def_instance_delegators(:handle,:binmode,:stat,:rewind,
                              :each,:each_byte,:gets,:getc,
                              :read,:readlines,:readline,:sysread,
                              :<<,:print,:printf,:putc,:write,:syswrite,
                              :pos,:pos=,:lineno,:lineno=,
                              :fileno,
                              :close_read,:close_write,
                              :fsync,:sync,:sync=,:fcntl,:ioctl)

      def method_missing(sym,*args,&block)
        #p callstr('method_missing',sym,*args)
        handle.__send__(sym,*args,&block)
      end
      DEFAULT_BLKSIZE = 1024
      def _stream_blksize(*streams)
        sizes = []
        streams.each do |s|
          next unless s.kind_of?(::IO)
          next unless s.respond_to?(:stat)
          size = _stat_blksize(s.stat)
          sizes << size if size
        end
        sizes.min || DEFAULT_BLKSIZE
      end
      def _stat_blksize(st)
        s = st.blksize
        return nil unless s
        return nil if s == 0
        s
      end
    end
    class Dir < Base
      def close
        #p "#{callstr('close')} ios=#{@ios}"
        unless @ios.nil?
          @ios.close
          @ios = nil
        end
      end
      def closed?() @ios.nil? end
      def each(&block)
        while filename = handle.read
          yield filename
        end
      end
      def each0(&block)
        handle.each { |filename|
          yield filename
        }
      end
      extend Forwardable
      def_instance_delegators(:handle,
                              :read,
                              :pos,:pos=,:tell,:seek,:rewind)
    end
  end
end
__END__
