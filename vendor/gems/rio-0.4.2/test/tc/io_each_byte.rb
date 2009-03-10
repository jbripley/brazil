#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_io_each_byte < Test::RIO::TestCase
  @@once = false
  DATA = "012"
  FN_RUBY = 'fruby.txt'
  FN_RIO = 'frio.txt'
  def self.once
    @@once = true
    rio(FN_RUBY) < DATA
    rio(FN_RIO) < DATA
  end
  def setup
    super
    self.class.once unless @@once
  end
  def open_io(&block)
    begin
      fruby = ::File.open(FN_RUBY)
      frio = rio(FN_RIO)
      yield(fruby,frio)
    ensure
      fruby.close
      frio.close
    end
  end
  
  def check_method(fruby,frio,n,sym,*args)
    n.times {
      assert_equal(fruby.__send__(sym,*args),frio.__send__(sym,*args))
      assert_equal(fruby.eof?,frio.eof?)
    }
  end
  def check_calls(fruby,frio,n,*args)
    check_method(fruby,frio,n,:read,*args)
  end
  def check_iter(fruby,frio,sym,*args)
    ans_ruby = []
    ans_rio = []
    fruby.__send__(sym,*args) { |el|
      ans_ruby << el
    }
    frio.__send__(sym,*args) { |el|
      ans_rio << el
    }
    assert_equal(ans_ruby,ans_rio)
  end
  def test_basic
    open_io { |fruby,frio|
      check_iter(fruby,frio,:each_byte)
    }
  end
end
