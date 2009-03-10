#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_qae < Test::Unit::TestCase
  @@tdir = rio(%w/qp qae/)
  @@once = false

  def smap(a) a.map { |el| el.to_s } end
  def setup
    s_dir = ''
    #$trace_states = true
    unless @@once
      @@once = true
      @@tdir.rmtree.mkpath.chdir do
        rio('d0').mkpath.chdir {
          rio('d2').mkpath
          rio('d1').mkpath.chdir {
            rio('d2').mkpath.chdir {
              rio('d1').mkpath.chdir {
                rio('q1') < (0..1).map { |i| "L#{i}:d0/d1/d2/d1/q1\n" }
                rio('q2') < (0..1).map { |i| "L#{i}:d0/d1/d2/d1/q2\n" }
              }
              rio('q1') < (0..1).map { |i| "L#{i}:d0/d1/d2/q1\n" }
            }
          }
          rio('q1') < (0..1).map { |i| "L#{i}:d0/q1\n" }
          rio('q2') < (0..1).map { |i| "L#{i}:d0/q2\n" }
        }
        
        rio('d1').mkpath.chdir {
          rio('d1').mkpath.chdir {
            rio('q1') < (0..1).map { |i| "L#{i}:d1/d1/q1\n" }
            rio('q2') < (0..1).map { |i| "L#{i}:d1/d1/q2\n" }
          }
          rio('d2').mkpath.chdir {
            rio('d1').mkpath.chdir {
              rio('q1') < (0..1).map { |i| "L#{i}:d1/d2/d1/q1\n" }
              rio('q2') < (0..1).map { |i| "L#{i}:d1/d2/d1/q2\n" }
            }
            rio('d2').mkpath
          }
          rio('d3').mkpath.chdir {
            rio('d1').mkpath.chdir {
              rio('q1') < (0..1).map { |i| "L#{i}:d1/d3/d1/q1\n" }
              rio('d1').mkpath
            }
            rio('q1') < (0..1).map { |i| "L#{i}:d1/d3/q1\n" }
          }
        }
      end
    end
  end

  def test_qae_fs_lines 
    rio('qp/qae').chdir do
      begin
        begin
          ans = []
          rio('d0').files.each { |f|
            f.each { |el|
              ans << el 
            }
          }
          exp = ["L0:d0/q1\n","L1:d0/q1\n","L0:d0/q2\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ans = []
          rio('d0').files.lines.each { |el| ans << el }
          exp = ["L0:d0/q1\n","L1:d0/q1\n","L0:d0/q2\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').lines.files.each { |el| ans << el }
          exp = ["L0:d0/q1\n","L1:d0/q1\n","L0:d0/q2\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').files.lines(/L1/).each { |el| ans << el }
          exp = ["L1:d0/q1\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').lines(/L1/).files.each { |el| ans << el }
          exp = ["L1:d0/q1\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').lines.each { |el| ans << el }
          exp = ["L0:d0/q1\n","L1:d0/q1\n","L0:d0/q2\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').lines(/L1/).each { |el| ans << el }
          exp = ["L1:d0/q1\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
    end
  end

  def test_qae_fs_lines_ss
    rio('qp/qae').chdir do
      begin
        begin
          ans = []
          rio('d0').files.each { |f|
            f.each { |el|
              ans << el 
            }
          }
          exp = ["L0:d0/q1\n","L1:d0/q1\n","L0:d0/q2\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ans = rio('d0').files.lines[]
          exp = ["L0:d0/q1\n","L1:d0/q1\n","L0:d0/q2\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').lines.files[]
          exp = ["L0:d0/q1\n","L1:d0/q1\n","L0:d0/q2\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').files.lines[/L1/]
          exp = ["L1:d0/q1\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').lines(/L1/).files[]
          exp = ["L1:d0/q1\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').lines[]
          exp = ["L0:d0/q1\n","L1:d0/q1\n","L0:d0/q2\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').lines[/L1/]
          exp = ["L1:d0/q1\n","L1:d0/q2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
    end
  end

  def test_qae_chomp 
    rio('qp/qae').chdir do
      begin
        begin
          ans = []
          rio('d0/q1').each { |el|
            ans << el 
          }
          exp = ["L0:d0/q1\n","L1:d0/q1\n"]
          assert_equal(exp,ans)
        end
        
        begin
          ans = []
          rio('d0/q1').chomp.each { |el|
            ans << el 
          }
          exp = ["L0:d0/q1","L1:d0/q1"]
          assert_equal(exp,ans)
        end
        
      end
    end
  end

  def test_qae_fs_nest
    ds = ['d1/d1','d1/d2','d1/d1/q1','d1/d1/q2','d1/d2/d1','d1/d2/d1/q1','d1/d2/d1/q2','d1/d2/d2',
          'd1/d3','d1/d3/d1','d1/d3/q1','d1/d3/d1/q1','d1/d3/d1/d1']
    rio('qp/qae').chdir do
      begin
        begin
          ans = []
          rio('d1').dirs.each { |dir|
            dir.each { |ent| 
              ans << ent 
            }
          }
          exp = ds.select { |el| el =~ %r|^d1/d\d/.\d$| }
          assert_equal(smap(exp).sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d1').dirs.each { |dir|
            dir.dirs.each { |ent| 
              ans << ent 
            }
          }
          exp = ds.select { |el| el =~ %r|^d1/d\d/d\d$| }
          assert_equal(smap(exp).sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d1').dirs.each { |dir|
            dir.dirs(/1/).each { |ent| 
              ans << ent 
            }
          }
          exp = ds.select { |el| el =~ %r|^d1/d\d/d1$| }
          assert_equal(smap(exp).sort,smap(ans).sort)
        end

        begin
          ans = []
          rio('d1').dirs.each { |dir|
            dir.all.dirs.each { |ent| 
              ans << ent 
            }
          }
          exp = ds.select { |el| el =~ %r|^d1/d\d/| && el =~ %r|d\d$|}
          assert_equal(smap(exp).sort,smap(ans).sort)
        end

        begin
          ans = []
          rio('d1').dirs.each { |dir|
            dir.all.dirs(/1/).each { |ent| 
              ans << ent 
            }
          }
          exp = ds.select { |el| el =~ %r|^d1/d\d/| && el =~ %r|d1$|}
          assert_equal(smap(exp).sort,smap(ans).sort)
        end
        

        begin
          ans = []
          rio('d1').dirs.each { |dir|
            dir.files.each { |ent| 
              ans << ent 
            }
          }
          exp = ds.select { |el| el =~ %r|^d1/d\d/q\d$| }
          assert_equal(smap(exp).sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d1').dirs.each { |dir|
            dir.files(/1/).each { |ent| 
              ans << ent 
            }
          }
          exp = ds.select { |el| el =~ %r|^d1/d\d/q1$| }
          assert_equal(smap(exp).sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d1').dirs.each { |dir|
            dir.all.files.each { |ent| 
              ans << ent 
            }
          }
          exp = ds.select { |el| el =~ %r|^d1/d\d/| && el =~ %r|q\d$|}
          assert_equal(smap(exp).sort,smap(ans).sort)
        end

        begin
          ans = []
          rio('d1').dirs.each { |dir|
            dir.all.files(/1/).each { |ent| 
              ans << ent 
            }
          }
          exp = ds.select { |el| el =~ %r|^d1/d\d/| && el =~ %r|q1$|}
          assert_equal(smap(exp).sort,smap(ans).sort)
        end

      end
    end
  end

  def test_qae_fs_all
    ds = ['d0/d1','d0/d2','d0/q1','d0/q2','d0/d1/d2','d0/d1/d2/d1','d0/d1/d2/q1','d0/d1/d2/d1/q1','d0/d1/d2/d1/q2']
    rio('qp/qae').chdir do
      begin
        begin
          ans = []
          rio('d0').all.each { |el| ans << el }
          exp = ds.dup
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end

      begin
        begin
          ans = []
          rio('d0').all.files.dirs.each { |el| ans << el }
          exp = ds.select { |el| el =~ /[qd]\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').all.files(/1/).dirs.each { |el| ans << el }
          exp = ds.select { |el| el =~ /(d\d|q1)$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').all.files.dirs(/1/).each { |el| ans << el }
          exp = ds.select { |el| el =~ /(q\d|d1)$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').all.files(/1/).dirs(/1/).each { |el| ans << el }
          exp = ds.select { |el| el =~ /[qd]1$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end

      begin
        begin
          ans = []
          rio('d0').all.files.each { |el| ans << el }
          exp = ds.select { |el| el =~ /q\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').all.files(/1/).each { |el| ans << el }
          exp = ds.select { |el| el =~ /q1$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').all.files('*1').each { |el| ans << el }
          exp = ds.select { |el| el =~ /q1$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end

      begin
        begin
          ans = []
          rio('d0').all.dirs.each { |el| ans << el }
          exp = ds.reject { |el| el =~ /q\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ans = []
          rio('d0').all.dirs(/1/).each { |el| ans << el }
          exp = ds.select { |el| el =~ /d1$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ans = []
          rio('d0').all.dirs('*1').each { |el| ans << el }
          exp = ds.select { |el| el =~ /d1$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
    end
  end
  def test_qae_fs
    rio('qp/qae').chdir do
      begin
        begin
          ans = []
          rio('d0').each { |el| ans << el }
          exp = ['d0/d1','d0/d2','d0/q1','d0/q2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
      
      
      begin
        begin
          ans = []
          rio('d0').files.each { |el| ans << el }
          exp = ['d0/q1','d0/q2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').files(/1/).each { |el| ans << el }
          exp = ['d0/q1']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').files('*1').each { |el| ans << el }
          exp = ['d0/q1']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
      
      begin
        begin
          ans = []
          rio('d0').dirs.each { |el| ans << el }
          exp = ['d0/d1','d0/d2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').dirs(/1/).each { |el| ans << el }
          exp = ['d0/d1']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').dirs('*1').each { |el| ans << el }
          exp = ['d0/d1']
          assert_equal(exp.sort,smap(ans).sort)
        end
      end
      begin
        begin
          ans = []
          rio('d0').files.dirs.each { |el| ans << el }
          exp = ['d0/d1','d0/d2','d0/q1','d0/q2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').files(/1/).dirs.each { |el| ans << el }
          exp = ['d0/d1','d0/d2','d0/q1']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').files.dirs(/1/).each { |el| ans << el }
          exp = ['d0/d1','d0/q1','d0/q2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').files(/1/).dirs(/1/).each { |el| ans << el }
          exp = ['d0/d1','d0/q1']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
    end
  end
end
