#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TestData
  attr_reader :fn_ruby,:fn_rio,:data
  def initialize(prefix,data)
    @data = data
    @fn_ruby = prefix + 'ruby.dat'
    @fn_rio = prefix + 'rio.dat'
    rio(@fn_ruby) < @data
    rio(@fn_rio) < @data
  end
end

class TC_likeio < Test::RIO::TestCase
  @@once = false
  @@data = {}
  def self.once
    @@once = true
    @@data['bytes'] = TestData.new('bytes_',"012")
    @@data['lines'] = TestData.new('lines_',"Line0\nLine1\n")
  end
  def setup
    super
    self.class.once unless @@once
  end
  def open_data(td,&block)
    begin
      fruby = ::File.open(td.fn_ruby)
      frio = rio(td.fn_rio)
      yield(fruby,frio)
    ensure
      fruby.close
      frio.close
    end
  end
  
  def check_read_method(fruby,frio,n,sym,*args)
    #$trace_states = true
    n.times {
      exp = fruby.__send__(sym,*args)
      ans = frio.__send__(sym,*args)
      assert_equal(exp,ans)
      assert_equal(fruby.eof?,frio.eof?)
    }
    #$trace_states = false
  end

  def check_read_method_raises_eof(fruby,frio,n,sym,*args)
    n.times {
      ruby_raises = false
      rio_raises = false
      ruby_returns = nil
      rio_returns = nil
      begin
        ruby_returns = fruby.__send__(sym,*args)
      rescue EOFError
        ruby_raises = true
      end
      begin
        rio_returns = frio.__send__(sym,*args)
      rescue EOFError
        rio_raises = true
      end
      assert_equal(ruby_raises,rio_raises)
      assert_equal(ruby_returns,rio_returns)
    }
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
  def test_each_byte
    open_data(@@data['bytes']) { |fruby,frio|
      check_iter(fruby,frio,:each_byte)
    }
  end
  def test_each_line
    open_data(@@data['lines']) { |fruby,frio|
      check_iter(fruby,frio,:each_line)
    }
  end
  def test_gets
    open_data(@@data['lines']) { |fruby,frio|
      check_read_method(fruby,frio,3,:gets)
    }
    open_data(@@data['lines']) { |fruby,frio|
      check_read_method(fruby,frio,4,:gets,'e')
    }
  end
  def test_getc
    open_data(@@data['bytes']) { |fruby,frio|
      check_read_method(fruby,frio,4,:getc)
    }
  end
  def test_readchar
    testdata = @@data['bytes'] 
    open_data(testdata) { |fruby,frio|
      check_read_method_raises_eof(fruby,frio,testdata.data.size+1,:readchar)
    }
  end
end
