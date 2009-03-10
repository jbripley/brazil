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


# 
# = open3.rb
#
# = Rio
#
# Copyright (c) 2005,2006,2007,2008 Christopher Kleckner
#
#


require 'rio'
require 'open3'

module RIO
  def popen3(*args,&block)
    if block_given?
      i,o,e = nil,nil,nil
      begin
        Open3.popen3(*args) do |si,so,se|
          yield(i=Rio.new(si),o=Rio.new(so),e=Rio.new(se))
        end
      ensure
        [i,o,e].each { |el| el.reset if el }
      end
    else
      si,so,se = Open3.popen3(*args)
      [Rio.new(si),Rio.new(so),Rio.new(se)]
    end
  end
  module_function :popen3
end
__END__
