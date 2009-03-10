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

begin
  require 'rubygems'
  require 'rake/gempackagetask'
rescue Exception
end

require 'rake/clean'
require 'rake/packagetask'
require 'rake/rdoctask'
require 'rake/testtask'

# General actions  ##############################################################

$:.push 'lib'
require 'rio/version'
require 'rio/doc'
require 'rio'

SVN_REPOSITORY_ROOT = 'svn+ssh://rio4ruby@rubyforge.org//var/svn/rio'
SVN_REPOSITORY_URL = [SVN_REPOSITORY_ROOT,'trunk/rio'].join('/')
 
require 'doc/pkg_def'

ZIP_DIR = "/loc/zip/ruby/rio"


# The default task is run if rake is given no explicit arguments.

desc "Default Task"
task :default => :rdoc


# End user tasks ################################################################

desc "Prepares for installation"
task :prepare do
  ruby "setup.rb config"
  ruby "setup.rb setup"
end

desc "Installs the package #{PKG::NAME}"
task :install => [:prepare] do
  ruby "setup.rb install"
end

task :clean do
  ruby "setup.rb clean"
end

CLOBBER << "doc/rdoc"
desc "Builds the documentation"
task :doc => [:rio_rdoc] do
    puts "\nGenerating online documentation..."
#    ruby %{-I../lib ../bin/webgen -V 2 }
end

rd = Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.title    = PKG::TITLE
  rdoc.options = PKG::RDOC_OPTIONS
  rdoc.main = 'RIO::Doc::SYNOPSIS'
  PKG::FILES::DOC.to_a.each do |glb|
    #next if glb =~ /yaml.rb$/
    rdoc.rdoc_files.include( glb )
  end
  rdoc.template = 'doc/generators/template/html/rio.rb'
end

desc "Build custom RDoc"
task :rio_rdoc do 
  require 'rio/doc/SYNOPSIS'
  ruby "-Idoc/patched_rdoc -Ilib doc/bin/rdoc --show-hash --op doc/rdoc --title #{PKG::TITLE} --line-numbers  --template doc/generators/template/html/rio.rb #{PKG::FILES::DOC} --main #{RIO::Doc::SYNOPSIS}" 
end
CLOBBER << "test/log" << "test/qp"
task :test do |t|
    sh "cd test;ruby -I../lib -I. runtests.rb"
end

task :ziparc do |var|
  require 'rio'
  #$trace_states = true
  rio(ZIP_DIR) < rio('pkg').files['*.tgz','*.tar.gz','*.zip','*.gem']
end

task :gen_changelog do
  sh "svn log -r HEAD:1 -v > ChangeLog"
end

task :gen_version do
  puts "Generating VERSION file"
  File.open( 'VERSION', 'w+' ) do |file| file.write( PKG::VERSION + "\n" ) end
end


task :gen_files => [:gen_changelog, :gen_version]
#task :gen_files => [:gen_version]
CLOBBER << "ChangeLog" << "VERSION" 
task :no_old_pkg do
#  unless Dir["pkg/#{PKG::FULLNAME}*"].empty?
#    $stderr.puts("packages for version #{PKG::VERSION} exist!")
#    $stderr.puts("Either delete them, or change the version number.")
#    exit(-1)
#  end
end

task :package => [:no_old_pkg, :gen_files]
#PKG::OUT_FILES.each do |f|
#  file f => [:package]
#end

Rake::PackageTask.new( PKG::NAME, PKG::VERSION ) do |p|
  p.need_tar_gz = true
  p.need_zip = true
  p.package_files = PKG::FILES::DIST
end

