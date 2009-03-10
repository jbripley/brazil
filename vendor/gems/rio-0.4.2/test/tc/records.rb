#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_records < Test::Unit::TestCase
  def assert!(a,msg="negative assertion")
    assert((!(a)),msg)
  end
  def smap(a) a.map { |el| el.to_s } end
  def tdir() rio(%w/qp records/) end
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

  def test_procs
    rio('lineno').delete!.mkpath.chdir

    file = mkalinesfile(8,'f1')
    lines = file[]
    (2..4).each do |n|
      lines[n] = '#' + lines[n]
    end
    (0..3).each do |n|
      lines[n].sub!(/f1/,'f2')
    end
    file < lines
    exp = lines[0..0] + lines[2..4]

    # iterate over the first line and comment lines
    ans = file.lines[0,/^\s*#/]
    assert_equal(exp,ans)
                       
    ans = file.lines[proc { |rec,rnum,rio| rnum == 0 || rec =~ /^\s*#/ }]
    assert_equal(exp,ans)

    exp = lines[0..0] + lines[2...8]
    ans = file.lines[0,/^\s*#/,proc { |rec,rnum,ario| rec =~ /#{ario.filename}/ }]
    assert_equal(exp,ans)
    
#    $trace_states = true



    file.close
    rio('..').chdir
  end
end
