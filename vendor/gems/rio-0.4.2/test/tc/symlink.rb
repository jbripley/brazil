#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_symlink < Test::Unit::TestCase
  def assert!(a,msg="negative assertion")
    assert((!(a)),msg)
  end
  def smap(a) a.map { |el| el.to_s } end
  def tdir() rio(%w/qp symlink/) end
  def mkafile(*args)
    file = rio(*args)
    file < (0..1).map { |i| "L#{i}:#{file.to_s}\n" }
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
  def check_link(lnk,dst)
    assert(lnk.symlink?, "symlink?")
    assert_equal('link',lnk.ftype)
    assert_equal(dst.exist?,lnk.exist?)
    if dst.exist?
      assert_equal(dst.contents,lnk.contents)
    end
  end
  def compare_links(exp,ans)
    assert_equal(exp.exist?,ans.exist?)
    assert_equal(exp.symlink?,ans.symlink?)
    assert_equal(exp.ftype,ans.ftype)
    assert_equal(exp.readlink.to_s,ans.readlink.to_s)
  end
  def test_File_symlink_nopath_exist
    dir = rio('d0').delete!.mkpath
    mkafile(dir,'f0')
    dir.chdir
    #$trace_states = true
    
    file = rio('f0')
    lruby = rio('lruby')
    assert(file.exist?)
    
    ::File.symlink(file.to_s,lruby.delete.to_s)
    check_link(lruby,file)
    
    lrio = rio('lrio')
    file.symlink( lrio.delete )
    check_link(lrio,file)
    
    compare_links(lruby,lrio)
    rio('..').chdir
  end
  def test_File_symlink_nopath_noexist
    dir = rio('d1').delete!.mkpath
    dir.chdir

    #$trace_states = true
    
    file = rio('f1')
    assert_equal(false,file.exist?)
    
    lruby = rio('lruby')
    ::File.symlink(file.to_s,lruby.delete.to_s)
    check_link(lruby,file)
    
    lrio = rio('lrio')
    file.symlink( lrio.delete )
    check_link(lrio,file)
    
    compare_links(lruby,lrio)
    
    rio('..').chdir
  end
  def test_xmp
    rio('xmpdir').delete!.mkpath
    rio('xmpdir/afile').touch
    ::File.symlink('xmpdir/afile','xmpdir/alink1') # creates 'xmpdir/alink1 => xmpdir/afile'
    assert_equal(false,::File.exist?('xmpdir/alink1'))
    rio('xmpdir/afile').symlink('xmpdir/alink2')   # creates 'xmpdir/alink2 => afile'
    assert(::File.exist?('xmpdir/alink2'))
  end
  def test_relative_paths
    dir = rio('adir').delete!.mkpath
    afile1 = mkafile(dir,'afile1')

    alink1 = rio('adir/alink1').delete
    afile1.symlink(alink1)
    check_link(alink1,afile1)
    
    alink2 = rio('alink2').delete
    afile1.symlink(alink2)
    check_link(alink2,afile1)

    afile2 = mkafile('afile2')
    alink3 = rio('adir/alink3').delete
    afile2.symlink(alink3)
    check_link(alink3,afile2)
    
    alink4 = rio('alink4').delete
    afile2.symlink(alink4)
    check_link(alink4,afile2)

  end
  def test_symlink_path_exist
    dir = rio('d2').delete!.mkpath
    mkafile(dir,'f2')
    #$trace_states = true
    
    file = rio(dir,'f2')
    assert(file.exist?)

    lrio = rio(dir,'lrio')
    file.symlink( lrio.delete )
    check_link(lrio,file)
    
  end
  def test_symlink_path_noexist
    dir = rio('d3').delete!.mkpath
    #$trace_states = true
    
    file = rio(dir,'f3')
    assert_equal(false,file.exist?,"file does not exist")

    lrio = rio(dir,'lrio')
    file.symlink( lrio.delete )
    check_link(lrio,file)
    
  end
  def test_destdir
    rio('destdir').delete!.mkpath.chdir

    file = mkafile('f0')
    dir = rio('d0').delete!.mkpath
    #$trace_states = true
    
    file.symlink(dir)
    expl = rio(dir,file)
    check_link(expl,file)

    rio('..').chdir
  end
  def test_eexist
    rio('eexist').delete!.mkpath.chdir

    file = mkafile('f0')
    dir = rio('d0').delete!.mkpath
    expl = rio(dir,file).touch

    #$trace_states = true
    assert_raise(Errno::EEXIST) {
      file.symlink(dir)
    }
    expl = rio('l0').touch
    assert_raise(Errno::EEXIST) {
      file.symlink('l0')
    }
    expl = rio('l1').delete
    file.symlink(expl)
    assert_raise(Errno::EEXIST) {
      file.symlink(expl)
    }

    rio('..').chdir
  end
end
