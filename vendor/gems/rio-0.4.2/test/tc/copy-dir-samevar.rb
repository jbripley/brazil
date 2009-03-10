#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_copy_dir_samevar < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true

    rio('d0').rmtree.mkpath
    rio('d0/d1').rmtree.mkpath
    make_lines_file(1,'d0/f0.txt')
    make_lines_file(2,'d0/f1.txt')
    make_lines_file(5,'d0/d1/f2.txt')
    make_lines_file(6,'d0/d1/f3.txt')
    rio('d2').rmtree.mkpath
    make_lines_file(3,'d2/f4.txt')
  end
  def setup
    super
    self.class.once unless @@once

    @d0 = rio('d0')
    @d1 = rio('d0/d1')
    @f0 = rio('d0/f0.txt')
    @f1 = rio('d0/f1.txt')
    @f2 = rio('d0/d1/f2.txt')
    @f3 = rio('d0/d1/f3.txt')
    @d2 = rio('d2')
    @f4 = rio('d2/f4.txt')
    rio('exp').delete!.mkdir < rio(@d0)
    rio('exp2').delete!.mkdir < rio(@d2)
  end
  def test_copy_files
    rio(@d0).files { |f|
      f < f.contents
    }
    assert_rios_equal(rio('exp',@f0),rio(@f0))
    assert_rios_equal(rio('exp',@f1),rio(@f1))
  end
  def test_copy_files_contents_gsub
    rio(@d0).files { |f|
      f < f.contents.gsub(/^L1/,'Line1')
    }
    assert_rios_equal(rio('exp',@f0),rio(@f0))
    exp = rio('exp',@f1).chomp.lines[].map{|l| l.sub(/^L1/,'Line1')}
    assert_equal(exp,rio(@f1).chomp[])
  end
  def test_copy_files_array
    rio(@d0).files { |f|
      f < f.lines[]
    }
    assert_rios_equal(rio('exp',@f0),rio(@f0))
    assert_rios_equal(rio('exp',@f1),rio(@f1))
  end
  def test_copy_files_array_sel
    rio(@d0).files { |f|
      f < f.lines[/^L0/]
    }
    assert_rios_equal(rio('exp',@f0),rio(@f0))
    exp = rio('exp',@f1).lines[0]
    assert_equal(exp,rio(@f1).lines[])
  end
  def test_copy_all_files_array
    rio(@d0).all.files { |f|
      f < f.lines[]
    }
    assert_rios_equal(rio('exp',@f0),rio(@f0))
    assert_rios_equal(rio('exp',@f1),rio(@f1))
  end
  def test_copy_all_files
    rio(@d0).all.files { |f|
      f < f.contents
    }
    assert_rios_equal(rio('exp',@f0),rio(@f0))
    assert_rios_equal(rio('exp',@f1),rio(@f1))
    assert_rios_equal(rio('exp',@f2),rio(@f2))
    assert_rios_equal(rio('exp',@f3),rio(@f3))
  end
  def cptest(src)
    dst = rio('dst').delete!.mkpath
    dst < src.clone
    assert_rios_equal(src.clone,rio(dst,src.filename),"rio copy")
  end

end
