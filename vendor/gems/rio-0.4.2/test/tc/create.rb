#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_create < Test::Unit::TestCase
  def rio(*args) RIO.rio(*args) end
  def rootrio(*args) RIO.root(*args) end
  def ttdir() RIO.rio('qp').mkpath end
  def assert_equal_s(a,b) assert_equal(a.to_s,b.to_s) end

  def test_create
    ario = RIO.root
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/',ario.to_s)

    ario = RIO.cwd
    assert_kind_of(RIO::Rio,ario)
    cwd = RIO::RL.fs2url(::Dir.getwd)
    assert_equal("#{cwd}",ario.urlpath)

    ario = RIO.cwd
    assert_kind_of(RIO::Rio,ario)
    cwd = ::Dir.getwd
    assert_equal("#{cwd}",ario.path)

    ario = RIO.cwd
    assert_kind_of(RIO::Rio,ario)
    cwd = ::Dir.getwd
    assert_equal(cwd,ario.to_s)

    ario = RIO.root.join('tmp')
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp',ario.to_s)

    tmp = RIO.root('tmp')
    assert_kind_of(RIO::Rio,tmp)
    assert_equal('/tmp',tmp.to_s)
    
    ario = tmp/'goofy'
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy',ario.to_s)

    ario = RIO.rio('/tmp/goofy')
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy',ario.to_s)
    
    ario = RIO.rio(tmp,'goofy')
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy',ario.to_s)

    ario = RIO.rio(RIO.root,%w/tmp goofy/)
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy',ario.to_s)

    ario = RIO.rio(tmp).join('goofy')
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy',ario.to_s)

    ario = rio('/tmp/goofy')
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy',ario.to_s)
    
    ario = rio(tmp,'goofy')
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy',ario.to_s)

    ario = rio(RIO.root,%w/tmp goofy/)
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy',ario.to_s)

    ario = rio(tmp).join('goofy')
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy',ario.to_s)

    require 'rio/uri/file'
    ario = rio(URI('goofy/f.html'))
    assert_kind_of(RIO::Rio,ario)
    assert_equal('goofy/f.html',ario.to_s)

    ario = rio(URI("file:///tmp/goofy/f.html"))
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy/f.html',ario.to_s)

    ario = rio("file:///tmp/goofy/f.html")
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy/f.html',ario.to_s)

    ario = rio("file:///tmp/","goofy/f.html")
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy/f.html',ario.to_s)

    u = URI('goofy/f.html')

    ario = rio("file:///tmp/",u)
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy/f.html',ario.to_s)

    ario = rio("file:///tmp/",rio(u))
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy/f.html',ario.to_s)

    ario = rio("/tmp",rio(u))
    assert_kind_of(RIO::Rio,ario)
    assert_equal('/tmp/goofy/f.html',ario.to_s)


  end

end
