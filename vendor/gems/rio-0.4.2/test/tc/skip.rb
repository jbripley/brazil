#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_skip < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('d0').rmtree.mkpath.chdir {
      rio('f1') < (0..1).map { |i| "L#{i}:d0/f1\n" }
      rio('f2') < (0..1).map { |i| "L#{i}:d0/f2\n" }
      rio('g1') < (0..20).map { |i| "L#{i}:d0/g1\n" }
      rio('g2') < (0..20).map { |i| "L#{i}:d0/g2\n" }
      if $supports_symlink
        rio('x1').symlink('n1')
        rio('x2').symlink('n2')
        rio('f1').symlink('l1')
        rio('f2').symlink('l2')
        rio('d1').symlink('c1')
        rio('d2').symlink('c2')
      end
    }
  end
  def setup
    super
    self.class.once unless @@once
    @d0 = rio('d0')
    @g1 = @d0/'g1'
    @g2 = @d0/'g2'
  end

  def test_ent_prefix_files
    exprio = rio(@d0).skipfiles(/1/)
    ansrio = rio(@d0).skip.files(/1/)
    assert_equal(smap(exprio[]),smap(ansrio[]))
  end
  def test_ent_prefix_dirs
    exprio = rio(@d0).skipdirs(/1/)
    ansrio = rio(@d0).skip.dirs(/1/)
    assert_equal(exprio[],ansrio[])
  end
  def test_ent_prefix_entries
    exprio = rio(@d0).skipentries(/1/)
    ansrio = rio(@d0).skip.entries(/1/)
    assert_equal(exprio[],ansrio[])
  end
  def test_ent_alone
    exprio = rio(@d0).skipentries(/1/)
    ansrio = rio(@d0).skip(/1/)
    assert_equal(exprio[],ansrio[])
  end
  def test_ent_alone_a
    exp = rio(@d0).skipentries[/1/]
    ans = rio(@d0).skip[/1/]
    assert_equal(exp,ans)
  end
  def test_ent_postfix_a
    exp = rio(@d0).files(/1/).skipfiles[:symlink?]
    ans = rio(@d0).files(/1/).skip[:symlink?]
    
    assert_equal(exp,ans)
  end
  def test_rec_prefix_a
    exp = rio(@g2).skiplines[/1/]
    ans = rio(@g2).skip.lines[/1/]
    
    assert_equal(exp,ans)
  end
  def test_rec_postfix_a
    exp = rio(@g1).lines[/2/]
    #p exp
    exp = rio(@g1).records(/2/).skip[/L2/]
    #p exp
#    ans = rio(@g1).lines(/2/).skip[0..5]
#    p ans
    
#    assert_equal(exp,ans)
  end
  def test_prefix_atend
#    exprio = rio(@d0).skipentries(/1/)
    ansrio = rio(@d0).skip[]
#    assert_equal(exprio[],ansrio[])
  end
end
