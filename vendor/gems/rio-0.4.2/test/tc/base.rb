#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_base < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
  end
  def test_basic
    r = rio('zippy',{:base => '/'})
    assert_equal('/zippy',r.abs.path)
  end
  def test_2args
    r = rio('tmp','zippy',{:base => '/'})
    assert_equal('/tmp/zippy',r.abs.path)
  end
  def test_longer_base
    r = rio('zippy',{:base => '/tmp/'})
    assert_equal('/tmp/zippy',r.abs.path)
  end
end
