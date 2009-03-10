#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'tmpdir'

class TC_selnosel < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('dir').delete!.mkpath.chdir {
      rio('f1').touch
      rio('f2').touch
      rio('g1').touch
      rio('g2').touch
    }
  end
  def setup
    super
    self.class.once unless @@once
    @dir = rio('dir')
  end

  def test_selnosel
    ario = @dir.files('f*').skipfiles(/1/,:symlink?)
    ans = ario.to_a
    assert_equal(%w[dir/f2],smap(ans))
  end
end
