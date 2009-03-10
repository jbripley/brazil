#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_pid < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
  end
  def test_likeio
    cmd = 'ruby -v'
    ios = File.popen(cmd)
    assert(ios.pid)
    ios_lines = ios.readlines

    ior = rio(?-,cmd)
    assert(ior.pid)
    ior_lines = ior.readlines
    
    assert_equal(ios_lines,ior_lines)
  end

end
