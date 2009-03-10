#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'tmpdir'

class TC_riorl < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
    @tmpdir = "#{::Dir::tmpdir}"
    #p @tmpdir
    @tmppath = "#{@tmpdir}/rio"
  end

  def pathinfo(ario)
    h = {}
    [:scheme,:opaque,:path,:fspath,:to_s,:to_url,:to_uri].each do |sym|
      begin
        h[sym] = ario.__send__(sym)
      rescue
       h[sym] = 'error'
      end
    end
    h
  end
  def pinfo(fmt,pi)
    printf(fmt, pi[:scheme].inspect,pi[:opaque].inspect,pi[:path].inspect,
           pi[:fspath].inspect,pi[:to_s].inspect,pi[:to_url].inspect)
  end
  def mkrioinfo(astring)
    rinfo = mksyminfo(astring)
    rinfo[?-] = rinfo[:stdio]
    rinfo[?=] = rinfo[:stderr]
    rinfo[??] = rinfo[:temp]
    rinfo[?"] = rinfo[:strio]
    rinfo[?_] = rinfo[:sysio]
    rinfo[?`] = rinfo[:cmdio]
    rinfo[?#] = rinfo[:fd]
    rinfo
  end

  def mksyminfo(astring)
    rinfo = {
      :stdio  => ['stdio',"",nil,nil,"stdio:","stdio:"],
      :stderr => ['stderr',"",nil,nil,"stderr:","stderr:"],
      :temp => ['temp',@tmppath,nil,nil,"temp:#{@tmppath}","temp:#{@tmppath}"],
    }
    strpq = sprintf("0x%08x",astring.object_id)
    rinfo[:strio] = ['strio',strpq,nil,nil,"strio:#{strpq}","strio:#{strpq}"]

    siopq = sprintf("0x%08x",$stdout.object_id)
    rinfo[:sysio] = ['sysio',siopq,nil,nil,"sysio:#{siopq}","sysio:#{siopq}"]
    rinfo[:cmdio] = ['cmdio','echo%20x',nil,nil,'echo x','cmdio:echo%20x']
    rinfo[:fd] = ['fd','1',nil,nil,'fd:1','fd:1']
    rinfo
  end

  def mkrios1()
    rinfo = mkrioinfo(astring="")
    rios = {
      ?- => rio(?-),
      ?= => rio(?=),
      ?" => rio(?",astring),
      ?? => rio(??),
      ?_ => rio($stdout),
      ?` => rio(?`,'echo x'),
      ?# => rio(?#,1),
    }
    [rios,rinfo]
  end

  def mkrios_sym
    rinfo = mksyminfo(astring="")

    rios = {
      :stdio => rio(:stdio),
      :stderr => rio(:stderr),
      :strio => rio(:strio,astring),
      :temp => rio(:temp),
      :sysio => rio(:sysio,$stdout),
      :cmdio => rio(:cmdio,'echo x'),
      :fd => rio(:fd,1),
    }

    [rios,rinfo]
  end
  def mkrios_modfunc
    rinfo = mksyminfo(astring="")
    rios = {
      :stdio => RIO.stdio,
      :stderr => RIO.stderr,
      :strio => RIO.strio(astring),
      :temp => RIO.temp,
      :sysio => RIO.sysio($stdout),
      :cmdio => RIO.cmdio('echo x'),
      :fd => RIO.fd(1),
    }
    [rios,rinfo]
  end
  def mkrios_classmeth
    rinfo = mksyminfo(astring="")
    rios = {
      :stdio => RIO::Rio.stdio,
      :stderr => RIO::Rio.stderr,
      :strio => RIO::Rio.strio(astring),
      :temp => RIO::Rio.temp,
      :sysio => RIO::Rio.sysio($stdout),
      :cmdio => RIO::Rio.cmdio('echo x'),
      :fd => RIO::Rio.fd(1),
    }
    [rios,rinfo]
  end
  def check_rios(rios,rinfo,fmt="%-12s %-12s %-8s %-8s %-20s %-20s\n")
    #printf(fmt,'scheme','opaque','path','fspath','to_s','url')
    rios.each do |k,r|
      #pinfo(fmt,pathinfo(r))
      assert_equal(rinfo[k][0],r.scheme)
      assert_equal(rinfo[k][1],r.opaque)
      assert_equal(rinfo[k][2],r.path)
      assert_equal(rinfo[k][3],r.fspath)
      assert_equal(rinfo[k][4],r.to_s)
      assert_equal(rinfo[k][5],r.to_url)
    end
  end
  def test_specialpaths
    rios,rinfo = mkrios1()
    check_rios(rios,rinfo)
  end

  def test_specialpaths_sym
    rios,rinfo = mkrios_sym()
    check_rios(rios,rinfo)
  end
  def test_specialpaths_modfunc
    rios,rinfo = mkrios_modfunc()
    check_rios(rios,rinfo)
  end
  def test_specialpaths_classmeth
    rios,rinfo = mkrios_classmeth()
    check_rios(rios,rinfo)
  end

  def mkrios_open()
    require 'tempfile'
    stdlib_temppath = ::Tempfile.new('rio').path
    fnre = "#{@tmppath}(\\.)?\\d+.\\d+"
    rinfo = {
      ?- => ['stdout',/^$/,nil,nil,/^stdout:$/,/^stdout:$/],
      ?? => ['file',%r|//#{fnre}|,%r|#{fnre}|,%r|#{fnre}|,/#{fnre}/,/#{fnre}/],
    }
    siopq = sprintf("0x%08x",$stdout.object_id)
    rios = {
      ?- => rio(?-).print("."),
      ?? => rio(??).puts("hw"),
    }
    [rios,rinfo]
  end
  def test_specialpaths_open
    fmt = "%-12s %-12s %-8s %-8s %-20s %-20s\n"
    #printf(fmt,'scheme','opaque','path','fspath','to_s','url')
    rios,rinfo = mkrios_open()
    rios.each do |k,r|
      #pinfo(fmt,pathinfo(r))
      assert_equal(rinfo[k][0],r.scheme)
      assert_match(rinfo[k][1],r.opaque)
      assert_match(rinfo[k][4],r.to_s)
      assert_match(rinfo[k][5],r.to_url)
    end
    assert_match(rinfo[??][2],rios[??].path)
    assert_match(rinfo[??][3],rios[??].fspath)
  end
end
