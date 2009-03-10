#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'tc/testcase'

class TC_clone < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
    @lines = (0..8).map { |n| "Line#{n}" }
    @chlines = @lines.map{|el| el.chomp}
    ::File.open('lines1','w') do |f|
      @lines.each do |li|
        f.puts(li)
      end
    end
    ::File.open('lines2','w') do |f|
      @lines.each do |li|
        f.puts(li)
      end
    end
    @lines = rio('lines1').to_a
  end


  def check_clone(ios)
    oexp = []
    cexp = []

    oexp << ios.gets
    ioc = ios.clone

    cexp << ioc.gets
    oexp << ios.gets
    while ans = ioc.gets
      cexp << ans
    end

    while ans = ios.gets
      oexp << ans
    end
    return ioc,oexp,cexp
  end

  def check_dup(ios)
    oexp = []
    cexp = []

    oexp << ios.gets
    ioc = ios.dup
    assert_not_nil(ioc,"dup returns nil")
    cexp << ioc.gets
    oexp << ios.gets
    while ans = ioc.gets
      cexp << ans
    end

    while ans = ios.gets
      oexp << ans
    end
    return ioc,oexp,cexp
  end

  def check_clone_close(ios,ioc)
    assert!(ios.closed?,"original not closed")
    assert!(ioc.closed?,"clone not closed")
    ioc.close
    assert(ioc.closed?,"clone closed?")
    assert!(ios.closed?," orignal still not closed?")
    ios.close
    assert(ios.closed?,"now original closed")
  end

  def check_dup_close(ios,ioc)
    assert!(ios.closed?,"original not closed")
    assert(ioc.closed?,"dup closed")
    ios.close
    assert(ios.closed?,"now original closed")
  end

  def test_clone_closes_like_IO
    ios = ::File.open('lines1')
    ioc,oexp,cexp = check_clone(ios)
    check_clone_close(ios,ioc)
    ioc.close unless ioc.closed?
    ios.close unless ios.closed?

    ario = rio('lines1').nocloseoneof
    crio,oans,cans = check_clone(ario)
    assert_equal(oexp,oans)
    assert_equal(cexp,cans)
    check_clone_close(ario,crio)

  end

  def test_dup_doesnt_close_like_IO

    ios = ::File.open('lines1')
    ioc,oexp,cexp = check_dup(ios)
    check_clone_close(ios,ioc)
    ario = rio('lines1').nocloseoneof
    crio,oans,cans = check_dup(ario)
    assert_equal(@lines,oans)
    assert_equal(@lines,cans)
    check_dup_close(ario,crio)

  end

  def test_clone_own_context

    assert(rio.closeoncopy?,"closeoncopy is on")
    assert!(rio.nocloseoncopy.closeoncopy?,"nocloseoncopy is off")
    assert!(rio.chomp?,"chomp is off")
    chomper = rio.chomp
    assert(chomper.chomp?,"chomp is on")
    cl = chomper.clone
    assert(cl.chomp?,"cloned chomp is on")
    cl.nochomp
    assert!(cl.chomp?,"cloned chomp is off")
    assert(chomper.chomp?,"original chomp is still on")

    chomper.join!('lines1')
    ans = chomper.to_a
    assert_equal(@chlines,ans)

    cl.join!('lines1')
    ans = cl.to_a
    assert_equal(@lines,ans)

  end
  def test_read_moves_pos_like_IO
    #$trace_states = true
    fnio = ::File.open('lines1')
    frio = rio('lines2')
    assert_equal(fnio.pos,frio.pos)

    nrec = fnio.gets
    rrec = frio.gets
    assert_equal(nrec,rrec)
    assert_equal(fnio.pos,frio.pos)

    cfnio = fnio.clone
    cfrio = frio.clone
    assert_equal(cfnio.pos,cfrio.pos)
    assert_equal(fnio.pos,frio.pos)
    nrec = cfnio.gets
    rrec = cfrio.gets
    assert_equal(nrec,rrec)
    assert_equal(cfnio.pos,cfrio.pos)
    assert_equal(fnio.pos,frio.pos)

    nrec = cfnio.gets
    rrec = cfrio.gets

    assert_equal(nrec,rrec)
    assert_equal(cfnio.pos,cfrio.pos)
    assert_equal(fnio.pos,frio.pos)

    nrec = fnio.gets
    rrec = frio.gets
    assert_equal(nrec,rrec)
    #assert_equal(fnio.pos,frio.pos)

  end

  def test_clone_read_ruby

    #$trace_states = true
    afile = ::File.open('lines1')
    arec = afile.gets
    assert_equal(@lines[0],arec)
    cfile = afile.dup
    #p "POS: a(#{afile.pos}) c(#{cfile.pos})"
    crec = cfile.gets
    #p "crec=#{crec} POS: a(#{afile.pos}) cfile(#{cfile.pos})"
    afile.close
  end
  def test_clone_read
    #return unless $supports_symlink
    ario = rio('lines1')
    arec = ario.getrec
    assert_equal(@lines[0],arec)
    crio = ario.clone.chomp
    #p "POS: ario(#{ario.pos}) crio(#{crio.pos})"
    crec = crio.getrec
    #p "crec=#{crec} POS: ario(#{ario.pos}) crio(#{crio.pos})"

    assert_equal(@chlines[1],crec)

    arec = ario.getrec
    cremaining = crio.to_a

    assert_equal(@chlines[2...@lines.size],cremaining)
    #p "#{crio.eof?} #{crio.closed?}"
    #$trace_states = true
    assert(crio.eof?,"clone eof?") unless crio.closed?
    assert(crio.closed?,"clone closed?")

  end

end
