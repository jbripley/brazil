#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_copydir < Test::RIO::TestCase
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

    @d0 = rio('d0/')
    @d1 = rio('d1/')
    @d2 = rio('d0/d2/')
    @f0 = rio('d0/f0')
    @f1 = rio('d0/f1')
    @f2 = rio('d0/d2/f2')
    @f3 = rio('d0/d2/f3')
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
  def test_basic
    dst = rio('dst').delete!.mkpath
    dst < @d0
    
    assert_dirs_equal(@d0,rio(dst,@d0.filename),"basic copy")
  end
  def test_dirs_only
    dst = rio('dirs_only').delete!.mkpath
    dst < @d0.dirs
    assert_skel_equal(@d0,rio(dst,@d0.filename),"copy dirs only")
  end
  def test_files_only
    dst = rio('files_only').delete!.mkpath
    src = rio(@d0).files
    dst < src
    exp = @d0.files[]
    dd = rio(dst,@d0.filename)
    ans = dd.map { |e| e.rel(dst) }
    assert_array_equal(exp,ans,"copy files only")
  end
  def test_files_dirs
    dst = rio('files_dirs').delete!.mkpath
    src = rio(@d0).files.dirs
    dst < src
    assert_dirs_equal(@d0,rio(dst,@d0.filename),"copy files dirs")
  end
  def test_dirs_somefiles
    dst = rio('dirs_somefiles').delete!
    src = rio(@d0).files(/0/).dirs
    #$trace_states = true
    src > dst
    $trace_states = false
    ans = dst.all.map { |e| e.rel(dst) }
    exp = rio(@d0).all.map { |e| e.rel(@d0) }.select { |e| e !~ /f[^0]$/ }
    assert_array_equal(exp,ans,"dirs somefiles")
    
  end
  def test_somedirs_somefiles
    dst = rio('somedirs_somefiles').delete!
    src = rio(@d0).files(/0/).dirs('d[36]')
    src > dst
    ans =  smap(dst.all[].map { |e| e.rel(dst) })
    exp = %w[d3 d3/d6 d3/d6/f0 f0]
    assert_array_equal(exp,ans)
  end
  def test_nonex_ri
    dst = rio('nonex_ri').delete!
    assert!(dst.exist?)
    src = rio(@d1)
    src > dst
    assert_dirs_equal(src,dst,"nonex ri")
  end
  def test_nonex_le
    dst = rio('nonex_le').delete!
    assert!(dst.exist?)
    src = rio(@d1)
    dst < src
    assert_dirs_equal(src,dst,"nonex le")
  end
  def test_files_a_dir
    dst = rio('files_a_di').delete!.mkpath
    dst < @d0.files[]
    assert_array_equal(%w[f0 f1],dst.map { |el| el.rel(dst) })
  end
  def test_files_a_file
    dst = rio('files_a_fi').delete!.touch
    dst < @d0.files[]
    exp = %w[f0 f1].inject([]) { |lines,f| lines + rio(@d0,f).readlines }
    assert_equal(exp,dst.readlines)
  end
  def test_files_a_nonex
    dst = rio('files_a_nonex').delete!
    src = @d0[]
    assert_kind_of(::Array,src)
    dst < src
    assert(dst.dir?)
    assert_equal(smap(src.map { |el| el.rel(@d0) }),smap(dst.map { |el| el.rel(dst) }))
    src.each do |el|
      assert_rios_equal(el,rio(dst,el.filename))
    end
    assert_rios_equal(@d0,dst)
  end
  def test_files_a_nonex_files
    dst = rio('files_a_nonex_files').delete!
    src = @d0.files[]
    assert_kind_of(::Array,src)
    dst < src
    assert(dst.dir?)
    assert_equal(smap(src.map { |el| el.rel(@d0) }),smap(dst.map { |el| el.rel(dst) }))
    src.each do |el|
      assert_rios_equal(el,rio(dst,el.filename))
    end
#    assert_dirs_equal(src,dst,"array of files to nonex")
  end
  def test_files_a_nonex_lines
    dst = rio('files_a_nonex_l').delete!
    src = @d0.lines[]
    assert_kind_of(::Array,src)
    dst < src
    assert(dst.file?)
    assert_equal(src,dst.readlines)
  end
  def test_tofile
    dst = rio('dst').delete!.touch
    exp = ($mswin32 ? Errno::ENOENT : Errno::ENOTDIR)
    assert_raise(exp) {
      @d0 > dst
    }
  end
end
