#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'open-uri'
require 'ftp/testdef'

class TC_ftp_anon_read < Test::RIO::TestCase
  @@once = false
  include Test::RIO::FTP::Const
  FTPRO = FTPROOT/'riotest/ro'
  LOCENTS = [rio('f0'),d0=rio('d0'),d0/'f1',d1=d0/'d1',d1/'f2']
  ALLENTS = [FTP_ROROOT/'f0',d0=FTP_ROROOT/'d0',d0/'f1',d1=d0/'d1',d1/'f2']
  
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
  end
  def test_read_file
    f0 = FTP_ROROOT/'f0'
    exp = ""
    open(f0.to_s) { |fh| exp  = fh.gets(nil) }
    ans = rio(f0).contents
    assert_equal(exp,ans)
  end
  def test_read_dir
    ro = FTP_ROROOT.dup
    exp = [ro/'f0',ro/'d0']
    ans = rio(ro).to_a
    assert_array_equal(exp,ans)
  end
  def test_read_dir_all
    ro = FTP_ROROOT.dup
    exp = ALLENTS
    ans = rio(ro).all[]
    assert_array_equal(exp,ans)
  end
  def test_read_dir_all_selected_by_name
    ro = FTP_ROROOT.dup
    exp = ALLENTS.select{ |f| f =~ /1$/ }
    ans = ro.all['*1']
    assert_array_equal(exp,ans)
  end
  def test_read_dir_all_files
    ro = FTP_ROROOT.dup
    exp = ALLENTS.select{ |f| f.file? }
    ans = ro.all.files
    assert_array_equal(exp,ans)
  end
  def test_read_dir_all_dirs
    exp = ALLENTS.select{ |f| f.dir? }
    ans = FTP_ROROOT.dup.all.dirs
    assert_array_equal(exp,ans)
  end
  def test_cpfrom_file
    rem = FTP_ROROOT/'f0'
    #$trace_states = true
    loc = rio('f0').delete
    #$trace_states = false
    loc < rem
    #$trace_states = true
    assert_equal(loc.contents,rem.contents)
    #$trace_states = false
    loc = rio('f0').delete
    rem > loc
    assert_equal(loc.contents,rem.contents)
  end
  def test_cpfrom_dir
    rem = FTP_ROROOT/'d0'

    loc = rio('d0').delete!
    loc < rem
    exp = LOCENTS.select{ |f| f =~ /d0/ } - [loc]
    ans = loc.dup.all[]
    assert_array_equal(exp,ans)

    loc = rio('d0').delete!
    rem > loc
    exp = LOCENTS.select{ |f| f =~ /d0/ } - [loc]
    ans = loc.dup.all[]
    assert_array_equal(exp,ans)
  end
  def test_cpfrom_dir_select
    rem = FTP_ROROOT/'d0'

    loc = rio('d0').delete!
    loc < rem.entries('*1')
    exp = LOCENTS.select{ |f| f =~ /1$/ }
    ans = loc.dup.all[]
    assert_array_equal(exp,ans)

    loc = rio('d0').delete!
    rem.entries('*1') > loc
    exp = LOCENTS.select{ |f| f =~ /1$/ }
    ans = loc.dup.all[]
    assert_array_equal(exp,ans)
  end
end
