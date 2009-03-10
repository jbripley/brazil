#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'tc/testcase'
require 'pp'

class TC_truncate < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true

  end

  def setup
    super
    self.class.once unless @@once

  end

  def test_basic
    str = "1234567890"
    f = rio("out")
    f.print!(str)
    assert_equal(str,f.contents)
    assert_equal(str.size,f.size)
    n = 5
    f.truncate(n)
    assert_equal(str[0,n],f.contents)
    assert_equal(n,f.size)
    n = 2
    assert_equal(str[0,n],f.read(n))
    assert_equal(n,f.truncate.size)
    assert_equal(str[0,n],f.contents)
  end

end
