#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_copydirlines < Test::RIO::TestCase
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
    make_lines_file(3,'d1/f0')
    make_lines_file(2,'d1/f1')
    make_lines_file(3,'d0/f0')
    make_lines_file(2,'d0/f1')
    make_lines_file(3,'d0/d2/f0')
    make_lines_file(2,'d0/d2/f1')
    make_lines_file(3,'d0/d3/d6/f0')
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
  def ztest_basic
    dst = rio('dst').delete!.mkpath
    dst < @d0
    
    assert_dirs_equal(@d0,rio(dst,@d0.filename),"basic copy")
  end
  def test_files
    dst = rio('files').delete!.mkdir
    src = rio(@d1).files.lines(0)
    #$trace_states = true
    src > dst
    src.dup.files.each do |file|
      assert_equal(file[0],rio(dst,file).to_a)
    end
  end
  def test_files2
    dst = rio('files').delete!.mkdir
    src = rio(@d1).files.lines(0)
    #$trace_states = true
    dst < src
    src.dup.files.each do |file|
      assert_equal(file[0],rio(dst,file).to_a)
    end
  end
  def test_array
    src = rio(@d1).files.lines
    exp = src.to_a
    dst = []
    src > dst
    assert_equal(exp,dst)
    src >> dst
    assert_equal(exp+exp,dst)
  end
  def ztest_somedirs_somefiles
    dst = rio('somedirs_somefiles').delete!
    src = rio(@d0).files(/0/).dirs('d[36]')
    src > dst
    ans =  smap(dst.all[].map { |e| e.rel(dst) })
    exp = %w[d3 d3/d6 d3/d6/f0 f0]
    assert_array_equal(exp,ans)
  end
end
