#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_copylines < Test::RIO::TestCase
  @@once = false
  STR = 'peter piper picked a peck of pickled peppers'
  WORDS = STR.split(/\s+/)
  LINE = WORDS.map { |w| w+"\n" }.join('')
  def self.once
    @@once = true
    src = rio('src').print!(LINE)
  end
  def setup
    super
    self.class.once unless @@once
  end
  def test_basic
    out = rio(?")
    rio('src').chomp.lines(/^[^p]/) > out
    assert(out.closed?, "copy closed")

    assert_equal('aof',out.contents)
    
    out < rio('src').lines(/^[^p]/)
    assert_equal("a\nof\n",out.contents)
    
    aout = Array.new
    rio('src').chomp.lines(1,4..6) > aout
    assert_equal(%w{piper peck of pickled},aout)
    
    out < rio('src').chomp.lines(0..1)
    assert_equal("peterpiper",out.contents)
    
    rio('src').chomp.lines(0..1) > aout
    assert_equal(%w{peter piper},aout)

    rio('src').chomp.lines(0..1) >> aout
    assert_equal(%w{peter piper peter piper},aout)
  end
end
