#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_emptyriodir < Test::RIO::TestCase
  include RIO_TestCase
  @@once = false
  def self.once
    @@once = true
    rio('adir').mkdir.chdir {
      rio('a.rb').touch  
      rio('b.rb').touch
      rio('c.txt').touch
    }
    rio('d.rb').touch
    rio('e.txt').touch
    rio('f.d').mkdir
  end

  def setup
    super
    self.class.once unless @@once
  end

  def test_ss
    
    dotans = rio('.')[]
    empans = rio[]
    assert_array_equal(dotans,empans)

    dotans = rio('.')['*.rb']
    empans = rio['*.rb']
    assert_array_equal(dotans,empans)

  end

  def test_each

    dotans = []
    empans = []
    rio('.').each{ |el| dotans << el }
    rio.each{ |el| empans << el }
    assert_array_equal(dotans,empans)

    dotans = []
    empans = []
    rio('.').entries('*.rb') { |el| dotans << el }
    rio.entries('*.rb') { |el| empans << el }
    assert_array_equal(dotans,empans)
  end

  def test_read
    dotans = []
    empans = []
    dotrio = rio('.')
    emprio = rio
    while s = dotrio.read do dotans << s end
    while s = emprio.read do empans << s end
    assert_array_equal(dotans,empans)
  end

  def test_get
    dotans = []
    empans = []
    dotrio = rio('.')
    emprio = rio
    while s = dotrio.get do dotans << s end
    while s = emprio.get do empans << s end
    assert_array_equal(dotans,empans)

    dotans = []
    empans = []
    dotrio = rio('.').entries('*.d')
    emprio = rio.entries('*.d')
    while s = dotrio.get do dotans << s end
    while s = emprio.get do empans << s end
    assert_array_equal(dotans,empans)

  end

  def test_skip
    
    dotans = rio('.').skip[]
    empans = rio.skip[]
    assert_array_equal(dotans,empans)

    dotans = rio('.').skip['*.rb']
    empans = rio.skip['*.rb']
    assert_array_equal(dotans,empans)

  end

  def test_dirs
    
    dotans = rio('.').dirs[]
    empans = rio.dirs[]
    assert_array_equal(dotans,empans)

    dotans = rio('.').dirs['*.d']
    empans = rio.dirs['*.d']
    assert_array_equal(dotans,empans)

  end


  def test_getwd
    dotans = rio('.').getwd
    empans = rio.getwd
    assert_array_equal(dotans,empans)
  end

  def test_rmdir
    rio('empty.d').delete!.mkdir.chdir {
      assert_raise(RIO::Exception::CantHandle) { rio.rmdir }
    }
  end

  def test_rmtree
    rio('empty.d').delete!.mkdir.chdir {
      assert_raise(RIO::Exception::CantHandle) { rio.rmtree }
    }
  end

end
