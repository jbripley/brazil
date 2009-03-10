#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_RIO_expand_path < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true

  end

  def setup
    super
    self.class.once unless @@once
  end

  def test_expand_path_from_cwd
    require 'tmpdir'

    tmp = rio(::Dir.tmpdir)
    tmp.chdir do
      rel = rio('groovy')
      exp = rio(tmp,rel)
      ans = rel.expand_path
      assert_kind_of(RIO::Rio,ans)
      assert_equal(exp,ans)
    end
  end

  def test_expand_path_from_base_rio
    srel = 'groovy'
    sbase = '/tmp'
    rel = rio(srel)
    base = rio(sbase)
    exp = File.expand_path(srel,sbase)
    ans = rel.expand_path(base)
    assert_kind_of(RIO::Rio,ans)
    assert_equal(exp,ans)
  end

  def test_expand_path_from_base_string
    srel = 'groovy'
    sbase = '/tmp'
    rel = rio(srel)
    base = rio(sbase)
    exp = File.expand_path(srel,sbase)
    ans = rel.expand_path(sbase)
    assert_kind_of(RIO::Rio,ans)
    assert_equal(exp,ans)
  end

  def test_expand_path_from_tilde
    return if $mswin32
    srel = 'groovy'
    sbase = '~'
    rel = rio(srel)
    base = rio(sbase)
    exp = File.expand_path(srel,sbase)
    ans = rel.expand_path(sbase)
    assert_kind_of(RIO::Rio,ans)
    assert_equal(exp,ans)
  end

end
