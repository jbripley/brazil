#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'tc/testcase'

class TC_closeoncopy < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true

    make_lines_file(3,'f0')
    rio('d0').delete!.mkdir.chdir {
      make_lines_file(3,'f1')
    }
  end
  def setup
    super
    self.class.once unless @@once

    @f0 = rio('f0')
  end
  def atest_method
    assert(@f1.closeoncopy?)
    assert!(@f2.closeoncopy?)
  end
  def cfrom(dest,src)
    dest < src
    assert(dest.closeoncopy?)
    assert(dest.closed?)

    dest << src
    assert(dest.closeoncopy?)
    assert(dest.closed?)
  end
  def test_copyfrom
    #$trace_states = true
    cfrom(rio('copyfrom').delete,rio(@f0))
    cfrom(rio('copyfrom'),rio(@f0))
    cfrom(rio('copyfrom').open('w'),rio(@f0))
  end

  def orio()
    d = rio('copyfrom')
    d.puts("aline\n")
    assert(d.open?)
    d
  end
  def test_copyfrom_open
    #$trace_states = true
    cfrom(orio,"Zipp\n")
    cfrom(orio,rio(@f0))
    cfrom(orio,["Zipp\n"])
  end

  def test_copyfrom_array
    #$trace_states = true
    cfrom(rio('copyfrom').delete,["Zipp\n"])
  end

  def cto(src,dest)
    src > dest
    assert(dest.closeoncopy?)
    assert(dest.closed?)
  end

  def ato(src,dest)
    src >> dest
    assert(dest.closeoncopy?)
    assert(dest.closed?)
  end
  def test_copyto
    #$trace_states = true
    cto(rio(@f0),rio('copyto').delete!)
    cto(rio(@f0),rio('copyto'))
    cto(rio(@f0),rio('copyto').open('w'))
    cto(rio(@f0),rio('copyto').open('a'))
    cto(rio(@f0),orio)
  end
  def test_appto
    #$trace_states = true
    ato(rio(@f0),rio('copyto').delete!)
    ato(rio(@f0),rio('copyto'))
    ato(rio(@f0),rio('copyto').open('w'))
    ato(rio(@f0),rio('copyto').open('a'))
    ato(rio(@f0),orio)
  end
  def test_cx_set
    rio('d0').files { |f|
      assert(f.closeoncopy?)
    }
  end
  def test_cx_bequeath
    rio('d0').nocloseoncopy.files { |f|
      assert!(f.closeoncopy?)
    }
  end
end
__END__
