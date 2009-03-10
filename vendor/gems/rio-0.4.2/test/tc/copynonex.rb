#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_copynonex < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('d0').rmtree.mkpath
    rio('d0/d2').rmtree.mkpath
    rio('d0/d3').rmtree.mkpath
    rio('d0/d4').rmtree.mkpath
    rio('d0/d2/d3').rmtree.mkpath
    rio('d0/d2/d5').rmtree.mkpath
    rio('d0/d3/d6').rmtree.mkpath
    rio('d1').rmtree.mkpath
    rio('d1/d8').rmtree.mkpath
    make_lines_file(1,'d1/f0')
    make_lines_file(2,'d1/f1')
    make_lines_file(1,'d0/f0')
    make_lines_file(2,'d0/f1')
    make_lines_file(1,'d0/d2/f0')
    make_lines_file(2,'d0/d2/f1')
    make_lines_file(1,'d0/d3/d6/f0')
    make_lines_file(2,'d0/d3/d6/f1')
  end
  def setup
    super
    self.class.once unless @@once

    @d0 = rio('d0')
    @d1 = rio('d1')
    @d2 = rio('d0/d2')
    @f0 = rio('d0/f0')
    @f1 = rio('d0/f1')
    @f2 = rio('d0/d2/f2')
    @f3 = rio('d0/d2/f3')
  end
  def assert_dirs_equal(exp,d,msg="")
    exp.each do |ent|
      ds = rio(d,ent.filename)
      assert(ds.exist?,"entry '#{ds}' exists")
      assert_equal(ent.ftype,ds.ftype,"same ftype")
      case
      when ent.file?
        assert(ds.file?,"entry is a file")
        assert_equal(ent[],ds[],"file has same contents")
      when ent.dir?
        assert_dirs_equal(ent,ds,"subdirectories are the same")
      end
    end
  end
  def assert_rios_equal(exp,ans,msg="")
    case
    when exp.file?
      assert(ans.file?,"entry is a file")
      assert_equal(exp.readlines,ans.readlines,"file has same contents")
    when exp.dir?
      assert(ans.dir?,"entry is a dir")
      assert_dirs_equal(exp,ans,"directories are the same")
    end
  end
  def assert_skel_equal(exp,d,msg="")
    exp.each do |ent|
      next unless ent.dir?
      ds = rio(d,ent.filename)
      assert(ds.exist?,"entry '#{ds}' exists")
      assert_equal(ent.ftype,ds.ftype,"same ftype")
      case
      when ent.dir?
        assert_skel_equal(ent,ds,"subdirectories are the same")
      end
    end
  end
  def test_nonex_right_sel
    dst = rio('nonex_ri_sel').delete!
    assert!(dst.exist?)
    src = rio(@d1)
    src.files(/0/) > dst
    p src,dst
#    p smap(dst[])
#    p smap(src.lines[0])
    #assert_dirs_equal(src,dst,"nonex ri")
  end
  def test_nonex_right_dir
    dst = rio('nonex_ri').delete!
    assert!(dst.exist?)
    src = rio(@d1)
    src > dst
    assert_dirs_equal(src,dst,"nonex ri")
  end
  def test_nonex_left_dir
    dst = rio('nonex_le').delete!
    assert!(dst.exist?)
    src = rio(@d1)
    dst < src
    assert_dirs_equal(src,dst,"nonex le")
  end
  def test_nonex_right_file
    dst = rio('nonex_ri_f').delete!
    assert!(dst.exist?)
    src = rio(@f1)
    src > dst
    assert_rios_equal(src,dst,"nonex ri")
  end
  def test_nonex_left_file
    dst = rio('nonex_le_f').delete!
    assert!(dst.exist?)
    src = rio(@f1)
    dst < src
    assert_rios_equal(src,dst,"nonex le")
  end
end
