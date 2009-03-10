#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_io_read < Test::RIO::TestCase
  @@once = false
  DATA = "012345"
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
  def test_positive_integer
    open_io { |fruby,frio|
      check_calls(fruby,frio,3,3)
    }
    open_io { |fruby,frio|
      check_calls(fruby,frio,2,4)
    }
    open_io { |fruby,frio|
      check_calls(fruby,frio,2,7)
    }
  end
  def test_positive_integer_buffer
    open_io { |fruby,frio|
      buffer = ""
      check_calls(fruby,frio,1,3,buffer)
      assert_equal(DATA[0...3],buffer)
      check_calls(fruby,frio,1,3,buffer)
      assert_equal(DATA[3...6],buffer)
    }
    open_io { |fruby,frio|
      check_calls(fruby,frio,2,4)
    }
    open_io { |fruby,frio|
      check_calls(fruby,frio,2,7)
    }
  end
  def test_nil
    open_io { |fruby,frio|
      check_calls(fruby,frio,2,nil)
    }
  end
  def test_noarg
    open_io { |fruby,frio|
      check_calls(fruby,frio,2)
    }
  end
end
