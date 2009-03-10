#!/usr/bin/env ruby
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
#
# To create the documentation for Rio run the command
#   ruby build_doc.rb
# from the distribution directory.
#++

$:.unshift 'lib'
require 'rio'
require 'rio/prompt'
require 'doc/pkg_def'

module DFLT
  RDOC_DIR = rio('doc/rdoc')
end

#puts "Rio interactive RDoc installer."
def doc_dir?(d)
  have_dirs = ['classes','files'].inject(true) {|isdir,f| isdir and rio(d,f).dir?}
  have_files = ['created.rid','fr_class_index.html',
                'fr_file_index.html','fr_method_index.html',
                'index.html','rdoc-style.css'].inject(true) { |isfile,f| isfile && rio(d,f).file? }
  have_dirs && have_files
end

rdoc_dir = RIO.promptr('Where shall I build the rdoc documentation',DFLT::RDOC_DIR)

if rdoc_dir.exist?
  delit = 'y'
  if rdoc_dir.dir?
    unless doc_dir?(rdoc_dir)
      delit = RIO.promptd("Directory '#{rdoc_dir}' exists. Would you like to delete it? ", 'n' )
    end
  else
    delit = RIO.promptd("Non directory '#{rdoc_dir}' exists. Would you like to delete it? ", 'n' )
  end
  if delit =~ /^[yY]/
    rio(rdoc_dir).delete!
  else
    exit(-1)
  end
end


rdoc_dir = rio(rdoc_dir)


argv = []
argv << '--op' << rdoc_dir.to_s
argv += PKG::RDOC_OPTIONS
argv += PKG::FILES::DOC

require 'rdoc/rdoc'
begin
  r = RDoc::RDoc.new
  r.document(argv)
rescue RDoc::RDocError => e
  $stderr.puts e.message
  exit(1)
end

docindex = (rdoc_dir/'index.html').abs.to_url
msg = "Please point your browser at '#{docindex}'" 
lin =  ">" + ">" * (msg.length+2) + ">"

puts
puts lin
puts "> " + msg + " >"
puts lin
__END__



