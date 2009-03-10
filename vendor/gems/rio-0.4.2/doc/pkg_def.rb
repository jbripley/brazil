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

require 'rio/doc'

module PKG
  NAME = "rio"
  TITLE = RIO::TITLE
  VERSION = RIO::VERSION
  FULLNAME = PKG::NAME + "-" + PKG::VERSION
  SUMMARY = RIO::SUMMARY
  DESCRIPTION = RIO::DESCRIPTION
  AUTHOR = "Christopher Kleckner"
  EMAIL = "rio4ruby@rubyforge.org"
  RUBYFORGE_PROJECT = PKG::NAME
  HOMEPAGE = "http://#{PKG::RUBYFORGE_PROJECT}.rubyforge.org/"
  RUBYFORGE_URL = "http://rubyforge.org/projects/#{PKG::RUBYFORGE_PROJECT}"
  RDOC_OPTIONS = ['--show-hash','--line-numbers','-mRIO::Doc::SYNOPSIS','-Tdoc/generators/template/html/rio.rb']
  module FILES
    SRC = rio('lib').norecurse('.svn').files['*.rb']
    DOC = rio['README'] + rio('lib')['rio.rb'] + rio('lib/rio/doc/')['*.rb'] +
                        rio('lib/rio/if/')['*.rb'] + rio('lib/rio')['kernel.rb','constructor.rb']
    XMP = rio('ex').entries[]
    D2 = rio('doc').norecurse('.svn').all.files.skip.dirs['rdoc','.svn']
    TST = rio('test').norecurse('.svn').all.files('*.rb').skip.dirs['qp','.svn']
    MSC = rio.files['setup.rb', 'build_doc.rb', 'COPYING', 'Rakefile', 'ChangeLog', 'VERSION']
    
    [SRC,DOC,XMP,D2,TST,MSC].each do |fary|
      fary.map! { |f| f.to_s }
    end
    DIST  =  SRC + DOC + XMP + D2 + TST + MSC
  end

  OUT_DIR = 'pkg'
  OUT_FILES = %w[.gem .tar.gz .zip].map { |ex| PKG::OUT_DIR + '/' + FULLNAME + ex }
end
