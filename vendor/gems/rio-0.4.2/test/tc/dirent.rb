#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_dirent < Test::Unit::TestCase
  def smap(a) a.map { |el| el.to_s } end
  def tdir() rio(%w/qp dirent/) end
  def mkafile(*args)
    file = rio(*args)
    file < (0..1).map { |i| "L#{i}:#{file.to_s}\n" }
    file
  end
  def setup() 
    $trace_states = false
    rio('qp/dirent').delete!.mkpath.chdir do
      rio('d0').mkpath.chdir do
        rio('q1') < (0..1).map { |i| "L#{i}:d0/q1\n" }
        rio('q2') < (0..1).map { |i| "L#{i}:d0/q2\n" }
        rio('d1').mkdir.chdir do
          rio('q1') < (0..1).map { |i| "L#{i}:d0/d1/q1\n" }
          rio('q2') < (0..1).map { |i| "L#{i}:d0/d1/q2\n" }
          rio('d1').mkdir.chdir do
            rio('q1') < (0..1).map { |i| "L#{i}:d0/d1/d1/q1\n" }
            rio('q2') < (0..1).map { |i| "L#{i}:d0/d1/d1/q2\n" }
          end
          rio('d2').mkdir
        end
        rio('d2').mkdir
      end
    end
  end
  def test_dirent
    ds = %w[d0/q1 d0/q2 d0/d1 d0/d2 d0/d1/q1 d0/d1/q2 d0/d1/d1 d0/d1/d1/q1 d0/d1/d1/q2]
    rio('qp/dirent').chdir do
      begin
        ans = []
        rio('d0').entries.each do |ent|
          ans << ent
        end
        exp = ds.select { |el| el =~ %r|^d0/.\d$| }
        assert_equal(exp.sort,smap(ans).sort)
      end

      begin
        ans = []
        rio('d0').entries(/1/).each do |ent|
          ans << ent
        end
        exp = ds.select { |el| el =~ %r|^d0/.1$| }
        assert_equal(exp.sort,smap(ans).sort)
      end

      begin
        ans = []
        rio('d0').entries(/2/).each do |ent|
          ans << ent
        end
        exp = ds.select { |el| el =~ %r|^d0/.2$| }
        assert_equal(exp.sort,smap(ans).sort)
      end
    end
  end
  def test_dirent_mixed
    ds = %w[d0/q1 d0/q2 d0/d1 d0/d2 d0/d1/q1 d0/d1/q2 d0/d1/d1 d0/d1/d1/q1 d0/d1/d1/q2]
    rio('qp/dirent').chdir do
      begin
        exp = []
        ans = []
        rio('d0').entries.each { |ent| ans << ent }
        rio('d0').files.dirs.each { |ent| exp << ent }
        assert_equal(smap(exp).sort,smap(ans).sort)
      end

      begin
        re = /1/
        exp = []
        rio('d0').entries(re).each { |ent| exp << ent }
        rio('d0').files.each { |ent| exp << ent unless exp.include?(ent) }

        ans = []
        rio('d0').entries(re).files.each { |ent| ans << ent }
        assert_equal(smap(exp).sort,smap(ans).sort)
      end

      begin
        re = /1/
        exp = []
        rio('d0').entries(re).each { |ent| exp << ent }
        rio('d0').dirs.each { |ent| exp << ent unless exp.include?(ent) }


        ans = []
        rio('d0').entries(re).dirs.each { |ent| ans << ent }
        assert_equal(smap(exp).sort,smap(ans).sort)
      end

    end
  end
  def test_dirent_files
    ds = %w[d0/q1 d0/q2 d0/d1 d0/d2 d0/d1/q1 d0/d1/q2 d0/d1/d1 d0/d1/d1/q1 d0/d1/d1/q2]
    rio('qp/dirent').chdir do

      begin
        ans = []
        rio('d0').entries(/1/).each do |ent|
          ans << ent
        end
        exp = ds.select { |el| el =~ %r|^d0/.1$| }
        assert_equal(exp.sort,smap(ans).sort)
      end

      begin
        ans = []
        rio('d0').entries(/2/).each do |ent|
          ans << ent
        end
        exp = ds.select { |el| el =~ %r|^d0/.2$| }
        assert_equal(exp.sort,smap(ans).sort)
      end
    end
  end
  def test_dirent_all
    ds = %w[d0/q1 d0/q2 d0/d1 d0/d2 d0/d1/q1 d0/d1/q2 d0/d1/d1 d0/d1/d2 d0/d1/d1/q1 d0/d1/d1/q2]
    rio('qp/dirent').chdir do
      begin
        ans = []
        rio('d0').all.entries.each do |ent|
          ans << ent
        end
        exp = ds.dup
        assert_equal(exp.sort,smap(ans).sort)
      end

      begin
        ans = []
        rio('d0').all.entries(/1/).each do |ent|
          ans << ent
        end
        exp = ds.select { |el| el =~ %r|1$| }
        assert_equal(exp.sort,smap(ans).sort)
      end

      begin
        ans = []
        rio('d0').all.entries(/2/).each do |ent|
          ans << ent
        end
        exp = ds.select { |el| el =~ %r|2$| }
        assert_equal(exp.sort,smap(ans).sort)
      end

      begin
        ans = []
        rio('d0').all.entries(/q/).each do |ent|
          ans << ent
        end
        exp = ds.select { |el| el =~ %r|q\d$| }
        assert_equal(exp.sort,smap(ans).sort)
      end

      begin
        ans = []
        rio('d0').all.entries(/d/).each do |ent|
          ans << ent
        end
        exp = ds.select { |el| el =~ %r|d\d$| }
        assert_equal(exp.sort,smap(ans).sort)
      end

    end
  end
end