Spec = Gem::Specification.new do |s|
  s.name = PKG::NAME
  s.version = PKG::VERSION
  s.author = PKG::AUTHOR
  s.email = PKG::EMAIL
  s.homepage = PKG::HOMEPAGE
  s.rubyforge_project = PKG::RUBYFORGE_PROJECT

  s.platform = Gem::Platform::RUBY
  s.summary = PKG::SUMMARY
  s.files = PKG::FILES::DIST.map { |rf| rf.to_s }

  s.require_path = 'lib'
  s.autorequire = 'rio'

  s.has_rdoc = true

  s.rdoc_options << PKG::RDOC_OPTIONS 
end

Rake::GemPackageTask.new(Spec) do |p| end

desc "Build the Gem spec file for the rio package"
task :gemspec => "pkg/rio.gemspec"
file "pkg/rio.gemspec" => ["pkg", "Rakefile"] do |t|
  open(t.name, "w") do |f| f.puts Spec.to_yaml end
end

desc "Make a new release (test,package,svn_version)"
task :release => [:test, :clobber, :rdoc , :package, :svn_version, :ziparc] do
  

end
desc "Save the current code as a new svn version"
task :svn_version do
  require 'rio'
  repos = rio(SVN_REPOSITORY_URL)
  repo_root = rio(SVN_REPOSITORY_ROOT)
  proju = rio(repo_root,'trunk',PKG::NAME) 
  relu  = rio(repo_root,'tags',"release-#{PKG::VERSION}")
  relo =`svn list #{relu.to_url}`
  if relo.size > 0
    $stderr.puts "Release #{relu.to_url} exists!"
    exit(-1)
  end
  msg = "Release #{PKG::VERSION} of #{PKG::NAME}"
  cmd = sprintf('svn copy %s %s -m "%s"',proju.to_url, relu.to_url, msg)
  sh cmd
end

desc "Commit the current code to svn"
task :svn_commit do
  require 'rio'
  msg = rio(?-).print("Comment: ").chomp.gets
  cmd = sprintf('svn commit -m "%s"', msg)
  sh cmd
end

#desc "Build the gem from the gemspec"
#task :buildgem => ['rio.gemspec'] do
#  cmd = "gem build 'rio.gemspec'"
#  sh cmd
#end

GEM_FILENAME = "pkg/#{Spec.full_name}.gem"
desc "Install development gem"
task :installgem => [GEM_FILENAME] do
  cmd = "gem install #{GEM_FILENAME}"
  sh cmd
end

desc "Upload documentation to homepage"
task :uploaddoc => [:rdoc] do
  Dir.chdir('doc/rdoc')
  puts
  puts "rio4ruby@rubyforge.org:/var/www/gforge-projects/#{PKG::NAME}/"
  sh "scp -r * rio4ruby@rubyforge.org:/var/www/gforge-projects/#{PKG::NAME}/"
end


# Misc tasks ###################################################################


def count_lines( filename )
  lines = 0
  codelines = 0
  open( filename ) do |f|
    f.each do |line|
      lines += 1
      next if line =~ /^\s*$/
      next if line =~ /^\s*#/
      codelines += 1
    end
  end
  [lines, codelines]
end


def show_line( msg, lines, loc )
  printf "%6s %6s   %s\n", lines.to_s, loc.to_s, msg
end


desc "Show statistics"
task :statistics do
  total_lines = 0
  total_code = 0
  show_line( "File Name", "Lines", "LOC" )
  PKG::FILES::SRC.each do |fn|
    lines, codelines = count_lines fn
    show_line( fn, lines, codelines )
    total_lines += lines
    total_code  += codelines
  end
  show_line( "Total", total_lines, total_code )
end


def run_testsite( arguments = '' )
  chdir 'test' do
    ruby "-I../lib -I. #{arguments} runtests.rb"
  end
#  ruby %{-I../lib #{arguments} ../bin/webgen -V 3 }
end


CLOBBER << "test/qp" << "qp"
desc "Build the test site"
task :testsite do
  run_testsite
end


CLOBBER  << "test/coverage"
desc "Run the code coverage tool on the testsite"
task :coverage do
  run_testsite '-rcoverage'
end
