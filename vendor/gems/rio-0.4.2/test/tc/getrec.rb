#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_getrec < Test::Unit::TestCase
  def test_basic
    qp = rio('qp')
    rio(qp,'getrec').rmtree.mkpath.chdir do
      (0..4).each do |n_lines|
        getrec_each(n_lines)
      end
    end
  end
  def getrec_each(n_lines)
    f = rio('f.txt')
    expa = (0..n_lines-1).map { |a| "Line#{a}\n" }
    f < expa

    f = rio('f.txt')
    assert_equal(expa,f[])
    #  $trace_states = true
    begin
      f = rio('f.txt').nocloseoneof
      ans = []
      while rec = f.getrec
        ans << rec
      end
      assert_equal(expa,ans)
      while rec = f.getrec
        ans << rec
      end
      assert_equal(expa,ans)
    end
    
    begin
      f = rio('f.txt').nocloseoneof
      ans = []
      while rec = f.getrec
        ans << rec
      end
      assert_equal(expa,ans)
      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)
    end
    
    begin
      f = rio('f.txt').nocloseoneof
      ans = []
      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)
      while rec = f.getrec
        ans << rec
      end
      assert_equal(expa,ans)
    end
    
    begin
      f = rio('f.txt')
      ans = []
      while rec = f.getrec
        ans << rec
      end
      assert_equal(expa,ans)
      while rec = f.getrec
        ans << rec
      end
      assert_equal(expa+expa,ans)
    end
    
    begin
      f = rio('f.txt')
      ans = []

      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)

      rec = f.getrec
      assert_equal(expa[0],rec)
    end

    begin
      f = rio('f.txt')
      ans = []

      rec = f.getrec
      assert_equal(expa[0],rec)
      ans << rec unless rec.nil?
      f.each do |rec|
        ans << rec
      end
      rec = f.getrec
      assert_equal(expa[0],rec)
    end

    begin
      f = rio('f.txt')
      ans = []

      (0...n_lines).each do |n|
        rec = f.getrec
        assert_equal(expa[n],rec)
      end
      rec = f.getrec
      assert_nil(rec)

      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)
    end

    begin
      f = rio('f.txt')
      ans = []

      (0...n_lines).each do |n|
        rec = f.getrec
        assert_equal(expa[n],rec)
      end
      f.each do |rec|
        ans << rec
      end
      assert_equal([],ans)
    end
  end
end
