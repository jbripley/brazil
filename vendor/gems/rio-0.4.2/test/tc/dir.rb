#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
class TC_dir < Test::Unit::TestCase
  include RIO_TestCase
  def setup()
    super
    rio('a').rmtree.mkpath
    rio('a/d').mkpath
    rio('a/f').touch
    @ents = %w[. .. d f]
    @rents = @ents.map { |ds| rio(ds) }
  end
  def test_read
    d = rio('a')
    ans = []
    while ent = d.read
      ans << ent
    end
    assert_equal(@rents,ans)
    assert(d.closed?)
  end
  def test_rewind
    d = rio('a').nocloseoneof
    ans = []
    while ent = d.read
      ans << ent
    end
    assert_equal(@rents,ans)
    assert!(d.closed?)
    d.rewind
    while ent = d.read
      ans << ent
    end
    assert_equal(@rents+@rents,ans)
    d.close
  end
  def test_seek
    d = rio('a').nocloseoneof
    ans = []
    poss = {}
    while true
      ps = d.tell
      ent = d.read
      break if ent.nil?
      poss[ent] = ps
    end
    poss.each do |e,ps|
      ent = d.seek(ps).read
      assert_equal(e,ent)
    end
    d.close
  end
  def test_pos
    d = rio('a').nocloseoneof
    ans = []
    poss = {}
    while true
      ps = d.pos
      ent = d.read
      break if ent.nil?
      poss[ent] = ps
    end
    poss.each do |e,ps|
      d.pos = ps
      ent = d.read
      assert_equal(e,ent)
    end
    d.close
  end
end
