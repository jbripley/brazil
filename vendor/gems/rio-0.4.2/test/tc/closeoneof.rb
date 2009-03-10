#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_closeoneof < Test::Unit::TestCase
  def test_basic
    qp = rio('qp')
    rio(qp,'test_closeoneof').rmtree.mkpath.chdir {
      exp = []
      f = rio('lines.txt')
      1.upto(3) do |n| 
        s = "Line #{n}\n"
        f.print(s)
        exp << s
      end
      f.close
      exp_s = exp.join('')
      
      rio('dir').mkdir
      rio('dir/a1.txt') < rio('lines.txt')
      rio('dir/a2.txt') < rio('lines.txt')
      
      file = rio('lines.txt')
      lines = file.to_a
      assert_equal(exp,lines)
      assert_equal(true,file.closed?)
      
      file = rio('lines.txt')
      lines = file.readlines
      assert_equal(exp,lines)
      assert_equal(true,file.closed?)
      
      file = rio('lines.txt')
      str = ""
      file.each_line { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(true,file.closed?)

      file = rio('lines.txt')
      str = ""
      file.each_byte { |el| str += el.chr }
      assert_equal(exp_s,str)
      assert_equal(true,file.closed?)

      file = rio('lines.txt')
      str = ""
      file.bytes.each { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(true,file.closed?)

      file = rio('lines.txt')
      str = ""
      file.bytes(3).each { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(true,file.closed?)




      file = rio('lines.txt').nocloseoneof
      lines = file.to_a
      assert_equal(exp,lines)
      assert_equal(false,file.closed?)
      file.close

      file = rio('lines.txt').nocloseoneof
      lines = file.readlines
      assert_equal(exp,lines)
      assert_equal(false,file.closed?)
      file.close

      file = rio('lines.txt').nocloseoneof
      str = ""
      file.each_line { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(false,file.closed?)
      file.close

      file = rio('lines.txt').nocloseoneof
      str = ""
      file.each_byte { |el| str += el.chr }
      assert_equal(exp_s,str)
      assert_equal(false,file.closed?)
      file.close

      file = rio('lines.txt').nocloseoneof
      str = ""
      file.bytes.each { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(false,file.closed?)
      file.close

      file = rio('lines.txt').nocloseoneof
      str = ""
      file.bytes(3).each { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(false,file.closed?)
      file.close

      file = rio('lines.txt')
      str = ""
      file.each { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(true,file.closed?)

      file = rio('lines.txt')
      str = ""
      file.nocloseoneof.each { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(false,file.closed?)
      file.close

      file = rio('lines.txt')
      str = ""
      file.nocloseoneof { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(false,file.closed?)
      file.close

      file = rio('lines.txt')
      str = ""
      file.closeoneof { |el| str += el }
      assert_equal(exp_s,str)
      assert_equal(true,file.closed?)


      file = rio('lines.txt')
      lines = file.nocloseoneof.readlines
      assert_equal(exp,lines)
      assert_equal(false,file.closed?)
      file.close
      
      file = rio('lines.txt').nocloseoneof
      lines = file.to_a
      assert_equal(false,file.closed?)
      file.close

      rio('dir').each { |en|
        lines = en.to_a
        assert_equal(exp,lines)
        assert_equal(true,en.closed?)
      }

      rio('dir').nocloseoneof.each { |en|
        lines = en.to_a
        assert_equal(exp,lines)
        assert_equal(false,en.closed?)
        en.close
      }

      rio('dir').nocloseoneof.each { |en|
        lines = en.closeoneof.to_a
        assert_equal(exp,lines)
        assert_equal(true,en.closed?)
      }

      rio('dir').closeoneof.each { |en|
        lines = en.nocloseoneof.to_a
        assert_equal(exp,lines)
        assert_equal(false,en.closed?)
        en.close
      }


      rio('dir').nocloseoneof { |en|
        lines = en.to_a
        assert_equal(exp,lines)
        assert_equal(false,en.closed?)
        en.close
      }

      rio('dir').nocloseoneof { |en|
        lines = en.closeoneof.to_a
        assert_equal(exp,lines)
        assert_equal(true,en.closed?)
      }

      rio('dir').closeoneof { |en|
        lines = en.nocloseoneof.to_a
        assert_equal(exp,lines)
        assert_equal(false,en.closed?)
        en.close
      }


    }
  end
    
end
