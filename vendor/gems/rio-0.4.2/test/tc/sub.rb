#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
class TC_sub < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('a').rmtree.mkpath
    rio('b').rmtree.mkpath
    make_lines_file(3,'a/f0')
    make_lines_file(2,'a/f1')
  end
  def setup
    super
    self.class.once unless @@once

    @l = []; @f = []; @d = []
    @d[0] = rio('a')
    @d[1] = rio('b')
    @f[0] = rio('a/f0')
    @f[1] = rio('a/f1')
    @l[0] = @f[0].readlines
    @l[1] = @f[1].readlines
    @d[1] < @d[0]
    @d[1] < @d[0].files[]
  end
  def test_basic
    ario = rio('apath')
    p ario

    ans = ario.sub(/^a/,'b')
    assert_kind_of(RIO::Rio,ans)
    assert_not_same(ario,ans)
    assert_equal(rio('bpath'),ans)

    ans = ario.sub!(/^a/,'b')
    assert_kind_of(RIO::Rio,ans)
    assert_same(ario,ans)
    assert_equal(rio('bpath'),ans)
  end
end
