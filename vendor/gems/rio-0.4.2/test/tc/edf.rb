#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_edf < Test::Unit::TestCase
  def tdir() rio(%w/qp edf/) end
  def assert!(a,msg="negative assertion")
    assert((!(a)),msg)
  end
  def smap(a) a.map{|el| el.to_s} end
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
    unless @once
      @once = true
      tdir.delete!.mkpath.chdir do
        mkafile('f1.txt')
        mkafile('f2.asc')
        rio('d0').mkdir
        rio('d1').mkdir.chdir do
          mkafile('f0.txt')
        end
        rio('d2').mkdir.chdir do
          mkafile('f1.asc')
          mkafile('f1.txt')
          mkafile('f2.txt')
          rio('d3').mkdir.chdir do
            mkafile('f0.txt')
            mkafile('f2.txt')
            mkafile('f1.txt')
          end
        end
      end
    end
    @cwd = ::Dir.getwd
    tdir.mkpath.chdir
  end
  def teardown
    ::Dir.chdir @cwd
  end

  def test_basic

    ans = rio('d2').files[]
    p smap(ans)
    ans.clear
    $trace_states = false
    rio('d2').files(/\.txt$/).each { |ent| ans << ent }
    $trace_states = false

    p smap(ans)

    ans = rio('d2').files(/\.txt$/)[]
    p smap(ans)

    ans = rio('d2').files[/\.txt$/]
    p smap(ans)

    ans = rio('d2').files('*.txt')[]
    p smap(ans)

    ans = rio('d2').files['*.txt']
    p smap(ans)

  end
end
