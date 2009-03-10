#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_readline < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
  end
  def test_readline_like_IO
    frio = rio('frio') < (0..1).map{ |i| "Line #{i}\n" }
    rio('fruby') < frio
    fruby = File.open('fruby');
    assert_equal(fruby.readline,frio.readline)
    assert_equal(fruby.readline,frio.readline)
    assert_raise(EOFError) { fruby.readline }
    assert_raise(EOFError) { frio.readline  }

    
  end
end
