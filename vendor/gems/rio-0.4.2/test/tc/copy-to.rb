#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_copy_to < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true

    rio('d0').rmtree.mkpath
    rio('d1').rmtree.mkpath
    rio('d0/d2').rmtree.mkpath
    make_lines_file(1,'d0/f0')
    make_lines_file(2,'d0/f1')
    make_lines_file(3,'d1/f2')
    make_lines_file(4,'d1/f3')
    make_lines_file(5,'d0/d2/f4')
    make_lines_file(6,'d0/d2/f5')
  end
  def setup
    super
    self.class.once unless @@once

    @d0 = rio('d0')
    @d1 = rio('d1')
    @d2 = rio('d0/d2')
  end
  def test_string
    ario = rio('d0/f1')
    exp = ario.contents
    ans = "If you are seeing this, rio > string is broken"
    ario > ans
    assert_equal(exp,ans)
    ario >> ans
    assert_equal(exp+exp,ans)
  end
  def test_string_dir
    ario = rio(@d0)
    name = "GoofyGoofyGoofy"
    rio(name).delete!
    ario > name
    assert_rios_equal(ario,rio(name))
  end
  def test_io_file
    ario = rio('d0/f1')
    iof = rio('anio').delete!
    exp = ario.readlines
    ios = ::File.new(iof.to_s,'w')
    #$trace_states = true
    ario > ios
    $trace_states = false
    ios.close
    ans = rio(iof).readlines
    assert_equal(exp,ans)
  end
  def test_io_file_f
    ario = rio('out').delete!.touch
    iof = rio('d0/f1')
    exp = iof.readlines
    ios = ::File.new(iof.to_s,'r')
    #$trace_states = true
    ario < ios
    $trace_states = false
    ios.close
    ans = ario.readlines
    assert_equal(exp,ans)
  end
  def test_array_file
    ario = rio('d0/f1')
    exp = ario.readlines
    ans = ["If you are seeing this, rio > array is broken"]
    ario > ans
    assert_equal(exp,ans)
    ario >> ans
    assert_equal(exp+exp,ans)
  end
  def test_array_dir
    ario = rio(@d0)
    exp = @d0.to_a
    ans = ["If you are seeing this, rio > array is broken"]
    ario > ans
    assert_equal(exp,ans)
    ario >> ans
    assert_equal(exp+exp,ans)
  end
end
