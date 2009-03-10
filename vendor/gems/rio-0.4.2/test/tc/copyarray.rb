#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_copyarray < Test::Unit::TestCase
  @@once = false
  include RIO_TestCase
  def setup()
    super
    unless @@once
      @@once = true
      rio('a').rmtree.mkpath
      rio('b').rmtree.mkpath
      lines_file(3,'a/f0')
      lines_file(2,'a/f1')
    end
    @d = []; @f = []; @l = [];
    @d[0] = rio('a/')
    @d[1] = rio('b/')
    @f[0] = rio('a/f0')
    @f[1] = rio('a/f1')
    @l[0] = @f[0].readlines
    @l[1] = @f[1].readlines
  end
  def test_copyto_dir
    out = rio('out').delete!.mkpath
    out < @f[0]
    assert(out.directory?)
    assert(@f[0].closed?)
    of = rio(out,@f[0].basename)
    assert_equal(@l[0],of[])
  end
  def test_copyto_dir_a
    out = rio('out').delete!.mkpath
    out < @f
    assert(out.directory?)
    assert(@f[0].closed?)
    assert(@f[1].closed?)
    of = []
    of[0] = rio(out,@f[0].basename)
    of[1] = rio(out,@f[1].basename)
    assert(of[0].file?)
    assert(of[1].file?)
    assert_equal(@l[0],of[0].to_a)
    assert_equal(@l[1],of[1].to_a)
  end
  def test_copyto_dir_files
    out = rio('out').delete!.mkpath
    out < @d[0].files[]
    assert(out.directory?)
    assert(@f[0].closed?)
    assert(@f[1].closed?)
    of = []
    of[0] = rio(out,@f[0].basename)
    of[1] = rio(out,@f[1].basename)
    assert(of[0].file?)
    assert(of[1].file?)
    assert_equal(@l[0],of[0].to_a)
    assert_equal(@l[1],of[1].to_a)
  end
  def test_copyto_dir_dir_array
#  p 'test_copyto_dir'
    @d[1] < @d[0]
    @d[1] < @d[0].files[]
    assert_equal(@l[0],rio(@d[1],@f[0].basename).lines[])
    assert_equal(@l[1],rio(@d[1],@f[1].basename).lines[])
    assert_equal(@l[0],rio(@d[1],@f[0]).lines[])
    assert_equal(@l[1],rio(@d[1],@f[1]).lines[])

    out = rio('out').delete!.mkpath
    assert(out[].empty?)
    out < @d[1].entries[]
    assert_equal(@l[0],rio(out,@f[0].basename).lines[])
    assert_equal(@l[1],rio(out,@f[1].basename).lines[])
    assert_equal(@l[0],rio(out,@f[0]).lines[])
    assert_equal(@l[1],rio(out,@f[1]).lines[])

    out = rio('out').delete!.mkpath
    assert(out[].empty?)
    out < @d[1].to_a
    assert_equal(@l[0],rio(out,@f[0].basename).lines[])
    assert_equal(@l[1],rio(out,@f[1].basename).lines[])
    assert_equal(@l[0],rio(out,@f[0]).lines[])
    assert_equal(@l[1],rio(out,@f[1]).lines[])

    out = rio('out').delete!.mkpath
    assert(out[].empty?)
    out < @d[1][]
    assert_equal(@l[0],rio(out,@f[0].basename).lines[])
    assert_equal(@l[1],rio(out,@f[1].basename).lines[])
    assert_equal(@l[0],rio(out,@f[0]).lines[])
    assert_equal(@l[1],rio(out,@f[1]).lines[])

    out = rio('out').delete!.mkpath
    assert(out[].empty?)
    inputdir = rio(@d[1])
    out < inputdir[]
    assert_equal(@l[0],rio(out,@f[0].basename).lines[])
    assert_equal(@l[1],rio(out,@f[1].basename).lines[])
    assert_equal(@l[0],rio(out,@f[0]).lines[])
    assert_equal(@l[1],rio(out,@f[1]).lines[])

    out = rio('out').delete!.mkpath
    assert(out[].empty?)
    inputdir = rio(@d[1])
    out < inputdir[].map{|el| el.to_s}
    assert_equal(@l[0],rio(out,@f[0].basename).lines[])
    assert_equal(@l[1],rio(out,@f[1].basename).lines[])
    assert_equal(@l[0],rio(out,@f[0]).lines[])
    assert_equal(@l[1],rio(out,@f[1]).lines[])

  end
  def test_copyto_nonex_array_lines
#  p 'test_copyto_dir'
    @d[1] < @d[0]
    @d[1] < @d[0].files[]
    assert_equal(@l[0],rio(@d[1],@f[0].basename).lines[])
    assert_equal(@l[1],rio(@d[1],@f[1].basename).lines[])
    assert_equal(@l[0],rio(@d[1],@f[0]).lines[])
    assert_equal(@l[1],rio(@d[1],@f[1]).lines[])

    out = rio('out').delete!
    assert!(out.exist?)
    out < rio(@d[1]).lines[1]
    assert_equal([@l[0][1],@l[1][1]],out[])

    out = rio('out').delete!
    assert!(out.exist?)
    out < rio(@d[1]).all.lines[1]
    assert_equal([@l[0][1],@l[1][1]] * 2,out[])

  end
  def test_copyto_file_array_lines
#  p 'test_copyto_dir'
    # FIX THIS CRAP
    @d[1] < @d[0]
    @d[1] < @d[0].files[]
    assert_equal(@l[0],rio(@d[1],@f[0].basename).lines[])
    assert_equal(@l[1],rio(@d[1],@f[1].basename).lines[])
    assert_equal(@l[0],rio(@d[1],@f[0]).lines[])
    assert_equal(@l[1],rio(@d[1],@f[1]).lines[])

    out = rio('out').delete!.touch
    assert(out.exist?)
    out < rio(@d[1]).lines[1]
    assert_equal([@l[0][1],@l[1][1]],out[])

    out = rio('out').delete!.touch
    assert(out.exist?)
    out < rio(@d[1]).all.lines[1]
    assert_equal([@l[0][1],@l[1][1]] * 2,out[])

  end
  def test_copyto_nonex
#  p 'test_copyto_nonex'
    out = rio('out').delete!
    out < @f[0]
 #   p @f[0]
    assert(out.file?)
    assert(out.closed?)
    assert(@f[0].closed?)
    assert_equal(@l[0],out[])
  end
  def test_copyto_nonex_array
    out = rio('out').delete!
    #$trace_states = true
    out < @f
    $trace_states = false
    assert(out.directory?)
    assert_equal(smap(@f.map { |el| el.rel(@d[0]) }),smap(out.map { |el| el.rel(out) }))
    assert_equal(@l[0],rio(out,@f[0].filename).to_a)
    assert_equal(@l[1],rio(out,@f[1].filename).to_a)
    #assert_equal(@l[0]+@l[1],out[])
  end
  def test_copyto_nonex_file_lines
  #p 'test_copyto_nonex_a'
    out = rio('out').delete!
    out < @d[0].files.lines
    assert(out.file?)
    assert(out.closed?)
    assert_equal(@l[0]+@l[1],out[])
  end
end
