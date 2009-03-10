#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_base2 < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
    @base_urls = {
      'abshttp' => 'http://localhost/riotest/dir/index.html',
      'rootdir' => '/rootdir/dir/',
      'reldir'   => 'reldir/dir/',
    }
    @links = {
      'abshttp' => 'http://localhost/riotest/hw.html',
      'relfile' => '../hw.html',
      'absfile' => '/riotest/hw.html',
    }
  end

  def test_abshttp_absfile
    bk = 'abshttp'
    lk = 'absfile'
    b = @base_urls[bk]
    l = @links[lk]
    exp = [l,l,l,@links['abshttp'],l,b,@links['abshttp']]
    run_case(bk,lk,exp)
  end
  def run_case(bk,lk,exp)
    bs = @base_urls[bk]
    ls = @links[lk]

    [bs,URI(bs)].each do |b|
      [ls,URI(ls),rio(ls)].each do |l|
        u = rio(ls)
        msg = mkmsg(bk,lk,b,l)
        assert_equal(exp[0].to_s,u.to_s,msg)
        assert_equal(exp[1].to_s,u.base.to_s,msg)
        assert_equal(exp[2].to_s,u.abs.to_s,msg)
        #p "run_case: b=#{b} abs=#{u.abs(b)}"
        assert_equal(exp[3].to_s,u.abs(b).to_s,msg)
      end
    end


    [bs,URI(bs)].each do |b|
      [ls,URI(ls),rio(ls)].each do |l|
        #p "b=#{b.inspect} l=#{l.inspect}"
        u = rio(l,{:base => b})
        msg = mkmsg(bk,lk,b,l)
        assert_equal(exp[4].to_s,u.to_s,msg)
        assert_equal(exp[5].to_s,u.base.to_s,msg)
        assert_equal(exp[6].to_s,u.abs.to_s,msg)
      end
    end
  end
  def test_abshttp_relfile
    bk = 'abshttp'
    lk = 'relfile'
    b = @base_urls[bk]
    l = @links[lk]
    wd = ::Dir.getwd+'/'
    abs = ::Pathname.new(wd + l).cleanpath
    exp = [l,wd,abs,@links['abshttp'],l,b,@links['abshttp']]
    run_case(bk,lk,exp)
  end
  def test_abshttp_abshttp
    bk = 'abshttp'
    lk = 'abshttp'
    b = @base_urls[bk]
    l = @links[lk]
    exp = [l,l,l,l,l,b,l]
    run_case(bk,lk,exp)
  end
  def mkmsg(basekey,linkkey,base,link)
    "Base[#{basekey}](#{base.class}) Link[#{linkkey}](#{link.class})"
  end
end
