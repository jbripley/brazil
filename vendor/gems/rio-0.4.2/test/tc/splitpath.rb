#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_splitpath < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
  end
  def test_basic
    r = rio('b/c/d')
    ary = r.split
    assert_equal([rio('b'),rio('c'),rio('d')],ary)
    assert_equal(r,ary.to_rio)
  end
  def test_abs_ne
    r = rio('/a/b/c/d')
    ary = r.split
    assert_equal([rio('/'),rio('a'),rio('b'),rio('c'),rio('d')],ary)
    assert_equal(r,ary.to_rio)
    assert_equal(rio('d'),ary[-1])
    assert_equal(r,ary[-1].abs)
    assert_equal(ary[-1].abs.dirname,ary[-2].abs)
    assert_equal(ary[-2].abs.dirname,ary[-3].abs)
  end
  def test_abs_drive
    return unless $mswin32
    r = rio('q:/a/b')
    ary = r.split
    exp = [rio('q:/'),rio('a'),rio('b')]
    assert_equal(exp,ary)
    assert_equal(r,ary.to_rio)
    assert_equal(rio('b'),ary[-1])
    assert_equal(r,ary[-1].abs)
    assert_equal(ary[-1].abs.dirname.to_s,ary[-2].abs.to_s)
    assert_equal(ary[-2].abs.dirname.to_s,ary[-3].abs.to_s)
  end
  def test_abs_host
    r = rio('//ahost/a/b/c')
    ary = r.split
    exp = [rio('file://ahost/'),rio('a'),rio('b'),rio('c')]
    #p "ary=#{ary.inspect} exp=#{exp.inspect}"
    assert_equal(exp,ary)
    assert_equal(r,ary.to_rio)
    assert_equal(rio('c'),ary[-1])
    assert_equal(r,ary[-1].abs)
    #p ary[-1].abs
    #p ary[-1].abs.dirname
    assert_equal(ary[-1].abs.dirname.to_s,ary[-2].abs.to_s)
    assert_equal(ary[-2].abs.dirname.to_s,ary[-3].abs.to_s)
  end
  def test_abs_url
    r = rio('file://ahost/a/b/c')
    ary = r.split
    exp = [rio('file://ahost/'),rio('a'),rio('b'),rio('c')]
    assert_equal(exp,ary)
    assert_equal(r,ary.to_rio)
    assert_equal(rio('c'),ary[-1])
    assert_equal(r,ary[-1].abs)
    assert_equal(ary[-1].abs.dirname.to_s,ary[-2].abs.to_s)
    assert_equal(ary[-2].abs.dirname,ary[-3].abs)
  end
  def test_rel
    r = rio('a/b/c')
    ary = r.split
    exp = [rio('a'),rio('b'),rio('c')]
    assert_equal(exp,ary)
    assert_equal(r,ary.to_rio)
    assert_equal(rio('c'),ary[-1])
    assert_equal(r.abs,ary[-1].abs)
    assert_equal(ary[-1].abs.dirname,ary[-2].abs)
    assert_equal(ary[-2].abs.dirname,ary[-3].abs)
  end
end
