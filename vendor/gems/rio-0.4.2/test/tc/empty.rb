#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_empty < Test::RIO::TestCase
  @@once = false

  require 'tc/programs_util'
  include Test::RIO::Programs

  def self.once
    @@once = true

    rio('d0').rmtree.mkpath
    rio('d1').rmtree.mkpath.chdir {
      rio('file').touch
    }
    rio('f0').delete!.touch
    rio('f1').puts!("a nonempty file\n")
  end
  def setup
    super
    self.class.once unless @@once
  end
  def test_file_empty
    assert(rio('d0').empty?)
  end
  def test_file_not_empty
    assert!(rio('d1').empty?)
  end
  def test_dir_empty
    assert(rio('f0').empty?)
  end
  def test_dir_not_empty
    assert!(rio('f1').empty?)
  end
  def test_ps_empty
    assert(rio(?-,PROG['list_dir'] + ' d0').empty?)
  end
  def test_ps_not_empty
    assert!(rio(?-,PROG['list_dir'] + ' d1').empty?)
  end
  def test_dev_null_empty
    assert(rio(nil).empty?)
  end
end
