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
    end
  end
  def ztest_simple
#  p 'test_copyto_dir'
    d = rio('tdir').delete!.mkpath
    p d[]
    p d[]
  end
  def ztest_o
#  p 'test_copyto_dir'
    d = rio('tdir').delete!.mkpath
    f = rio(d,'f').touch
    sd = rio(d,'sd').mkpath
    p d[]
    d.files.each do |ent|
      #ent.extname = '.txt'
      p "#{ent} #{ent.ftype}"
    end
  end
  def ztest_each
#  p 'test_copyto_dir'
    d = rio('tdir').delete!.mkpath
    f = rio(d,'f').touch
    sd = rio(d,'sd').mkpath
    d.entries.each do |ent|
      p "#{ent} #{ent.ftype}"
    end
    d.files.each do |ent|
      #ent.extname = '.txt'
      p "#{ent} #{ent.ftype}"
    end
  end
  def test_dirs_files
#  p 'test_copyto_dir'
    d = rio('tdir').delete!.mkpath
    f = rio(d,'f').touch
    sd = rio(d,'sd').mkpath
    d.dirs.each do |ent|
      p "#{ent} #{ent.ftype}"
    end
    d.files.each do |ent|
      #ent.extname = '.txt'
      p "#{ent} #{ent.ftype}"
    end
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
