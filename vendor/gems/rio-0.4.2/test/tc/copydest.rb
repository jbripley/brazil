#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'

class TC_RIO_copydest < Test::Unit::TestCase
  def test_copydest
    qp = RIO.rio('qp')
    rio(qp,'test_copydest').rmtree.mkpath.chdir {
      expary = ["Line0\n","Line1\n","Line2\n"]
      line = expary.to_s
      src = rio('src').print!(line)
      
      ary = Array.new
      $trace_states = false
      rio('src') > ary
      $trace_states = false
      assert_equal(expary,ary)

      rio('src') > ary
      assert_equal(expary,ary)
      rio('src') >> ary
      assert_equal(expary+expary,ary)
      
      a0 = ["Zippy0\n"]
      rio('dst0') < a0
      assert_equal(a0,rio('dst0').to_a)
      
      a1 = ["Zippy1\n"]
      rio('dst0') << a1
      assert_equal(a0+a1,rio('dst0').to_a)
      a2 = a0 + a1 + [ rio('src') ]
      rio('dst2') < a2
      assert_equal(a0+a1+expary,rio('dst2').to_a)
      a3 = [ "Lastline\n" ]
      rio('dst2') << a3
      assert_equal(a0+a1+expary+a3,rio('dst2').to_a)
      
      lA,lT,lZ = "lineA\n","ALineOfText\n","lineZ\n"
      
      rio('src1').puts!(lT)
      rio('src1') < [lT]
      assert_equal([lT],rio('src1').to_a)
      
    }
  end
end
