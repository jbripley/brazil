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


require 'uri'
require 'rio/local'
require 'rio/uri/file'
require 'rio/rl/chmap'

module RIO
  module RL #:nodoc: all
    PESCAPE = Regexp.new("[^-_.!~*'()a-zA-Z0-9;?:@&=+$,]",false, 'N').freeze
    ESCAPE = Regexp.new("[^-_.!~*'()a-zA-Z0-9;\/?:@&=+$,]",false, 'N').freeze
    def escape(pth,esc=ESCAPE)
      ::URI.escape(pth,esc)
    end
    def unescape(pth)
      ::URI.unescape(pth)
    end
    def fs2urls(*args)
      args.map{ |pth| fs2url(pth) }
    end
    def fs2url(pth, esc=ESCAPE)
      #pth.sub!(/^[a-zA-Z]:/,'')
      pth = URI.escape(pth,esc)
      pth = '/' + pth if pth =~ /^[a-zA-Z]:/
      pth
      #      (Local::SEPARATOR == '/' ? pth : pth.gsub(Local::SEPARATOR,%r|/|))
    end

    def url2fs(pth)
#      pth = pth.chop if pth.length > 1 and pth[-1] == ?/      cwd = RIO::RL.fs2url(::Dir.getwd)

      #pth = pth.chop if pth != '/' and pth[-1] == ?/
      pth = ::URI.unescape(pth)
      if pth =~ %r#^/[a-zA-Z]:#
        pth = pth[1..-1] 
      end
      pth
#      (Local::SEPARATOR == '/' ? pth : pth.gsub(%r|/|,Local::SEPARATOR))
    end

    def getwd()
      #::URI::FILE.build({:path => fs2url(::Dir.getwd)+'/'})
      ::URI::FILE.build({:path => fs2url(::Dir.getwd)})
    end

    module_function :url2fs,:fs2url,:fs2urls,:getwd,:escape,:unescape
  end
end
