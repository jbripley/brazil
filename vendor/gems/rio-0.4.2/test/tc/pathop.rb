#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_pathop < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('d0').rmtree.mkpath
    rio('d0/d2').rmtree.mkpath
    rio('d0/d3').rmtree.mkpath
    rio('d0/d4').rmtree.mkpath
    rio('d0/d2/d3').rmtree.mkpath
    rio('d0/d2/d5').rmtree.mkpath
    rio('d0/d3/d6').rmtree.mkpath
    rio('d1').rmtree.mkpath
    rio('d1/d8').rmtree.mkpath
    make_lines_file(1,'d1/f0')
    make_lines_file(2,'d1/f1')
    make_lines_file(1,'d0/f0')
    make_lines_file(2,'d0/f1')
    make_lines_file(1,'d0/d2/f0')
    make_lines_file(2,'d0/d2/f1')
    make_lines_file(1,'d0/d3/d6/f0')
    make_lines_file(2,'d0/d3/d6/f1')
  end
  def setup
    super
    self.class.once unless @@once

    @d0 = rio('d0')
    @d1 = rio('d1')
    @d2 = @d0/'d2'
    @f0 = @d0/'f0'
    @f1 = @d0/'f1'
    @f2 = @d0/'d2'/'f2'
    @f3 = @d0/'d2'/'f3'

  end
  def test_p1
    src = rio(@d1)
    dst = []
    puts @f3
    p File.split('/qe/pi/')
  end
  def test_p2
    p1 = rio('p1')
    p2 = rio('p2')
    p3 = p1.join(p2)
    puts p1,p3
    p3 = p1.join!(p2)
    puts p1,p3

  end
end
