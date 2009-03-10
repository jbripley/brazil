#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_lineno < Test::Unit::TestCase
  def assert!(a,msg="negative assertion")
    assert((!(a)),msg)
  end
  def smap(a) a.map{|el| el.to_s} end
  def tdir() rio(%w/qp lineno/) end
  def mkafile(*args)
    file = rio(*args)
    file < (0..1).map { |i| "L#{i}:#{file.to_s}\n" }
    file
  end
  def mkalinesfile(n_lines,*args)
    file = rio(*args)
    file < (0...n_lines).map { |i| "L#{i}:#{file.to_s}\n" }
    file
  end
  def setup
    #$trace_states = true
    @cwd = ::Dir.getwd
    tdir.mkpath.chdir
  end
  def teardown
    ::Dir.chdir @cwd
  end

  def ztest_lineno_0
    rio('lineno').delete!.mkpath.chdir

    file = mkalinesfile(10,'f0')
    lines = file[]

    pos = file.pos
    lnum = file.lineno
    line = file.readline
    p "pos=#{pos}, lnum=#{lnum}, line=#{line}"

    pos = file.pos
    lnum = file.lineno
    line = file.readline
    p "pos=#{pos}, lnum=#{lnum}, line=#{line}"


    file.close
    rio('..').chdir
  end
  # baoo code 4153

  def test_lineno_like_IO
    rio('lineno').delete!.mkpath.chdir

    frio = mkalinesfile(5,'frio')
    rio('fruby') < frio

    fruby = File.open('fruby');

    assert_equal(fruby.pos,frio.pos)
    assert_equal(fruby.lineno,frio.lineno)
    assert_equal(line = fruby.readline,frio.readline)

    assert_equal(fruby.pos,frio.pos)
    assert_equal(fruby.lineno,frio.lineno)
    assert_equal(line = fruby.readline,frio.readline)

    fruby.pos += line.length
    frio.pos += line.length
    
    assert_equal(fruby.pos,frio.pos)
    assert_equal(fruby.lineno,frio.lineno)
    assert_equal(line = fruby.readline,frio.readline)


    $trace_states = false
    fruby.close
    frio.close

    fruby = File.open('fruby');
    frio = rio('frio')

    p fruby.lineno
    fruby.each { |rec|
      p "#{fruby.lineno} >> #{rec}"
    }

    p frio.lineno
    frio.each { |rec|
      p "#{frio.lineno} >> #{rec}"
    }
    frio.close
    p "RECNO"
    $trace_states = true

    frio = rio('frio')
    p frio.recno
    frio.each { |rec|
      p "#{frio.recno} >> #{rec}"
    }
    $trace_states = false
    frio.close

#    fruby.close
#    p fruby.lineno

    rio('..').chdir

    


 end





  def test_lineno
    rio('lineno').delete!.mkpath.chdir

    file = mkalinesfile(10,'f1')
    lines = file[]

#    $trace_states = true
    file = rio('f1')
    
    assert_equal(0,file.lineno)
    assert_equal(lines[0],file.readline)
    assert_equal(1,file.lineno)

    assert_equal(lines[1],file.readline)
#    p file.recno


    $trace_states = false
    file.close
    rio('..').chdir
  end

  def test_recno
    rio('recno').delete!.mkpath.chdir

    file = mkalinesfile(3,'f0')
    lines = file[]

    $trace_states = false
    file = rio('f0')
    p file.recno
    file.each { |rec|
      p "#{file.recno} >> #{rec}"
    }





    file.close




    $trace_states = false
    file.close
    rio('..').chdir
  end

  def test_eof
    rio('lineno').delete!.mkpath.chdir

    file = mkalinesfile(3,'f0')
    file > (lines = [])
    $trace_states = false
    file = rio('f0')
    p file.eof?


    $trace_states = false
#    assert(file.file?)
#    assert(link.file?)
#    assert(link.symlink?)

#    assert_equal(file.stat.size,link.stat.size)
#    assert_not_equal(file.stat.size,link.lstat.size)
#    assert_raise(RIO::Exception::CantHandle) {
#      file.lstat
#    }

    rio('..').chdir
  end
end
