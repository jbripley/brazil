#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_split < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
  end
  def test_type
    rtn = rio('a/b/c').split
    assert_kind_of(::Array,rtn)
    for el in rtn
      assert_kind_of(RIO::Rio,el)
    end
    rtn = rio('hw.txt')
    assert_kind_of(RIO::Rio,rtn)
  end
end
