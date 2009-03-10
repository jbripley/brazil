#!/usr/bin/env ruby
require 'rio'

RGBFILE = rio(__FILE__).dirname/'rgb.txt.gz'

RGBFILE.gzip.lines(/^\s*(\d+)\s+(\d+)\s+(\d+)\s+(\S.+)/) do |line,ma| 
  printf("#%02x%02x%02x\t%s\n",*ma[1..4])
end
