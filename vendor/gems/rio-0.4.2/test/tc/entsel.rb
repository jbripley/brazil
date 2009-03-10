#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_entsel < Test::RIO::TestCase
  @@once = false
  @@dirs = nil
  DN = 'd'
  OD = 'o'
  def self.once
    @@once = true
    rio(DN).rmtree.mkpath.chdir {
      mknd(3,3)
    }
  end
  def setup
    super
    self.class.once unless @@once
    @exp = rio(DN).all[]
    @lev = []
    @lev[1] = @exp.select{ |el| el.length == 3 }
    @lev[2] = @exp.select{ |el| el.length == 5 }
    @lev[3] = @exp.select{ |el| el.length == 7 }
    @olev = []
    @olev[1] = @lev[1].map{ |el| el.sub(/^d/,'o') }
    @olev[2] = @lev[2].map{ |el| el.sub(/^d/,'o') }
    @olev[3] = @lev[3].map{ |el| el.sub(/^d/,'o') }
  end
  include RIO_TestCase

  def self.mknd(n,level)
    return unless level > 0
    dirs = (0...n).map{|i| rio(i.to_s).mkdir}
    dirs.each{ |d|
      d.chdir {
        mknd(n,level-1)
      }
    }
  end

  def test_skipdirs_copy1
    odir = rio(OD).delete!
    rio(DN).skipdirs(1) > odir
    assert_array_equal([],odir.all[])
  end
  def test_skipdirs_copy2
    odir = rio(OD).delete!
    rio(DN).skipdirs(2) > odir
    assert_array_equal(@olev[1],odir.all[])
  end
  def test_skipdirs_copy3
    odir = rio(OD).delete!
    rio(DN).skipdirs(3) > odir
    assert_array_equal(@olev[1]+@olev[2],odir.all[])
  end
  def test_dirs_copy1
    odir = rio(OD).delete!
    rio(DN).dirs(1) > odir
    assert_array_equal(@olev[1],odir.all[])
  end
  def test_dirs_copy2
    odir = rio(OD).delete!
    rio(DN).dirs(0..2) > odir
    assert_array_equal(@olev[1]+@olev[2],odir.all[])
  end
  def test_dirs_copy3
    odir = rio(OD).delete!
    rio(DN).dirs(2) > odir
    assert_array_equal([],odir.all[])
  end
  def test_dirs_array
    rios1 = rios2str(rio(DN).dirs(1).to_a)
    assert_equal(@lev[1],rios1) 
    rios2 = rios2str(rio(DN).dirs(2).to_a)
    assert_equal([],rios2)
    rios3 = rios2str(rio(DN).dirs(3).to_a)
    assert_equal([],rios3)
  end
  def test_skipdirs_array
    rios1 = rios2str(rio(DN).skipdirs(1).to_a)
    assert_array_equal([],rios1) 
    rios2 = rios2str(rio(DN).skipdirs(2).to_a)
    assert_array_equal(@lev[1],rios2)
    rios3 = rios2str(rio(DN).skipdirs(3).to_a)
    assert_array_equal(@lev[1],rios3)
  end
  def test_all_skipdirs_array
    rios1 = rios2str(rio(DN).all.skipdirs(1).to_a)
    assert_array_equal(@lev[2]+@lev[3],rios1) 
    rios2 = rios2str(rio(DN).all.skipdirs(2).to_a)
    assert_array_equal(@lev[1]+@lev[3],rios2) 
    rios3 = rios2str(rio(DN).all.skipdirs(3).to_a)
    assert_array_equal(@lev[1]+@lev[2],rios3) 
  end
  def test_all_dirs_array
    rios1 = rios2str(rio(DN).all.dirs(1).to_a)
    assert_equal(@lev[1],rios1) 
    rios2 = rios2str(rio(DN).all.dirs(2).to_a)
    assert_equal(@lev[2],rios2)
    rios3 = rios2str(rio(DN).all.dirs(3).to_a)
    assert_equal(@lev[3],rios3)
  end
  def test_sel
  end
end
