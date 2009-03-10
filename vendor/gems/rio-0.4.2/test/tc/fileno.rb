#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_fileno < Test::Unit::TestCase
  def assert!(a,msg="negative assertion")
    assert((!(a)),msg)
  end
  def smap(a) a.map{|el| el.to_s} end
  def tdir() rio(%w/qp fileno/) end
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

  def test_fileno_like_IO
    rio('fileno').delete!.mkpath.chdir

    frio = mkalinesfile(5,'frio')
    rio('fruby') < frio

    fruby = File.open('fruby');
    p fruby.fileno
    p frio.fileno
    p rio('-').fileno

    ario = mkalinesfile(2,'ario')
    ario = rio('ario').a
    p ario.sync?
    ario.puts("Hey")
    p ario.sync?
    p ario.ioh.sync
    $trace_states = true
    ario.fsync
    $trace_states = false
    p ario.sync?
    ario.sync.puts("HOHO")
    p ario.sync?
    p ario.ioh.sync
    ario.nosync
    p ario.sync?
    p ario.ioh.sync
    ario.ioh.sync = true
    p ario.ioh.sync
    p ario.sync?
    p ario.ioh.sync


#    assert_equal(fruby.pos,frio.pos)
#    assert_equal(fruby.fileno,frio.fileno)
#    assert_equal(line = fruby.readline,frio.readline)

#    assert_equal(fruby.pos,frio.pos)
#    assert_equal(fruby.fileno,frio.fileno)
#    assert_equal(line = fruby.readline,frio.readline)

#    fruby.pos += line.length
#    frio.pos += line.length
    
#    assert_equal(fruby.pos,frio.pos)
#    assert_equal(fruby.fileno,frio.fileno)
#    assert_equal(line = fruby.readline,frio.readline)


    rio('..').chdir

    


 end



end
