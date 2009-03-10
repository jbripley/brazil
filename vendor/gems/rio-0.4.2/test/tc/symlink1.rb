#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_symlink1 < Test::Unit::TestCase
  def assert!(a,msg="negative assertion")
    assert((!(a)),msg)
  end
  def smap(a) a.map { |el| el.to_s } end
  def tdir() rio(%w/qp symlink1/) end
  def mkafile(*args)
    file = rio(*args)
    file < (0..1).map { |i| "L#{i}:#{file.to_s}\n" }
    file
  end
  def mkalinesfile(n_lines,*args)
    file = rio(*args)
    file < (0...n_lines).map { |i| "L#{i}:#{file.to_s}\n" }
    file
  end
  def setup
    #$trace_states = true
    @cwd = ::Dir.getwd
    tdir.mkpath.chdir
  end
  def teardown
    ::Dir.chdir @cwd
  end
  def test_lstat
    rio('lstat').delete!.mkpath.chdir

    file = mkalinesfile(100,'f0').symlink( link = rio('l0') )
    assert(file.file?)
    assert(link.file?)
    assert(link.symlink?)

    assert_equal(file.stat.size,link.stat.size)
    assert_not_equal(file.stat.size,link.lstat.size)
    assert_raise(RIO::Exception::CantHandle) {
      file.lstat
    }

    rio('..').chdir
  end
  def test_stream
    rio('stream').delete!.mkpath.chdir

    file = mkalinesfile(10,'f0').symlink( link = rio('l0') )
    assert(file.file?)
    assert(link.file?)
    assert(link.symlink?)
    lines = file[]

    rl = link.readlink
    assert(link.file?)
    assert(link.symlink?)
    assert_equal(lines[0],link.getrec)
    assert(link.open?)

    assert_equal(rl.to_s,link.readlink.to_s)
    assert(link.open?)
    assert_equal(lines[1],link.getrec)
    
    link.lstat
    assert(link.open?)
    assert_equal(lines[2],link.getrec)
    
    link.stat
    assert(link.open?)
    assert_equal(lines[3],link.getrec)

    link.delete
    assert(link.closed?)
    assert!(link.exist?)
    assert!(link.symlink?)

    rio('..').chdir
  end
  def test_readlink
    rio('readlink').delete!.mkpath.chdir

    file = mkafile('f0').symlink( link = rio('l0') )
    assert(file.file?)
    assert(link.file?)
    assert(link.symlink?)

    assert_equal(file,link.readlink)
    assert_not_equal(file,link)
    assert_raise(RIO::Exception::CantHandle) {
      file.readlink
    }

    rio('..').chdir
  end
  def test_ftype
    rio('ftype').delete!.mkpath.chdir

    file = mkafile('f0').symlink( link = rio('l0') )
    assert(file.file?)
    assert(link.file?)
    assert(link.symlink?)

    assert_equal('file',file.ftype)
    assert_equal('link',link.ftype)

    rio('..').chdir
  end
end
