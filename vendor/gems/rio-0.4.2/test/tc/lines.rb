#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_lines < Test::Unit::TestCase
  def test_basic
    qp = rio('qp')

    rio(qp,'test_lines').rmtree.mkpath.chdir {
      
      f = rio('basic.txt')
      0.upto(6) do |n|
        f.puts("L#{n}: #{n*3}:#{n*2}")
      end
      f.puts!("Line Z")
      
      expa = ["L0: 0:0\n", "L1: 3:2\n", "L2: 6:4\n", "L3: 9:6\n", "L4: 12:8\n", "L5: 15:10\n", "L6: 18:12\n", 
              "Line Z\n"]
      
      ans = []
      
      rio('basic.txt').lines { |line| ans.push(line) }
      assert_equal(expa,ans)
      ans.clear
      
      rio('basic.txt').lines.each { |line| ans.push(line) }
      assert_equal(expa,ans)
      ans.clear
      
      rio('basic.txt').each { |line| ans.push(line) }
      assert_equal(expa,ans)
      ans.clear
      
      # proxy of IO#each_line -- lines() is ignored
      rio('basic.txt').each_line { |line| ans.push(line) }
      assert_equal(expa,ans)
      ans.clear
      
      assert_equal(expa,rio('basic.txt').lines.to_a)
      assert_equal(expa,rio('basic.txt').to_a)
      
      
      expa = ["L1: 3:2\n", "L2: 6:4\n", "L4: 12:8\n", "L6: 18:12\n"]
      assert_equal(expa,rio('basic.txt').lines(/2/).to_a)
      
      expa = ["L0: 0:0\nL1: 3:2\nL2: 6:4\nL3: 9:6\n", "L4: 12:8\nL5: 15:10\nL6: 18:12\nLin", "e Z\n"]
      assert_equal(expa,rio('basic.txt').bytes(32).to_a)
      
#      expa = [["15", "10"], ["18", "12"]]
#      assert_equal(expa,rio('basic.txt').lines(/(\d\d):(\d\d)/).to_a)
      
#      ans = []
#      rio('basic.txt').lines(/(\d\d):(\d\d)/) { |ary|
#        ans.push(ary)
#      }
#      assert_equal(expa,ans)
    }
  end
  
end
  
