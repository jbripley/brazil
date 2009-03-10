#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'tmpdir'

class TC_tempfile < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
    @tmpdir = ::Dir::tmpdir
    @pfx = 'rio'
  end

  def pathinfo(ario)
    [:scheme,:opaque,:path,:fspath,:to_s,:to_url,:to_uri].each do |sym|
      puts "#{sym}: #{ario.__send__(sym)}"
    end
  end

  def test_io
    str = "Hello Tempfile"
    assert_equal(str,rio(??).puts(str).rewind.chomp.gets)
  end

  def test_rl_temp
    str = "Hello Tempfile"
    tmp = rio('temp:')
    assert(tmp.closed?)
    assert_equal(str,tmp.puts(str).rewind.chomp.gets)
  end

  def test_rl_tempfile
    str = "Hello Tempfile"
    #$trace_states = true
    tmp = rio('tempfile:')
    assert(tmp.closed?)
    tmp.puts(str)
    assert(tmp.open?)
    assert_equal(str,tmp.rewind.chomp.gets)
  end

  def test_copy
    str = "Hello World\n"
    
    src = rio(?").print!(str)
    ans = rio(?")
    
    tmp = rio(??)
    tmp < src
    tmp.rewind
    assert_equal(str,tmp.contents)
    tmp.rewind
    tmp > ans
    assert_equal(str,ans.contents)
  end

end
