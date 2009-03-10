#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'open-uri'
require 'ftp/testdef'

class TC_ftp2ftp < Test::RIO::TestCase
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
  def test_cp_ro2rw_file1
    fname = 'f0'
    src = FTP_ROROOT/fname
    dst = FTP_RWROOT/fname
    dst < src
    assert_equal(src.chomp[],dst.chomp[])
  end
  def test_cp_ro2rw_file2
    fname = 'f0'
    src = FTP_ROROOT/fname
    dst = FTP_RWROOT
    dst < src
    fdst = dst/fname
    assert_equal(src.chomp[],fdst.chomp[])
  end
  def test_cp_ro2rw_dir
    fname = 'd0'
    src = FTP_ROROOT/fname
    dst = FTP_RWROOT
    dst < src
    ans = rio(FTP_RWROOT,fname).to_a
    exp = rio(FTP_ROROOT,fname).to_a.map{ |s| s.sub('ro','rw') }
  
    assert_equal(smap(exp),smap(ans))
  end


end
