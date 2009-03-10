#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
class TC_ext < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true

  end

  def setup
    super
    self.class.once unless @@once

  end

#  def test_mvdir
#    rio('a').rmtree.mkpath
#    rio('a/b').mkpath
#    rio('a/c').mkpath
#    rio('a/b/f').touch
#    rio('a/b/f').rename('a/c')
#    rio('a/b/d').mkdir
#    rio('a/b/d').rename('a/c')
#    assert(rio('a/c/f').exist?)
#    assert(rio('a/c/d').exist?)
#  end
  def test_change_ext_in_dir
    rio('ch').rmtree.mkpath
    rio('ch/0.a').touch
    rio('ch/1.a').touch
    rio('ch/0.b').touch
    rio('ch/1.b').touch
    rio('ch/0.c').touch
    rio('ch/1.c').touch
    rio('ch').files('*.a') do |file|
      new_file = file.dup
      new_file.extname = '.x'
      file.rename(new_file)
    end
    assert(rio('ch/0.x').exist?)
    assert(rio('ch/1.x').exist?)
    $trace_states = false
    rio('ch').files('*.b') do |file|
      file.rename.extname = '.y'
    end
    assert(rio('ch/0.y').exist?)
    assert(rio('ch/1.y').exist?)
    rio('ch').rename.files('*.c') do |file|
      file.extname = '.z'
    end
    assert(rio('ch/0.z').exist?)
    assert(rio('ch/1.z').exist?)
  end
  def test_change_tgz
    rio('tgz').rmtree.mkpath
    rio('tgz/dir').mkdir
    rio('tgz/dir/z.tar.gz').touch
    rio('tgz/z.tar.gz').touch
    
    rio('tgz').rename.all.files('*.tar.gz') do |gzfile|
      gzfile.ext('.tar.gz').extname = '.tgz'
    end
    assert(rio('tgz/dir/z.tgz').exist?)
    assert(rio('tgz/z.tgz').exist?)
  end
  def test_ext
    ario = rio('afile.tar.gz').touch
    $trace_states = false
    ario.rename!('cfile.tgz')
#    ario.ext('.tar.gz').basename = 'bfile'
  end
  def test_basename
    s_dir = ''
    adir = rio(%w/adir asubdir/).rmtree.mkpath
    fname = 'afile'; 
    ename = '.aext'; 
    wname = fname+ename;
    afile = rio(adir,fname+ename)

    assert_equal(ename, afile.ext?)
    assert_equal(fname, afile.basename.to_s)
    assert_equal(fname, afile.ext.basename.to_s)
    assert_equal(ename, afile.ext?)
    assert_equal(wname, afile.ext('.j').basename.to_s)
    assert_equal('.j', afile.ext?)
    assert_equal(wname, afile.basename('.j').to_s)
    assert_equal('.j', afile.ext?)
    assert_equal(wname, afile.ext('').basename.to_s)
    assert_equal('', afile.ext?)
    assert_equal(fname, afile.basename(nil).to_s)
    assert_equal(ename, afile.ext?)
    assert_equal(wname, afile.noext.basename.to_s)
    assert_equal('', afile.ext?)
  end
  def test_pathutil
    path = rio(%w/dir1 sd1 f1.txt/)
    ext1 = path.extname
    assert_equal('.txt',ext1)
    bn2 = path.basename('.txt')
    assert_equal('f1',bn2.to_s)
    dn1 = path.dirname
    assert_equal('dir1/sd1',dn1.to_s)
    
    abs0 = ::File.expand_path(path.to_s)
    abs1 = path.abs
    assert_equal(abs0,abs1.to_s)
    abs2 = rio(RIO.cwd,path.dirname,path.basename(path.extname).to_s+path.extname).to_s
    assert_equal(abs0,abs2.to_s)
  end
  def test_documented_example
    ario = rio('afile.txt')
    assert_equal('.txt',ario.ext?)
    assert_equal('afile',ario.ext('.txt').basename)
    assert_equal('.txt',ario.ext?)
    assert_equal('afile.txt',ario.ext('.zip').basename)
    assert_equal('.zip',ario.ext?)
    assert_equal('afile.txt',ario.basename('.tar'))
    assert_equal('.tar',ario.ext?)
    assert_equal('afile',ario.ext.basename)
    assert_equal('.txt',ario.ext?)
    assert_equal('afile.txt',ario.noext.basename)
    assert_equal('',ario.ext?)

    ario = rio('afile.tar.gz')
    assert_equal('.gz',ario.ext?)
    assert_equal('afile.tar',ario.basename)
    assert_equal('afile',ario.ext('.tar.gz').basename)
    assert_equal('.tar.gz',ario.ext?)
  end
end
