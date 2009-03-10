#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_copysymlink < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('afile').touch.symlink('alink')
    rio('d0').rmtree.mkpath
    rio('d0/afile').touch.symlink('d0/alink')
    rio('d1').rmtree.mkpath
    rio('d0/afile').touch.symlink('d1/alink')
  end
  def setup
    super
    self.class.once unless @@once

    @d0 = rio('d0/')
    @d1 = rio('d1/')
  end
  def test_basic
    dst = rio('dst').delete!.mkpath
    dst < @d0
    
    assert_dirs_equal(@d0,rio(dst,@d0.filename),"basic copy")
  end
  def test_cross_copy
    dst = rio('dst2').delete!.mkpath
    dst < @d1
    
    assert_dirs_equal(@d1,rio(dst,@d1.filename),"basic copy")
  end
end
