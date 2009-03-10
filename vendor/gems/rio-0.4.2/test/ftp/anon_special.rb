#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'open-uri'
require 'ftp/testdef'

class TC_ftp_anon_special < Test::RIO::TestCase
  @@once = false
  include Test::RIO::FTP::Const

  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
    FS_RWROOT.entries { |ent| ent.delete! }
  end

  def atest_mkpath
    rwdir = rio(FTP_RWROOT)
    tpath = rwdir/'d0'/'d1'/'d2'
    tpath.mkpath
    assert(tpath.dir?)
  end
  def test_rmtree
    rwdir = rio(FTP_RWROOT)
    tpath = rwdir/'d0'/'d1'/'d2'
    tpath.mkpath
    assert(tpath.dir?)
    rwdir/'d0'/'f0' < "a file"
    rwdir/'d0'/'d1'/'f1' < "a file"
    d0 = rio(rwdir,'d0').rmtree
    assert!(d0.exist?)
#    tpath.mkpath
#    assert(tpath.dir?)
#    d0 = rio(rwdir,'d0').rmtree
#    assert!(d0.exist?)
  end
  def atest_sel
    rwdir = rio(FTP_RWROOT)
    d0 = rwdir/'d0'
    d1 = d0/'d1'
    d2 = d1/'d2'
    d2.mkpath
    assert(d2.dir?)
    f0 = rwdir/'d0'/'f0' < "a file"
    f1 = rwdir/'d0'/'d1'/'f1' < "a file"

    ans = rwdir.all['*0']
    exp = [d0,f0]
    assert_equal(smap(exp),smap(ans))

    ans = rwdir.files[]
    exp = [f1,f0]
    assert_equal(smap(exp),smap(ans))

    ans = rwdir.dirs[]
    exp = [d0,d1,d2]
    assert_equal(smap(exp),smap(ans))
  end
end

