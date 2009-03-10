#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_route < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
  end
  def test_rf_file
    a = rio("file://ahost/a/")
    extra = rio('b')/'c'
    c = a/extra
    rf = c.route_from(a)
    assert_equal(extra,rf)
    assert_equal(c,rf.abs)
  end
  def test_rf_drive
    a = rio("q:/a/")
    extra = rio('b')/'c'
    c = a/extra
    rf = c.route_from(a)
    assert_equal(extra,rf)
    assert_equal(c,rf.abs)
  end
  def test_rt_file
    a = rio("file://ahost/a/")
    extra = rio('b')/'c'
    c = a/extra
    r = a.route_to(c)
    assert_equal(extra,r)
    assert_equal(c,r.abs)
  end
  def test_rf_http
    a = rio("http://ahost/a/")
    extra = rio('b')/'c'
    c = rio(a,extra)
    rf = c.route_from(a)
    assert_equal(extra,rf)
    assert_equal(c,rf.abs)
  end
end
