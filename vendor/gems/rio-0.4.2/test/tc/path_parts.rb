#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'tc/testcase'
require 'pp'

class PathGenerator
  ROOTS = ['r1','r 1']
  DIRS = ['d1','d 1']
  FILES = ['f1','f 1','f1.txt','f 1.txt']
  UROOTS = ROOTS.map{|z| z.gsub(/ /,'%20')}
  UDIRS = DIRS.map{|z| z.gsub(/ /,'%20')}
  UFILES = FILES.map{|z| z.gsub(/ /,'%20')}

  attr_reader :fs_basic_paths,:fs_url_paths,:fs_drive_paths,
      :fs_unc_paths,:fs_paths,:http_paths,:ftp_paths, :uri_paths,:all_paths

  def initialize()
    @fs_basic_paths = self.class.fs_basic_paths()
    @fs_url_paths = self.class.fs_url_paths()
    @fs_drive_paths = self.class.fs_drive_paths()
    @fs_unc_paths = self.class.fs_unc_paths()
    @fs_paths = @fs_basic_paths + @fs_url_paths + @fs_drive_paths + @fs_unc_paths
    @http_paths = self.class.http_paths()
    @ftp_paths = self.class.ftp_paths()
    #@uri_paths = @http_paths + @ftp_paths
    @uri_paths = @http_paths

    @all_paths = @fs_paths + @uri_paths
  end
  def self.fs_basic_paths()
    tops = %w{/}
    build_paths(tops,ROOTS,DIRS,FILES)
  end
  def self.fs_url_paths()
    #tops = %w{file:/// file:///x:/ file://h/}
    # tops = %w{file:/// file:///x:/ file://h/}
    tops = %w{file:/// file://h/}
    tops << 'file:///x:/' if $mswin32 
    build_paths(tops,ROOTS,DIRS,FILES)
  end
  def self.fs_drive_paths()
    return [] unless $mswin32
    tops = %w{x:/}
    build_paths(tops,ROOTS,DIRS,FILES)
  end
  def self.fs_unc_paths()
    tops = %w{//h/}
    build_paths(tops,ROOTS,DIRS,FILES)
  end
  def self.http_paths()
    htops = %w{http://h/}
    build_paths(htops,UROOTS,UDIRS,UFILES)
  end
  def self.ftp_paths()
    ftops = %w{ftp://h/}
    build_paths(ftops,UROOTS,UDIRS,UFILES)
  end
  def self.build_paths(tops,roots,dirs,files)
    paths = []
    tops.each { |t|
      paths << t
      roots.each{|r| paths << t+r }
      roots.map{|r| t + r + '/'}.each { |r|
        paths << r
        dirs.each{|d| paths << r+d}
        dirs.map{|d| r+d+'/'}.each{|d|
          paths << d
          files.each{|f| paths << d+f}
          files.map{|f| d+f}.each{|f|
            paths << f
          }
        }
      }
    }      
    paths
  end
end


class TC_path_parts < Test::RIO::TestCase
  @@once = false
  @@exp = nil
  @@gen = PathGenerator.new

  def self.once
    @@once = true
    expfile = RIO.cwd('../../tc/rlparts.ans.yml')
    @@exp = expfile.yaml.get
  end

  def setup
    super
    self.class.once unless @@once
  end

  def run_path_tests_exp(paths,sym)
    paths.each do |pstr|
      #p pstr
      r = rio(pstr)
      assert_equal(@@exp[r.to_s][sym],r.__send__(sym).to_s,"rio('#{pstr}').#{sym} failed")
    end
  end
  def run_path_tests_native(paths,sym,*args)
    paths.each do |pstr|
      r = rio(pstr)
      exp = File.__send__(sym,pstr,*args)
      ans = r.__send__(sym,*args).to_s
      #puts "#{sym}[#{r}]: #{exp} <=> #{ans}"
      assert_equal(exp,ans,"rio('#{pstr}').#{sym} failed")
    end
  end
  def run_path_tests_native_fspath(paths,sym,*args)
    paths.each do |pstr|
      r = rio(pstr)
      fpth = r.fspath
      assert_equal(File.__send__(sym,fpth,*args),r.__send__(sym,*args).to_s,"rio('#{pstr}').#{sym} failed")
    end
  end
  def test_filename()
    @@gen.all_paths.each do |pstr|
      assert_equal(rio(pstr).basename(''),rio(pstr).filename)
      assert_equal(rio(pstr).noext.basename,rio(pstr).filename)
    end
  end
  def test_uri_dirname
    run_path_tests_exp(@@gen.uri_paths,:dirname)
  end
  def test_uri_basename
    run_path_tests_exp(@@gen.uri_paths,:basename)
  end

  def test_fs_dirname
    run_path_tests_native(@@gen.fs_basic_paths,:dirname)
    run_path_tests_native(@@gen.fs_drive_paths,:dirname)
    run_path_tests_exp(@@gen.fs_unc_paths,:dirname)
  end
  def test_fs_url_dirname
    run_path_tests_exp(@@gen.fs_url_paths,:dirname)
  end
  def test_fs_url_basename
    run_path_tests_native_fspath(@@gen.fs_url_paths,:basename,'')
    run_path_tests_native_fspath(@@gen.fs_url_paths,:basename,'.txt')
  end
  def test_fs_basename
    run_path_tests_native(@@gen.fs_basic_paths,:basename,'')
    run_path_tests_native(@@gen.fs_drive_paths,:basename,'')
    run_path_tests_native(@@gen.fs_unc_paths,:basename,'')
    run_path_tests_native(@@gen.fs_basic_paths,:basename,'.txt')
    run_path_tests_native(@@gen.fs_drive_paths,:basename,'.txt')
    run_path_tests_native(@@gen.fs_unc_paths,:basename,'.txt')
  end

  def test_fs_path
    run_path_tests_exp(@@gen.fs_paths,:path)
  end
  def test_uri_path
    run_path_tests_exp(@@gen.uri_paths,:path)
  end
  def test_fs_fspath
    run_path_tests_exp(@@gen.fs_paths,:fspath)
  end
  def test_uri_fspath
    run_path_tests_exp(@@gen.uri_paths,:fspath)
  end
  def test_fs_urlpath
    run_path_tests_exp(@@gen.fs_paths,:urlpath)
  end
  def test_uri_urlpath
    run_path_tests_exp(@@gen.uri_paths,:urlpath)
  end

end
