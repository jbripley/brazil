#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_cd1 < Test::RIO::TestCase
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
  def test_d2a
    src = rio(@d1)
    dst = []
#    dst < src
    #$trace_states = true
    src > dst
    $trace_states = false
    p smap(src[])
    p smap(dst.inspect)

  end
  def test_d2b
    src = rio(@d1)
    dst = []
#    dst < src
    #$trace_states = true
    src.each do |e|
      dst << e
    end
    $trace_states = false
    p smap(src[])
    p smap(dst.inspect)

  end
  def a0test_nonex
    dst = rio('nonex').delete!
    assert!(dst.exist?)
    src = rio(@d1)
#    dst < src
    #$trace_states = true
    src > dst
    $trace_states = false
#    p smap(dst.all[].map { |e| e.rel(dst) })
    #p smap(src.all[])
    #p smap(dst.all[])
#    assert_dirs_equal(@d0,rio(dst,@d0.filename),"basic copy")
#    exp = @d0.files[]
#    dd = rio(dst,@d0.filename)
#    ans = dd.map { |e| e.rel(dst) }
#    p smap(exp)
#    p smap(ans)
#    assert_array_equal(exp,ans,"copy files only")
  end
end
