#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_RIO_entary < Test::Unit::TestCase
  def smap(a) a.map { |el| el.to_s } end
  def tdir() rio(%w/qp entary/) end
  def mkafile(*args)
    file = rio(*args)
    file < (0..1).map { |i| "L#{i}:#{file.to_s}\n" }
    file
  end
  def setup() 
    $trace_states = false
    rio('qp/entary').delete!.mkpath.chdir do
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
  def test_entary_nofile
    ds = %w[d0/q1 d0/q2 d0/d1 d0/d2 d0/d1/q1 d0/d1/q2 d0/d1/d1 d0/d1/d1/q1 d0/d1/d1/q2]
    return unless $supports_symlink
    rio('qp/entary').chdir do
      begin
        rio('d1').delete!.mkpath.chdir do
          rio('q1') < (0..1).map { |i| "L#{i}:d1/q1\n" }
          rio('q2') < (0..1).map { |i| "L#{i}:d1/q2\n" }
          rio('q1').symlink('lq1')
          rio('d1').mkdir
          rio('d1').symlink('ld1')
          rio('d2').mkdir
        end
        ds = %w[d1/q1 d1/q2 d1/d1 d1/d2 d1/lq1 d1/ld1]
        begin
          ans = rio('d1').files[]
          exp = ds.select { |el| el =~ /q\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').dirs[]
          exp = ds.select { |el| el =~ /d\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').entries[]
          exp = ds.select { |el| el =~ /(l)?[qd]\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        begin
          rio('d1/q1').delete
          ds = ds.reject { |el| el =~ %r|^d1/q1$| }

          ans = rio('d1').files[]
          exp = ds.select { |el| el =~ /q2$/ }
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').dirs[]
          exp = ds.select { |el| el =~ /d\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').entries[]
          exp = ds.select { |el| el =~ /(l)?[qd]\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        begin
          rio('d1/d1').delete
          ds = ds.reject { |el| el =~ %r|^d1/d11$| }
          
          ans = rio('d1').files[]
          exp = ds.select { |el| el =~ /q2$/ }
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').dirs[]
          exp = ds.select { |el| el =~ /d2$/ }
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').entries[]
          exp = ds.select { |el| el =~ /l[qd]1$/ or el =~ /[qd]2$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end

      end
    end
  end
  def test_entary_nofile_symlink
    ds = %w[d0/q1 d0/q2 d0/d1 d0/d2 d0/d1/q1 d0/d1/q2 d0/d1/d1 d0/d1/d1/q1 d0/d1/d1/q2]
    return unless $supports_symlink
    rio('qp/entary').chdir do
      begin
        rio('d1').delete!.mkpath.chdir do
          rio('q1') < (0..1).map { |i| "L#{i}:d1/q1\n" }
          rio('q2') < (0..1).map { |i| "L#{i}:d1/q2\n" }
          rio('q1').symlink('lq1')
          rio('d1').mkdir
          rio('d1').symlink('ld1')
          rio('d2').mkdir
        end
        ds = %w[d1/q1 d1/q2 d1/d1 d1/d2 d1/lq1 d1/ld1]

        begin
          ans = rio('d1').files[/1/]
          exp = ds.select { |el| el =~ /q1$/ }
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').dirs[/1/]
          exp = ds.select { |el| el =~ /d1$/ }
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').entries[/1/]
          exp = ds.select { |el| el =~ /(l)?[qd]1$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          rio('d1/q1').delete
          ds = ds.reject { |el| el =~ %r|^d1/q1$| }

          ans = rio('d1').files[/1/]
          exp = []
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').dirs[/1/]
          exp = ds.select { |el| el =~ /d1$/ }
          assert_equal(exp.sort,smap(ans).sort)

          ans = rio('d1').entries[/1/]
          exp = ds.select { |el| el =~ /(l)?[qd]1$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        begin
          rio('d1/d1').delete
          ds = ds.reject { |el| el =~ %r|^d1/d11$| }
          
          ans = rio('d1').files[/1/]
          exp = []
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').dirs[/1/]
          exp = []
          assert_equal(exp.sort,smap(ans).sort)
          
          ans = rio('d1').entries[/1/]
          exp = ds.select { |el| el =~ /l[qd]1$/  }
          assert_equal(exp.sort,smap(ans).sort)
        end

      end
    end
  end
  def test_entary
    ds = %w[d0/q1 d0/q2 d0/d1 d0/d2 d0/d1/q1 d0/d1/q2 d0/d1/d1 d0/d1/d1/q1 d0/d1/d1/q2]
    rio('qp/entary').chdir do
      begin
        ans = []
        exp = []
        rio('d0').dirs.files.each { |ent| exp << ent }

        ans.clear
        rio('d0').entries.each { |ent| ans << ent }
        assert_equal(smap(exp).sort,smap(ans).sort)

        ans.clear
        rio('d0').entries { |ent| ans << ent }
        assert_equal(smap(exp).sort,smap(ans).sort)

        ans = rio('d0').entries[]
        assert_equal(smap(exp).sort,smap(ans).sort)

      end

      begin
        ans = []
        exp = []
        rio('d0').dirs(/1/).files(/1/).each { |ent| exp << ent }

        ans.clear
        rio('d0').entries(/1/).each { |ent| ans << ent }
        assert_equal(smap(exp).sort,smap(ans).sort)

        ans.clear
        rio('d0').entries(/1/) { |ent| ans << ent }
        assert_equal(smap(exp).sort,smap(ans).sort)

        ans = rio('d0').entries[/1/]
        assert_equal(smap(exp).sort,smap(ans).sort)

        ans = rio('d0')[/1/]
        assert_equal(smap(exp).sort,smap(ans).sort)

      end

      begin
        ans = []
        exp = []
        rio('d0').entries(/1/).each { |ent| exp << ent }
        rio('d0').files.each { |ent| exp << ent unless exp.include?(ent)}
        
        ans.clear
        rio('d0').entries(/1/).files.each { |ent| ans << ent }
        assert_equal(smap(exp).sort,smap(ans).sort)
        
        ans = rio('d0').files.entries[/1/]
        assert_equal(smap(exp).sort,smap(ans).sort)
        
        ans = rio('d0').entries(/1/).files[]
        assert_equal(smap(exp).sort,smap(ans).sort)
        
      end
      
    end
  end
end
