#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_clearsel < Test::Unit::TestCase
  def tdir() rio(%w/qp clearsel/) end
  def assert!(a,msg="negative assertion")
    assert((!(a)),msg)
  end
  def smap(a) a.map { |el| el.to_s } end
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

  def test_basic
    rio('a').delete!.mkpath.chdir

    file = mkalinesfile(8,'f1')
    lines = file[]
    cmnt_range = (2..4)
    cmnt_range.each do |n|
      lines[n] = '#' + lines[n]
    end
    (0..3).each do |n|
      lines[n].sub!(/f1/,'f2')
    end
    file < lines

    f0 = file.dup
    begin
      exp = lines[cmnt_range]
      ans = f0.lines[/^\s*#/]
      assert_equal(exp,ans)
      ans = f0[0]
      assert_equal(lines[0..0],f0[0])
      assert_equal(lines,f0[])
      assert_equal(lines[1..2],f0[1..2])
      assert_equal(lines,f0.lines(1..2)[])
      assert_equal(lines[4..4],f0.lines(1..2)[4])

    end


    file.close
    rio('..').chdir
  end
end
