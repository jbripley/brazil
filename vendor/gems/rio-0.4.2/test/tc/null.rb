#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_null < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
  end
  def compare_rtn(sym,*args)
    r1 = rio('/dev/null')
    r2 = rio(nil)
    rtn1 = r1.__send__(sym,*args)
    rtn2 = r2.__send__(sym,*args)
    assert_equal(rtn1,rtn2)
  end
  
  def compare_raiseeof(sym,*args)
    r1 = rio('/dev/null')
    r2 = rio(nil)
    assert_raise(EOFError) { r1.__send__(sym,*args) }
    assert_raise(EOFError) { r2.__send__(sym,*args) }
  end
  
  def test_gets() compare_rtn(:gets) end
  def test_lineno() compare_rtn(:lineno) end
  def test_lineno_assign() compare_rtn(:lineno=,20) end
  def test_pos() compare_rtn(:pos) end
  def test_pos_assign() compare_rtn(:pos=,20) end
  def test_read() compare_rtn(:read) end
  def test_readl() compare_rtn(:read,1) end
  def test_readline() compare_raiseeof(:readline) end
  def test_readlines() compare_rtn(:readlines) end
  def test_readchar() compare_raiseeof(:readchar) end
  
end
