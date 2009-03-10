#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_dirss < Test::Unit::TestCase
  include RIO_TestCase
  def setup()
    super
    unless @once
      @once = true
      @l = []; @f = []; @d = []
      @d[0] = rio('a').rmtree.mkpath
      @d[1] = rio('b').rmtree.mkpath
      #$trace_states = false
      #$trace_states = true
      @l[0],@f[0] = lines_file(3,'a/f0')
      @l[1],@f[1] = lines_file(2,'a/f1')
      @d[1] < @d[0]
      @d[1] < @d[0].files[]
    end
  end
  def test_rename_add_ext_check_
#  p 'test_copyto_dir'
    assert_equal(@l[0],rio(@d[1],@f[0].basename).lines[])
    assert_equal(@l[1],rio(@d[1],@f[1].basename).lines[])
    rio('tdir').delete!.mkpath < rio(@d[1]).to_a
    indir = rio('tdir')
    #indir = @d[1]
    $trace_states = true
    p indir.map{|el| el.to_s}
    ary = indir[]
    #p ary.map{|el| el.to_s}
    p indir,indir.ioh
    newext = '.txt'
    indir.files.rename.each { |ent|
      ent.extname = newext
    }
    $trace_states = false
    assert_equal(@l[0],rio(indir,@f[0].basename.to_s + newext).lines[])
    assert_equal(@l[1],rio(indir,@f[1].basename.to_s + newext).lines[])
  end
  def atest_rename_add_ext_check_
#  p 'test_copyto_dir'
    assert_equal(@l[0],rio(@d[1],@f[0].basename).lines[])
    assert_equal(@l[1],rio(@d[1],@f[1].basename).lines[])
    rio('tdir').delete!.mkpath < rio(@d[1]).to_a
    indir = rio('tdir')
    #indir = @d[1]
    $trace_states = true
    p indir.map{|el| el.to_s}
    ary = indir[]
    #p ary.map{|el| el.to_s}
    p indir,indir.ioh
    newext = '.txt'
    indir.files.rename.each { |ent|
      ent.extname = newext
    }
    $trace_states = false
    assert_equal(@l[0],rio(indir,@f[0].basename.to_s + newext).lines[])
    assert_equal(@l[1],rio(indir,@f[1].basename.to_s + newext).lines[])
  end
end
