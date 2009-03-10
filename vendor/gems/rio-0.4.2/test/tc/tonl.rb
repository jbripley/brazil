#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_tonl < Test::RIO::TestCase
  @@once = false
  CRNLFILE = 'hw.crnl.txt'
  NLFILE = 'hw.nl.txt'
  STR = "Hello World\r\n"
  require 'tc/programs_util'
  include Test::RIO::Programs

  def self.once
    @@once = true
    rio(CRNLFILE) <  STR * 2
 end
  def setup
    super
    self.class.once unless @@once
  end

  def test_1
    out = rio.strio
    rio(CRNLFILE) > out
    lines = rio(CRNLFILE).to_a
    assert_equal(13,lines[0].length)
    rio(NLFILE) < rio(CRNLFILE).chomp.map{ |l| "#{l}\n" }
    lines = rio(NLFILE).to_a
    assert_equal(12,lines[0].length)
  end

end
