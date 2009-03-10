#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'tc/csvutil'

class TC_csv2 < Test::RIO::TestCase
  include CSV_Util

  @@once = false
  def self.once
    @@once = true
  end
  def setup()
    super
    @src = rio(?")
    @dst_name = 'dst.csv'
    @records,@strings,@lines,@string = create_test_csv_data(@src,3, 3, true)
  end

  def test_read
    rio('src1.csv') < @src


    rio('src1.csv') > rio('dst.csv')
    assert_equal(@string,rio('dst.csv').contents)
    assert_equal(@string,rio('dst.csv').csv.contents)
    assert_equal(@lines,rio('dst.csv')[])
    assert_equal(@strings,rio('dst.csv').chomp[])
    assert_equal(@lines,rio('dst.csv').to_a)
    assert_equal(@strings,rio('dst.csv').chomp.to_a)
    assert_equal(@lines,rio('dst.csv').readlines)
    assert_equal(@strings,rio('dst.csv').chomp.readlines)

    assert_equal(@records,rio('dst.csv').csv[])
    assert_equal(@records,rio('dst.csv').csv.chomp[])
    assert_equal(@lines,rio('dst.csv').csv.lines[])
    assert_equal(@strings,rio('dst.csv').csv.chomp.lines[])
    assert_equal(@records,rio('dst.csv').csv.records[])
    assert_equal(@lines,rio('dst.csv').csv.records.readlines)
    assert_equal(@lines[1..2],rio('dst.csv').csv.lines[1..2])
    assert_equal(@lines[1..2],rio('dst.csv').csv.lines(1..2).to_a)
    assert_equal(@lines,rio('dst.csv').csv.lines(1..2).readlines)

    rio('dst.csv') < @string
    assert_equal(@lines,::File.open('dst.csv').readlines)
    
    rio('dst.csv').csv < @string
    assert_equal(@lines,::File.open('dst.csv').readlines)
    
    rio('dst.csv') < @lines
    assert_equal(@lines,::File.open('dst.csv').readlines)
    
    rio('dst.csv').csv < @records
    assert_equal(@lines,::File.open('dst.csv').readlines)

    src_str = @string.dup
    rio(?",src_str) >  rio(?",dst_str='')
    assert_equal(src_str,dst_str)

    rio(?",src_str).csv >  rio(?",dst_str='')
    assert_equal(@records.to_s,dst_str)

    rio(?",dst_str='') < rio(?",src_str).csv
    assert_equal(@records.to_s,dst_str)

    dst = rio(?")
    rio(?",src_str) > dst.csv
    assert_equal(@records,dst[])

    dst = rio(?")
    dst.csv < rio(?",src_str)
    assert_equal(@records,dst[])

    dst = rio(?")
    rio(?",src_str) > dst.csv
    assert_equal(@records,dst[])

    dst = rio(?").csv < rio(?",src_str)
    assert_equal(@records,dst[])

    dst = rio(?").csv(';') < rio(?",src_str).csv
    assert_equal(src_str.gsub(/,/,';'),dst.contents)

    rio(?",src_str).csv > (dst = rio(?").csv(';'))
    assert_equal(src_str.gsub(/,/,';'),dst.contents)

    

  end
  def test_getrec

    rio('src1.csv') < @src

    assert_equal(@string,rio('src1.csv').contents)
    assert_equal(@string,rio('src1.csv').csv.contents)
    assert_equal(@lines[0],rio('src1.csv').getrec)
    assert_equal(@strings[0],rio('src1.csv').chomp.getrec)

    assert_equal(@lines[1],rio('src1.csv').lines(1).getrec)
    assert_equal(@lines[1],rio('src1.csv').records(1).getrec)
    assert_equal(@lines[1],rio('src1.csv').rows(1).getrec)

    assert_equal(@records[1],rio('src1.csv').csv.lines(1).getrec)
    assert_equal(@records[1],rio('src1.csv').csv.records(1).getrec)

    assert_equal(@records[8000],rio('src1.csv').csv.records(8000).getrec)

    assert_equal(@string[0,23],rio('src1.csv').bytes(23).getrec)

    rec_ary = @records[0]
    rec_rio = rio('src1.csv').csv.getrec
    assert_kind_of(::Array,rec_rio)
    exp = $EXTEND_CSV_RESULTS ? @strings[0] : @records[0].to_s
    assert_equal(exp,rec_rio.to_s)

    rec_rio = rio('src1.csv').csv.lines.getrec
    assert_kind_of(::Array,rec_rio)
    assert_equal(@records[0],rec_rio.to_a)

    ary = rio('src1.csv').csv[]
    assert_kind_of(::Array,ary[0])
    exp = $EXTEND_CSV_RESULTS ? @strings[0] : @records[0].to_s
    assert_equal(exp,ary[0].to_s)

    recs = rio('src1.csv').csv.lines[]
    assert_kind_of(::String,recs[0])
    exp = $EXTEND_CSV_RESULTS ? @records[0] : [@strings[0]+$/]
    assert_equal(exp,recs[0].to_a)
    return
  end


end
