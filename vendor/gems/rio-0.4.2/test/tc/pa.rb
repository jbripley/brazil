#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

def smap(a) a.map { |el| el.to_s } end

class TC_RIO_pa < Test::Unit::TestCase
  def test_pa
    s_dir = ''
    #$trace_states = true
    tdir = rio(%w/qp pa/)
    tdir.rmtree.mkpath.chdir {
      rio(%w/d0 d00 d000/).mkpath
      rio(%w/d1 d10 d000/).mkpath
      rio(%w/d1 d10 d100/).mkpath
      rio(%w/d1 d11/).mkpath
      %w[d1/f0.txt d1/d10/f0.txt d1/d10/f1.txt d1/d10/f2.emp f0.txt d1/d10/d000/f100.txt].each do |e|
        rio(e) << (0..2).map { |n| "L#{n}:#{e}\n" }
      end
    }
    
    tdir.chdir do
      ario = rio('d1')
      exp = ["d1/f0.txt"]
      assert_equal(exp,smap(ario[/x/]))

      ario = rio('f0.txt')
      exp = ["L0:f0.txt\n", "L1:f0.txt\n", "L2:f0.txt\n"]
      assert_equal(exp,smap(ario[/x/]))

      ario = rio('d1')
      ans = []
      #$trace_states = true
      ario.each do |ent|
        ent.files { |el| ans << el }
      end
      exp = ["d1/d10/f0.txt","d1/d10/f1.txt","d1/d10/f2.emp","d1/f0.txt"]
      assert_equal(exp,smap(ans))
      ario = rio('d1')
      ans = []
      ario.each do |ent|
        ent.files(/x/) { |el| ans << el }
      end
      exp = ["d1/d10/f0.txt", "d1/d10/f1.txt", "d1/f0.txt"]
      assert_equal(exp,smap(ans))

      ario = rio('d1')
      ans = ario[/x/]
      exp = ["d1/f0.txt"]
      assert_equal(exp,smap(ans))

      ans = []
      rio('d1').all.files('*.emp').lines(/L2/) { |el| ans << el }
      exp = ["L2:d1/d10/f2.emp\n"]
      assert_equal(exp,smap(ans))

      ans = []
      rio('d1').all.files('*.?x?').lines(/L2/) { |el| ans << el }
      exp = ["L2:d1/d10/d000/f100.txt\n", "L2:d1/d10/f0.txt\n", "L2:d1/d10/f1.txt\n", "L2:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = []
      rio('d1').all.files('*.?x?').lines(2) { |el| ans << el }
      exp = ["L2:d1/d10/d000/f100.txt\n", "L2:d1/d10/f0.txt\n", "L2:d1/d10/f1.txt\n", "L2:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = []

      rio('d1').all.files('*.?x?').lines(2...3) { |el| ans << el }
      exp = ["L2:d1/d10/d000/f100.txt\n", "L2:d1/d10/f0.txt\n", "L2:d1/d10/f1.txt\n", "L2:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))
      
      ans = rio('d1').all.files('*.?x?').lines(/L1/).to_a
      exp = ["L1:d1/d10/d000/f100.txt\n", "L1:d1/d10/f0.txt\n", "L1:d1/d10/f1.txt\n", "L1:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.files('*.?x?').lines[/L1/]
      exp = ["L1:d1/d10/d000/f100.txt\n", "L1:d1/d10/f0.txt\n", "L1:d1/d10/f1.txt\n", "L1:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.lines(/L1/).files['*.?x?']
      exp = ["L1:d1/d10/d000/f100.txt\n", "L1:d1/d10/f0.txt\n", "L1:d1/d10/f1.txt\n", "L1:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.files('*.?x?').lines[1]
      exp = ["L1:d1/d10/d000/f100.txt\n", "L1:d1/d10/f0.txt\n", "L1:d1/d10/f1.txt\n", "L1:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.files('*.?x?').lines[1...2]
      exp = ["L1:d1/d10/d000/f100.txt\n", "L1:d1/d10/f0.txt\n", "L1:d1/d10/f1.txt\n", "L1:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.lines(/L0/).files[/f0/]
      exp = ["L0:d1/d10/f0.txt\n", "L0:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.lines(/L0/).files[]
      exp = ["L0:d1/d10/d000/f100.txt\n", "L0:d1/d10/f0.txt\n", "L0:d1/d10/f1.txt\n", "L0:d1/d10/f2.emp\n", "L0:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.files(/f0/).lines[/L0/]
      exp = ["L0:d1/d10/f0.txt\n", "L0:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.files(/f0/).lines[]
      exp = ["L0:d1/d10/f0.txt\n", "L1:d1/d10/f0.txt\n", "L2:d1/d10/f0.txt\n", "L0:d1/f0.txt\n", "L1:d1/f0.txt\n", "L2:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.bytes(8).records(0..1).files[/f0/]
      exp = ["L0:d1/d10/f0.txt\nL1:d1/d10/f0.txt\nL2:d1/d10/f0.txt\n", "L0:d1/f0.txt\nL1:d1/f0.txt\nL2:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.bytes(8).files(/f0/).records[0..1]
      exp = ["L0:d1/d10/f0.txt\nL1:d1/d10/f0.txt\nL2:d1/d10/f0.txt\n", "L0:d1/f0.txt\nL1:d1/f0.txt\nL2:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))


      ans = rio('d1').all.bytes(32).files(/f0/).records[]
      exp = ["L0:d1/d10/f0.txt\nL1:d1/d10/f0.txt\nL2:d1/d10/f0.txt\n", "L0:d1/f0.txt\nL1:d1/f0.txt\nL2:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.bytes(32).files[/f0/]
      exp = ["L0:d1/d10/f0.txt\nL1:d1/d10/f0.txt\nL2:d1/d10/f0.txt\n", "L0:d1/f0.txt\nL1:d1/f0.txt\nL2:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.bytes.files['*.emp']
      exp = ["L0:d1/d10/f2.emp\nL1:d1/d10/f2.emp\nL2:d1/d10/f2.emp\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.files('*.emp').bytes[]
      exp = ["L0:d1/d10/f2.emp\nL1:d1/d10/f2.emp\nL2:d1/d10/f2.emp\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.lines[]
      exp = ["L0:d1/d10/d000/f100.txt\n", "L1:d1/d10/d000/f100.txt\n", "L2:d1/d10/d000/f100.txt\n", 
             "L0:d1/d10/f0.txt\n", "L1:d1/d10/f0.txt\n", "L2:d1/d10/f0.txt\n", 
             "L0:d1/d10/f1.txt\n", "L1:d1/d10/f1.txt\n", "L2:d1/d10/f1.txt\n", 
             "L0:d1/d10/f2.emp\n", "L1:d1/d10/f2.emp\n", "L2:d1/d10/f2.emp\n", 
             "L0:d1/f0.txt\n", "L1:d1/f0.txt\n", "L2:d1/f0.txt\n"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all[]
      exp = ["d1/d10", "d1/d10/d000", "d1/d10/d000/f100.txt", "d1/d10/d100", 
             "d1/d10/f0.txt", "d1/d10/f1.txt", "d1/d10/f2.emp", "d1/d11", "d1/f0.txt"]
      assert_equal(exp,smap(ans))

      ans = rio('d1').all.files('*.emp').lines[]
      exp = ["L0:d1/d10/f2.emp\n", "L1:d1/d10/f2.emp\n", "L2:d1/d10/f2.emp\n"]
      assert_equal(exp,smap(ans))
    end
  end
end
