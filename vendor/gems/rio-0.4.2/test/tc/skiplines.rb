#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_skiplines < Test::RIO::TestCase
  @@once = false
  N_LINES = 25
  def self.once
    @@once = true
    #rio('f1') < (0...N_LINES).map { |i| "L#{i}:f1" + $/ }
    rio('f2') < (0...N_LINES).map { |i| "L#{i}:f2" + $/ }
    #rio('g1') < (0...N_LINES).map { |i| "L#{i}:g1" + $/ }
    #rio('g2') < (0...N_LINES).map { |i| "L#{i}:g2" + $/ }
  end
  def setup
    super
    self.class.once unless @@once
    
    @lines = {}
    #%w[f1 f2 g1 g2].each do |fname|
    %w[f2].each do |fname|
      @lines[fname] = rio(fname).to_a
    end
  end

  def test_basic
    fname = 'f2'

    re = /1/
    exp = @lines[fname].reject{ |l| l =~ re }

    ans = []
    rio(fname).skiplines(re) { |l| ans << l }
    assert_equal(exp,ans,"skiplines using #each with regular expression")
    ans = rio(fname).skiplines[re]
    assert_equal(exp,ans,"skiplines using array operator with regular expression")

    rng = (2..9)

    exp = @lines[fname][0..rng.first-1] + @lines[fname][rng.last+1...N_LINES]

    ans = []
    rio(fname).skiplines(rng) { |l| ans << l }
    assert_equal(exp,ans,"skiplines using #each with line range")
    ans = rio(fname).skiplines[rng]
    assert_equal(exp,ans,"skiplines using array operator with line range")
    

  end
  def test_prefix_lines
#    exprio = rio(@d0).skipfiles(/1/)
#    ansrio = rio(@d0).skip.files(/1/)
    r = rio('f1').skip.lines(1)
#    p r.cx
#    p r.to_a
#    assert_equal(smap(exprio[]),smap(ansrio[]))
  end
  def test_skip_param
#    exprio = rio(@d0).skipfiles(/1/)
#    ansrio = rio(@d0).skip.files(/1/)
    r = rio('f1').lines(/^L/).skip(1..2)
#    p r.to_a
#    assert_equal(smap(exprio[]),smap(ansrio[]))
  end

end
