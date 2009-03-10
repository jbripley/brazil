#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_copy_from < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true

    rio('d0').rmtree.mkpath
    rio('d1').rmtree.mkpath
    rio('d0/d2').rmtree.mkpath
    make_lines_file(1,'d0/f0')
    make_lines_file(2,'d0/f1')
    make_lines_file(3,'d1/f2')
    make_lines_file(4,'d1/f3')
    make_lines_file(5,'d0/d2/f4')
    make_lines_file(6,'d0/d2/f5')
  end
  def setup
    super
    self.class.once unless @@once

    @d0 = rio('d0')
    @d2 = rio('d0/d2')
  end
  def cptest(src)
    dst = rio('dst').delete!.mkpath
    dst < src.clone
    assert_rios_equal(src.clone,rio(dst,src.filename),"rio copy")
  end

  def test_string_file
    ario = rio('ous').delete!.puts!("If you are seeing this, rio < string is broken")
    str = "HelloWorld\n"
    ario < str
    assert(ario.closed?,"Rio closes after copy-from string")
    assert_equal(str,ario.contents)
    ario << str
    assert_equal(str+str,ario.contents)
  end

  def test_arrayofstrings_file
    ario = rio('oua').delete!.puts!("If you are seeing this, rio < array is broken")
    str = "HelloWorld\n"
    ario < [str]
    assert_equal(str,ario.contents)
    ario << [str]
    assert_equal(str+str,ario.contents)
  end


  def test_string_dir
    ario = rio('oud').delete!.mkdir
    str = "HelloWorld"
    drio = rio(str).delete!
    assert_raise(Errno::ENOENT) { ario < str }
    drio.touch
    ario < str
    assert(rio(ario,str).file?)
  end

  def test_arrayofstrings_dir
    $trace_states = false
    ario = rio('oup').delete!.mkdir
    str = "HelloWorld"
    drio = rio(str).delete!
    assert_raise(Errno::ENOENT) { ario < [str] }
    drio.touch
    ario < [str]
    assert(rio(ario,str).file?)
    $trace_states = false
  end

  def test_string_nonex
    ario = rio('oun').delete!
    str = "HelloWorld\n"
    ario < str
    assert(ario.file?,"Copy from string creates a file")
    assert_equal(str,ario.contents)
  end

  def test_arrayofstrings_nonex
    ario = rio('oun').delete!
    str = "HelloWorld\n"
    ario < [str]
    assert(ario.file?,"Copy from array of strings creates a file")
    assert_equal(str,ario.contents)
  end

  def test_simple_rio0
    cptest(rio(@d0))
  end
  def test_simple_rio2
    cptest(rio(@d2))
  end
  def test_files_rio
    cptest(rio(@d0).files('*[04]'))
  end
  def test_files_ary
    dst = rio('dst').delete!.mkpath
    dst < @d0.files[]
    @d0.files.each do |ent|
      assert_rios_equal(ent,rio(dst,ent.filename),"files rio copy")
    end
  end
  def test_io_file
    ario = rio('out').delete!.touch
    iof = rio('d0/f1')
    exp = iof.readlines
    ios = ::File.new(iof.to_s,'r')
    #$trace_states = true
    ario < ios
    $trace_states = false
    ios.close
    ans = ario.readlines
    assert_equal(exp,ans)
  end
  def test_simple_ary
    dst = rio('dst').delete!.mkpath
    dst < @d0[]
    assert_rios_equal(@d0,dst,"simple rio copy")
  end
end
