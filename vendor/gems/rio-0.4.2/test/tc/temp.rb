#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'tmpdir'

class TC_temp < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
    @tmpdir = ::Dir::tmpdir
    @pfx = 'rio'
  end

  def pathinfo(ario)
    [:scheme,:opaque,:path,:fspath,:to_s,:to_url,:to_uri].each do |sym|
      puts "#{sym}: #{ario.__send__(sym)}"
    end
  end

  def test_new
    tmp = rio(??)
    assert_equal('temp',tmp.scheme)
    assert_equal(::Dir::tmpdir,tmp.dirname.to_s)
    assert_match(/^rio/,tmp.filename.to_s)
  end

  def test_dir
    tmp = rio(??).mkdir
    assert(tmp.dir?)
    assert_equal('file',tmp.scheme)
    assert_equal(::Dir::tmpdir,tmp.dirname.to_s)
    assert_match(/^rio/,tmp.filename.to_s)
    tmp.close
  end

  def test_dir_chdir
    rio(??).chdir { |tmp|
      assert(tmp.dir?)
      assert_equal('path',tmp.scheme)
      assert_equal('.',tmp.dirname.to_s)
      assert_equal('.',tmp.filename.to_s)
      tmp.close
    }
  end
#   def test_dir_chdir2
#     tmp = rio(??).chdir 
#     assert(tmp.dir?)
#     assert_equal('path',tmp.scheme)
#     assert_equal('.',tmp.dirname.to_s)
#     assert_equal('.',tmp.filename.to_s)
#     tmp.close
#   end
  def test_dir_mkdir
    tmp = rio(??).mkdir
    assert(tmp.dir?)
    assert_equal('file',tmp.scheme)
    assert_equal(::Dir::tmpdir,tmp.dirname.to_s)
    assert_match(/^rio/,tmp.filename.to_s)
    tmp.close
  end

  def test_file
    tmp = rio(??).file
    assert(tmp.file?)
    assert_equal('file',tmp.scheme)
    assert_equal(::Dir::tmpdir,tmp.dirname.to_s)
    assert_match(/^rio/,tmp.filename.to_s)
    tmp.close
  end

  def test_dir_prefix
    tmp = rio(??,'zippy').mkdir
    assert(tmp.dir?)
    assert_match(/^zippy/,tmp.filename.to_s)
    assert_equal(::Dir::tmpdir,tmp.dirname.to_s)
    tmp.close
  end

  def test_file_prefix
    tmp = rio(??,'zippy').file
    assert(tmp.file?)
    assert_match(/^zippy/,tmp.filename.to_s)
    assert_equal(::Dir::tmpdir,tmp.dirname.to_s)
    tmp.close
  end

  def test_dir_tmpdir
    rio('riotmpdir').delete!.mkdir
    tmp = rio(??,'zippy','riotmpdir').mkdir
    assert_match(/^zippy/,tmp.filename.to_s)
    assert_match('riotmpdir',tmp.dirname.to_s)
    tmp.close
  end

  def test_file_tmpdir
    rio('riotmpdir').delete!.mkdir
    tmp = rio(??,'zippy','riotmpdir').file
    assert_match(/^zippy/,tmp.filename.to_s)
    assert_match('riotmpdir',tmp.dirname.to_s)
    tmp.close
  end

  def test_dir_prefix_url
    tmp = rio('temp:zippy').mkdir
    assert_match(/^zippy/,tmp.filename.to_s)
    tmp.close
  end

  def test_file_prefix_url
    tmp = rio('temp:zippy').file
    assert_match(/^zippy/,tmp.filename.to_s)
    tmp.close
  end

  def test_dir_tmpdir_url
    rio('riotmpdir').delete!.mkdir
    tmp = rio('temp:riotmpdir/zippy').mkdir
    assert(tmp.dir?)
    assert_match(/^zippy/,tmp.filename.to_s)
    assert_match('riotmpdir',tmp.dirname.to_s)
    tmp.close
  end

  def test_file_tmpdir_url
    rio('riotmpdir').delete!.mkdir
    tmp = rio('temp:riotmpdir/zippy').file
    assert(tmp.file?)
    assert_match(/^zippy/,tmp.filename.to_s)
    assert_match('riotmpdir',tmp.dirname.to_s)
    tmp.close
  end

  def test_file_write
    rio('riotmpdir').delete!.mkdir
    tmp = rio('temp:riotmpdir/zippy')
    tmp.puts("Hello Tempfile")
    assert(tmp.file?)
    assert(tmp.open?)
    tmp.close
  end


end
