#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_synopsis < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('adir').rmtree.mkpath.chdir {
      rio('f1.rb') < (0..6).map { |i| "L#{i}:adir/f1\n" }
      rio('f2.rb') < (0..6).map { |i| "L#{i}:adir/f2\n" }
      rio('d1').mkdir.chdir {
        rio('g1.rb') < (0..20).map { |i| "L#{i}:adir/d1/g1\n" }
        rio('g2.rb') < (0..20).map { |i| "L#{i}:adir/d1/g2\n" }
      }
      if $supports_symlink
        rio('f1.rb').symlink('l1.rb')
        rio('f2.rb').symlink('l2.rb')
      end
    }
  end
  def setup
    super
    self.class.once unless @@once
  end

  def test_iter1
    exp = %w[f1 f2 l1 l2].map{|fb| rio('adir',fb +'.rb')}
    ans = []
    rio('adir').files('*.rb') { |ent| ans << ent }
    assert_equal(exp,ans)
  end
  def test_ary1
    exp = %w[f1 f2 l1 l2].map{|fb| rio('adir',fb +'.rb')}
    ans = rio('adir').files['*.rb']
    assert_equal(exp,ans)
  end

  def test_cp1
    exp = %w[f1 f2 l1 l2].map{|fb| rio('bdir',fb +'.rb')}
    rio('adir').files('*.rb') > rio('bdir').delete!
    assert_equal(smap(exp),smap(rio('bdir').to_a))
  end
  def test_iter2
    exp = %w[d1/g1 d1/g2 f1 f2 l1 l2].map{|fb| rio('adir',fb +'.rb')}
    ans = []
    rio('adir').all.files('*.rb') { |ent| ans << ent }
    assert_equal(smap(exp),smap(ans))
  end

  def test_ary2
    exp = %w[d1/g1 d1/g2 f1 f2 l1 l2].map{|fb| rio('adir',fb +'.rb')}
    ans = rio('adir').all.files['*.rb']
    assert_equal(smap(exp),smap(ans))
  end

  def test_gziplines
    rio('gz1.rb.gz').gzip < rio('adir','f1.rb')
    rio('gz1.rb.gz').gzip > rio('o.rb')
    exp = (0..6).map { |i| "L#{i}:adir/f1\n" }
    assert_equal(exp,rio('o.rb').to_a)
    ans = rio('gz1.rb.gz').gzip[0..2]
    assert_equal(exp[0..2],ans)
  end
  def test_ary_skip_symlink
    exp = %w[f1 f2].map{|fb| rio('adir',fb +'.rb')}
    ans = rio('adir').files('*.rb').skip[:symlink?]
    assert_equal(exp,ans)
  end
end
