#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_splitlines < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
    @str = "a,b,c,d\n"
    @infile = rio('infile') < @str * 3
  end
  def test_get
    ans = rio(@infile).split(',').get
    exp = @str.split(',')
    assert_equal(exp,ans)
    ans = rio(@infile).chomp.split(',').get
    exp = @str.chop
    exp = exp.split(',')
    assert(exp,ans)
  end
  def test_each
    exp = @str.chomp.split(',')
    @infile.chomp.split(',') { |ary|
      assert_equal(exp,ary)
    }
  end
  def test_copy_array_in
    expstr = @str.chomp.split(',').join(':')
    exp = rio(?").puts(expstr).puts(expstr).puts!(expstr)
    aoa = rio(@infile).split(',')[]
    rio('ans').split(':') < aoa
    ans = rio('ans')
    assert_equal(exp.chomp[],ans.chomp[])
  end
  def test_copy_array_out
    expary = @str.chomp.split(',')
    exp = [expary,expary,expary]
    aoa = []
    rio(@infile).chomp.split(',') > aoa
    assert_equal(exp,aoa)
  end
  def test_copy_left
    expstr = @str.chomp.split(',').join(':')
    exp = rio(?").puts(expstr).puts(expstr).puts!(expstr)
    rio('ans').split(':') < rio(@infile).split(',')
    ans = rio('ans')
    assert_equal(exp.chomp[],ans.chomp[])
  end
  def test_copy_right
    expstr = @str.chomp.split(',').join(':')
    exp = rio(?").puts(expstr).puts(expstr).puts!(expstr)
    rio(@infile).split(',') > rio('ans').split(':')
    ans = rio('ans')
    assert_equal(exp.chomp[],ans.chomp[])
  end
end
