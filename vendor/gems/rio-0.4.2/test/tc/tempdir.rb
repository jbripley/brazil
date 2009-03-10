#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'tmpdir'

class TC_tempdir < Test::RIO::TestCase
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
    tmpdir = rio('tempdir:')
    assert(tmpdir.dir?)
    assert_equal(::Dir::tmpdir,tmpdir.dirname.to_s)
  end

  def test_prefix
    tmpdir = rio('tempdir:','zippy')
    assert_match(/^zippy/,tmpdir.filename.to_s)
  end

  def test_tmpdir
    rio('riotmpdir').delete!.mkdir
    tmpdir = rio('tempdir:','zippy','riotmpdir')
    assert_match(/^zippy/,tmpdir.filename.to_s)
    assert_match('riotmpdir',tmpdir.dirname.to_s)
  end

  def test_prefix_url
    tmpdir = rio('tempdir:zippy')
    assert_match(/^zippy/,tmpdir.filename.to_s)
  end

  def test_tmpdir_url
    rio('riotmpdir').delete!.mkdir
    tmpdir = rio('tempdir:riotmpdir/zippy')
    assert_match(/^zippy/,tmpdir.filename.to_s)
    assert_match('riotmpdir',tmpdir.dirname.to_s)
  end


end
