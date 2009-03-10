#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_files_select < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('d0').delete!.mkdir
    rio('f0').delete!.puts!("f0:L0")
    rio('f1').delete!.puts!("f1:L0")
    rio('d0/f2').puts!("d0/f2:L0")
    rio('d0/f3').puts!("d0/f3:L0")
  end
  def setup
    super
    self.class.once unless @@once
  end

  def test_files_method_with_dir_rio_each
    #$trace_states = true
    ans = []
    rio('d0').files.each { |f|
      ans << f
    }
    assert_equal(['d0/f2','d0/f3'],smap(ans))
  end
  def test_files_method_with_dir_rio_each_skip
    #$trace_states = true
    ans = []
    rio('d0').skip('f*').files.each { |f|
      ans << f
    }
    assert(ans.empty?)
  end
  def test_files_method_with_file_rio_each_skip
    #$trace_states = true
    ans = []
    rio('f0').skip('f*').files.each { |f|
      ans << f
    }
    assert(ans.empty?)
  end
  def test_files_method_with_file_rio_each
    #$trace_states = true
    ans = []
    rio('f0').files.each { |f|
      ans << f
    }
    assert_equal(['f0'],smap(ans))
  end
  def test_files_and_lines_with_file_rio_each
    #$trace_states = true
    ans = []
    rio('f0').files.lines.each { |f|
      ans << f
    }
    assert_equal(["f0:L0\n"],smap(ans))
  end
  def test_files_method_with_file_rio_to_a
    #$trace_states = true
    ans = rio('f0').files.to_a
    assert_equal(['f0'],smap(ans))
  end
  def test_files_method_with_file_rio_ss
    #$trace_states = true
    ans = rio('f0').files[]
    assert_equal(['f0'],smap(ans))
  end
  def test_files_method_with_file_rio_ss_skip
    #$trace_states = true
    ans = rio('f0').skip('f*').files[]
    assert_equal([],smap(ans))
  end
  def test_files_method_with_file_rio_ss_args_select
    #$trace_states = true
    ans = rio('f0').files['f*']
    assert_equal(['f0'],smap(ans))
  end
  def test_files_method_with_file_rio_ss_args_dontselect
    #$trace_states = true
    ans = rio('f0').files['g*']
    assert_equal([],smap(ans))
  end

end

