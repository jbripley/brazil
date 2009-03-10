#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_iometh < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
  end
  def test_file
    (0..4).each do |n_lines|
      get_each(n_lines)
    end
  end
  def get_each(n_lines)
    f = rio('f.txt')
    expa = (0..n_lines-1).map { |a| "Line#{a}\n" }
    f < expa
    
    f = rio('f.txt')
    assert_equal(expa,f[])
    #  $trace_states = true

    # iterate twice using #get (no auto close)
    begin
      f = rio('f.txt').nocloseoneof
      ans = []
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
    end

    # iterate using #get then using #each (no auto close)
    begin
      f = rio('f.txt').nocloseoneof
      ans = []
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)
    end
    
    # iterate using #each then using #get (no auto close)
    begin
      f = rio('f.txt').nocloseoneof
      ans = []
      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
    end
    
    # iterate twice using #get (with auto close)
    begin
      f = rio('f.txt')
      ans = []
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
      while rec = f.get
        ans << rec
      end
      assert_equal(expa+expa,ans)
    end
    
    # assure get returns nil once after iteration using #get (with auto close)
    begin
      f = rio('f.txt')
      ans = []

      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)

      rec = f.get
      assert_equal(expa[0],rec)
    end

    begin
      f = rio('f.txt')
      ans = []

      rec = f.get
      assert_equal(expa[0],rec)
      ans << rec unless rec.nil?
      f.each do |rec|
        ans << rec
      end
      rec = f.get
      assert_equal(expa[0],rec)
    end

    begin
      f = rio('f.txt')
      ans = []

      (0...n_lines).each do |n|
        rec = f.get
        assert_equal(expa[n],rec)
      end
      rec = f.get
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
        rec = f.get
        assert_equal(expa[n],rec)
      end
      assert(f.eof?)
      f.each do |rec|
        ans << rec
      end
      assert_equal([],ans)
    end
  end
end
