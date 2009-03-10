#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_line_record_row < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('f0') < ['zero','one','two','three'].map{ |w| w + $/ }
  end
  def setup
    super
    self.class.once unless @@once
    @f0 = rio('f0')
  end
  def test_line
    assert_equal(rio(@f0).lines[0][0],rio(@f0).line[0])
    assert_equal(rio(@f0).lines[1][0],rio(@f0).line[1])
    assert_equal(rio(@f0).lines[2][0],rio(@f0).line[2])
    assert_equal(rio(@f0).lines[3][0],rio(@f0).line[3])
    assert_equal(rio(@f0).lines[4][0],rio(@f0).line[4])
    assert_equal(rio(@f0).lines[1..2][0],rio(@f0).line[1])
    assert_equal(rio(@f0).lines[/t/][0],rio(@f0).line[/t/])
  end

  def test_record
    assert_equal(rio(@f0).records[0][0],rio(@f0).record[0])
    assert_equal(rio(@f0).records[1][0],rio(@f0).record[1])
    assert_equal(rio(@f0).records[2][0],rio(@f0).record[2])
    assert_equal(rio(@f0).records[3][0],rio(@f0).record[3])
    assert_equal(rio(@f0).records[4][0],rio(@f0).record[4])
    assert_equal(rio(@f0).records[1..2][0],rio(@f0).record[1])
    assert_equal(rio(@f0).records[/t/][0],rio(@f0).record[/t/])
  end

  def test_row
    assert_equal(rio(@f0).rows[0][0],rio(@f0).row[0])
    assert_equal(rio(@f0).rows[1][0],rio(@f0).row[1])
    assert_equal(rio(@f0).rows[2][0],rio(@f0).row[2])
    assert_equal(rio(@f0).rows[3][0],rio(@f0).row[3])
    assert_equal(rio(@f0).rows[4][0],rio(@f0).row[4])
    assert_equal(rio(@f0).rows[1..2][0],rio(@f0).row[1])
    assert_equal(rio(@f0).rows[/t/][0],rio(@f0).row[/t/])
  end

end
