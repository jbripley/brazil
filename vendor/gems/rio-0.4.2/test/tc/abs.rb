#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_abs < Test::Unit::TestCase
  def test_abs
    rio('qp/test_abs').rmtree.mkpath.chdir {
      
      
      require 'uri'
      
      hdurl = 'http://localhost/'
      hduri = ::URI.parse(hdurl)
      hd = rio(hduri)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('http',hd.scheme)    
      assert_equal('localhost',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.abs.to_url)

      hdurl = 'http://localhost/'
      hd = rio(hdurl)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('http',hd.scheme)    
      assert_equal('localhost',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.abs.to_url)

      hdurl = 'http://localhost'
      hduri = ::URI.parse(hdurl)
      hd = rio(hduri)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('http',hd.scheme)    
      assert_equal('localhost',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl+'/',hd.abs.to_url)

      hdurl = 'http://localhost'
      hd = rio(hdurl)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('http',hd.scheme)    
      assert_equal('localhost',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl+'/',hd.abs.to_url)

      hdurl = 'http://localhost/rio/hw.html'
      hd = rio(hdurl)
      assert_equal('/rio/hw.html',hd.path)
      assert_equal('/rio/hw.html',hd.fspath)
      assert_equal('http',hd.scheme)    
      assert_equal('localhost',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.abs.to_url)

      hdurl = 'file://localhost/'
      hduri = ::URI.parse(hdurl)
      hd = rio(hduri)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('file',hd.scheme)    
      assert_equal('localhost',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.to_url)
      assert_equal(hdurl,hd.abs.to_url)

      hdurl = 'file://localhost/'

      hd = rio(hdurl)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('file',hd.scheme)    
      assert_equal('localhost',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.to_url)
      assert_equal(hdurl,hd.abs.to_url)

      hdurl = 'file://localhost'
      hduri = ::URI.parse(hdurl)
      hd = rio(hduri)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('file',hd.scheme)    
      assert_equal('localhost',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl+'/',hd.to_url)
      assert_equal(hdurl+'/',hd.abs.to_url)

      hdurl = 'file://localhost'
      hd = rio(hdurl)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('file',hd.scheme)    
      assert_equal('localhost',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl+'/',hd.to_url)
      assert_equal(hdurl+'/',hd.abs.to_url)

      hdurl = 'file:///'
      hduri = ::URI.parse(hdurl)
      hd = rio(hduri)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('file',hd.scheme)    
      assert_equal('',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.to_url)
      assert_equal(hdurl,hd.abs.to_url)

      hdurl = 'file:///'
      hd = rio(hdurl)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('file',hd.scheme)    
      assert_equal('',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.to_url)
      assert_equal(hdurl,hd.abs.to_url)

      hdurl = '/'
      hd = rio(hdurl)
      assert_equal('/',hd.path)
      assert_equal('/',hd.fspath)
      assert_equal('file',hd.scheme)    
      assert_equal('',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.abs.to_s)
      assert_equal('file:///',hd.to_url)
      assert_equal('file:///',hd.abs.to_url)
      require 'tmpdir'

      hdurl = '/tmp'
      hdurl = '/WINDOWS' unless FileTest.directory?(hdurl)
      hd = rio(hdurl)
#      assert_equal(hdurl+'/',hd.path)
      assert_equal(hdurl,hd.fspath)
      assert_equal('file',hd.scheme)    
      assert_equal('',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.abs.to_s)
 #     assert_equal('file://'+hdurl+'/',hd.to_url)
 #     assert_equal('file://'+hdurl+'/',hd.abs.to_url)

      hdurl = '/tmp/'
      hd = rio(hdurl)
      assert_equal('/tmp/',hd.path)
      assert_equal('/tmp/',hd.fspath)
      assert_equal('file',hd.scheme)    
      assert_equal('',hd.host)
      assert_equal(true,hd.abs?)
      assert_equal(true,hd.absolute?)
      assert_equal(hdurl,hd.abs.to_s)
      assert_equal('file:///tmp/',hd.to_url)
      assert_equal('file:///tmp/',hd.abs.to_url)

      # case qp dir does not exist
      rio('qp').delete!
      hdurl = 'qp'
      hd = rio(hdurl)
      assert_equal('qp',hd.path)
      assert_equal('qp',hd.fspath)
      assert_equal('path',hd.scheme)    
      assert_nil(hd.host)
      assert_equal(false,hd.abs?)
      assert_equal(false,hd.absolute?)
      cwd = ::Dir.getwd
      assert_equal(cwd+'/'+hdurl,hd.abs.to_s)
      assert_equal('path:qp',hd.to_url)

      assert_equal('file://'+RIO::RL.fs2url(cwd)+'/'+hdurl,hd.abs.to_url)

      hdurl = 'qp/'
      hd = rio(hdurl)
      assert_equal('qp/',hd.path)
      assert_equal('qp/',hd.fspath)
      assert_equal('path',hd.scheme)    
      assert_nil(hd.host)
      assert_equal(false,hd.abs?)
      assert_equal(false,hd.absolute?)
      cwd = ::Dir.getwd
      assert_equal(cwd+'/'+hdurl,hd.abs.to_s)
      assert_equal('path:qp/',hd.to_url)
      assert_equal('file://'+RIO::RL.fs2url(cwd)+'/'+hdurl,hd.abs.to_url)

      # case qp dir exists
      rio('qp').mkdir

      hdurl = 'qp'
      hd = rio(hdurl)
#      assert_equal('qp/',hd.path)
      assert_equal('qp',hd.fspath)
      assert_equal('path',hd.scheme)    
      assert_nil(hd.host)
      assert_equal(false,hd.abs?)
      assert_equal(false,hd.absolute?)
      cwd = ::Dir.getwd
      assert_equal(cwd+'/'+hdurl,hd.abs.to_s)
      assert_equal('path:qp',hd.to_url)
      assert_equal('file://'+RIO::RL.fs2url(cwd)+'/'+hdurl,hd.abs.to_url)

      hdurl = 'qp/'
      hd = rio(hdurl)
      assert_equal('qp/',hd.path)
      assert_equal('qp/',hd.fspath)
      assert_equal('path',hd.scheme)    
      assert_nil(hd.host)
      assert_equal(false,hd.abs?)
      assert_equal(false,hd.absolute?)
      cwd = ::Dir.getwd
      assert_equal(cwd+'/'+hdurl,hd.abs.to_s)
      assert_equal('path:qp/',hd.to_url)
      assert_equal('file://'+RIO::RL.fs2url(cwd)+'/'+hdurl,hd.abs.to_url)

      # case qp file exists
      rio('qp').rmtree.touch

      hdurl = 'qp'
      hd = rio(hdurl)
      assert_equal('qp',hd.path)
      assert_equal('qp',hd.fspath)
      assert_equal('path',hd.scheme)    
      assert_nil(hd.host)
      assert_equal(false,hd.abs?)
      assert_equal(false,hd.absolute?)
      cwd = ::Dir.getwd
      assert_equal(cwd+'/'+hdurl,hd.abs.to_s)
      assert_equal('path:qp',hd.to_url)
      assert_equal('file://'+RIO::RL.fs2url(cwd)+'/'+hdurl,hd.abs.to_url)

      io = RIO.root
      assert_kind_of(RIO::Rio,io)
      assert_equal('/',io.to_s)


      z = RIO.rio(RIO.root,%w/tmp zippy/)
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)


      io = RIO.cwd
      assert_kind_of(RIO::Rio,io)
      cwd = ::Dir.getwd
      assert_equal(cwd,io.path)

      io = RIO.cwd
      assert_kind_of(RIO::Rio,io)
      cwd = ::Dir.getwd
      assert_equal(cwd,io.to_s)

      io = RIO.root/'tmp'
      assert_kind_of(RIO::Rio,io)
      assert_equal('/tmp',io.to_s)

      tmp = RIO.root('tmp')
      assert_kind_of(RIO::Rio,tmp)
      assert_equal('/tmp',tmp.to_s)
      
      z = tmp.join('zippy')
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)

      z = tmp/'zippy'
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)

      z = RIO.rio('/tmp/zippy')
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)
      
      z = RIO.rio(tmp,'zippy')
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)

      z = RIO.rio(RIO.root,%w/tmp zippy/)
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)

      z = RIO.rio(tmp)/'zippy'
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)

      z = rio('/tmp/zippy')
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)
      
      z = rio(tmp,'zippy')
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)

      z = rio(RIO.root,%w/tmp zippy/)
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)

      z = rio(tmp).join('zippy')
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy',z.to_s)

      require 'rio/uri/file'
      z = rio(URI('zippy/f.html'))
      assert_kind_of(RIO::Rio,z)
      assert_equal('zippy/f.html',z.to_s)

      z = rio(URI("file:///tmp/zippy/f.html"))
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy/f.html',z.to_s)

      z = rio("file:///tmp/zippy/f.html")
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy/f.html',z.to_s)

      z = rio("file:///tmp/","zippy/f.html")
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy/f.html',z.to_s)

      u = URI('zippy/f.html')

      z = rio("file:///tmp/",u)
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy/f.html',z.to_s)

      z = rio("file:///tmp/",RIO::RL::Builder.build(u))
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy/f.html',z.to_s)

      z = rio("file:///tmp/",rio(u))
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy/f.html',z.to_s)

      z = rio("/tmp",rio(u))
      assert_kind_of(RIO::Rio,z)
      assert_equal('/tmp/zippy/f.html',z.to_s)
    }
  end
end
