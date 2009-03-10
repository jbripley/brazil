#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'tc/csvutil'

class TC_csv_columns < Test::RIO::TestCase
  include CSV_Util

  @@once = false
  def self.once
    @@once = true
  end
  def setup()
    super
    @src = rio(?")
    @dst_name = 'dst.csv'
    @records,@strings,@lines,@string = create_test_csv_data(@src,1, 8, false)
  end

  def test_basic

    rio('src1.csv') < @src
    r = @records[0]
    assert_equal([[r[1],r[2],r[5]]],rio('src1.csv').csv.columns(1,2,5).to_a)
    assert_equal([r[3...6]],rio('src1.csv').csv.columns(3...6).to_a)
    assert_equal([[r[3],r[5]]],rio('src1.csv').csv.columns(3...6).skipcolumns(4).to_a)
    assert_equal([[r[0],r[7]]],rio('src1.csv').csv.skipcolumns(1..6).to_a)
    assert_equal([[]],rio('src1.csv').csv.skipcolumns.to_a)
    assert_equal([r],rio('src1.csv').csv.to_a)
    
  end
end
