#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
class TC_RIO_noqae < Test::Unit::TestCase
  @@tdir = rio(%w/qp noqae/)
  @@once = false
  def initialize(*args)
    super
  end
    
  def assert!(a,msg="negative assertion")
    assert((!(a)),msg)
  end
  def smap(a) a.map{|el| el.to_s} end
  def setup
    s_dir = ''
    #$trace_states = true
    unless @@once
      @@once =  true

      @@tdir.rmtree.mkpath.chdir do
        rio('d0').mkpath.chdir {
          rio('d2').mkpath
          rio('d1').mkpath.chdir {
            rio('d2').mkpath.chdir {
              rio('d1').mkpath.chdir {
                rio('f1') < (0..1).map { |i| "L#{i}:d0/d1/d2/d1/f1\n" }
                rio('f2') < (0..1).map { |i| "L#{i}:d0/d1/d2/d1/f2\n" }
              }
              rio('f1') < (0..1).map { |i| "L#{i}:d0/d1/d2/f1\n" }
            }
          }
          rio('f1') < (0..1).map { |i| "L#{i}:d0/f1\n" }
          rio('f2') < (0..1).map { |i| "L#{i}:d0/f2\n" }
          if $supports_symlink
            rio('x1').symlink('n1')
            rio('x2').symlink('n2')
            rio('f1').symlink('l1')
            rio('f2').symlink('l2')
            rio('d1').symlink('c1')
            rio('d2').symlink('c2')
          else
            rio('f1') > rio('l1')
            rio('f2') > rio('l2')
            rio('d1') > rio('c1')
            rio('d2') > rio('c2')
          end
        }

        rio('d1').mkpath.chdir {
          rio('d1').mkpath.chdir {
            rio('f1') < (0..1).map { |i| "L#{i}:d1/d1/f1\n" }
            rio('f2') < (0..1).map { |i| "L#{i}:d1/d1/f2\n" }
          }
          rio('d2').mkpath.chdir {
            rio('d1').mkpath.chdir {
              rio('f1') < (0..1).map { |i| "L#{i}:d1/d2/d1/f1\n" }
              rio('f2') < (0..1).map { |i| "L#{i}:d1/d2/d1/f2\n" }
            }
            rio('d2').mkpath
          }
          rio('d3').mkpath.chdir {
            rio('d1').mkpath.chdir {
              rio('f1') < (0..1).map { |i| "L#{i}:d1/d3/d1/f1\n" }
              rio('d1').mkpath
            }
            rio('f1') < (0..1).map { |i| "L#{i}:d1/d3/f1\n" }
          }
        }

      end
    end
  end
  def all()
    all = ['d0/d1','d0/d2','d0/c1','d0/c2','d0/f1','d0/f2','d0/l1','d0/l2']
    all += ['d0/n1','d0/n2'] if $supports_symlink
    all
  end
  def test_noqae_fs
    rio('qp/noqae').chdir do
      begin

        begin
          ans = []
          rio('d0').each { |el| ans << el }
          exp = all.dup
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').to_a
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').entries[]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
      
      begin
        begin
          ans = []
          rio('d0').skipdirs.each { |el| ans << el }
          exp = all.reject { |el| el =~ /[cd]\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipdirs[]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').skipfiles.each { |el| ans << el }
          exp = all.reject { |el| el =~ /[fl]\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipfiles[]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ans = []
          rio('d0').skipentries.each { |el| ans << el }
          exp = []
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipentries[]
          assert_equal(exp.sort,smap(ans).sort)
        end
      end

      begin
        begin
          ans = []
          rio('d0').skipdirs.skipfiles.each { |el| ans << el }
          exp = all.reject { |el| el =~ /[cdfl]\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipfiles.skipdirs[]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipdirs.skipfiles[]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').skipdirs.files.each { |el| ans << el }
          exp = all.select { |el| el =~ /[fl]\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipdirs.files[]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').files.skipdirs[]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          exp = all.select { |el| el =~ /[n]\d$/ }
          ans = []
          rio('d0').entries.skipfiles.skipdirs.each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)

          ans = rio('d0').entries.skipfiles.skipdirs[]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').entries.skipdirs.skipfiles[]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipfiles.skipdirs.entries[]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipfiles.skipdirs[]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          exp = []
          ans = []
          rio('d0').skipentries.dirs.each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          rio('d0').skipentries.files.each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)

          ans = rio('d0').skipentries.files[]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipentries.dirs[]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          exp = []
          ans = []
          rio('d0').skipentries.each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipentries[]
          assert_equal(exp.sort,smap(ans).sort)
        end
      end
    end
  end

  def test_noqae_fs_de
    @@tdir.abs.chdir do
      begin
        begin
          ans = []
          rio('d0').dirs.each { |el| 
            assert(el.directory?)
          }
          rio('d0').skipdirs.each { |el| 
            assert!(el.directory?)
          }
          rio('d0').skipdirs('*').each { |el| 
            assert(el.directory?)
          }
          rio('d0').files.each { |el| 
            assert(el.file?)
          }
          rio('d0').skipfiles.each { |el| 
            assert!(el.file?)
          }
          rio('d0').skipfiles('*').each { |el| 
            assert(el.file?)
          }
          return unless $supports_symlink
          begin
            exp = all.select { |el| el =~ /[lnc]\d\Z/ }
            ans = []
            rio('d0').entries(:symlink?).each { |el| 
              assert(el.symlink?)
              ans << el
            }
            assert_equal(exp.sort,smap(ans).sort)
          end
          begin
            exp = all.select { |el| el =~ /[l]\d\Z/ }
            ans = []
            rio('d0').files(:symlink?).each { |el| 
              assert(el.file?)
              assert(el.symlink?)
              ans << el
            }
            assert_equal(exp.sort,smap(ans).sort)
          end
          begin
            exp = all.select { |el| el =~ /[c]\d\Z/ }
            ans = []
            rio('d0').dirs(:symlink?).each { |el| 
              assert(el.directory?)
              assert(el.symlink?)
              ans << el
            }
            assert_equal(exp.sort,smap(ans).sort)
          end
          begin
            exp = all.select { |el| el =~ /[df]\d\Z/ }
            ans = []
            rio('d0').skipentries(:symlink?).each { |el| 
              assert!(el.symlink?)
              ans << el
            }
            assert_equal(exp.sort,smap(ans).sort)
          end
          begin
            exp = all.select { |el| el =~ /[d]\d\Z/ }
            ans = []
            rio('d0').skipdirs(:symlink?).each { |el| 
              assert(el.directory?)
              assert!(el.symlink?)
              ans << el
            }
            assert_equal(exp.sort,smap(ans).sort)
          end
          begin
            exp = all.select { |el| el =~ /[f]\d\Z/ }
            ans = []
            rio('d0').skipfiles(:symlink?).each { |el| 
              assert(el.file?)
              assert!(el.symlink?)
              ans << el
            }
            assert_equal(exp.sort,smap(ans).sort)
          end
        end
      end
    end
      #rio(wd).chdir
  end
  def test_noqae_fs_re
    
    @@tdir.abs.chdir do
      begin

        begin
          ere = /1/
          exp = all.reject { |el| el =~ ere }
          ans = []
          rio('d0').skipentries(ere).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipentries(ere).to_a
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipentries[ere]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
      
      begin
        begin
          dre = /1/
          exp = all.select { |el| el =~ /[cd]2$/ }
          ans = []
          rio('d0').skipdirs(dre).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipdirs[dre]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          dre = /1/
          exp = all.select { |el| el =~ /[d]2$/ }
          ans = []
          if $supports_symlink
            rio('d0').skipdirs(dre,:symlink?).each { |el| ans << el }
            assert_equal(exp.sort,smap(ans).sort)
            ans = rio('d0').skipdirs[dre,:symlink?]
            assert_equal(exp.sort,smap(ans).sort)
          end
        end
        
        begin
          fre = /2/
          exp = all.select { |el| el =~ /[fl]1$/ }
          ans = []
          rio('d0').skipfiles(fre).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipfiles[fre]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ere = /1/
          exp = all.select { |el| el =~ /2$/ }
          ans = []
          rio('d0').skipentries(ere).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipentries[ere]
          assert_equal(exp.sort,smap(ans).sort)
        end
      end

      begin
        dre = /1/
        fre = /2/
        begin
          exp = all.select { |el| el =~ /([cd]2|[fl]1)$/ }
          ans = []
          rio('d0').skipdirs(dre).skipfiles(fre).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipfiles(fre).skipdirs[dre]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipdirs(dre).skipfiles[fre]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          exp = all.select { |el| el =~ /([cd]2|[fl]2)$/ }
          ans = []
          rio('d0').skipdirs(dre).files(fre).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipdirs(dre).files[fre]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').files(fre).skipdirs[dre]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          exp = all.select { |el| el =~ /([cd]2|[fl]1|n[12])$/ }
          ans = []
          rio('d0').entries.skipfiles(fre).skipdirs(dre).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)

          ans = rio('d0').entries.skipfiles(fre).skipdirs[dre]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').entries.skipdirs(dre).skipfiles[fre]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipfiles(fre).skipdirs(dre).entries[]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ere = /1/
          exp = all.select { |el| el =~ /([cd]2|[fl]1|n1)$/ }
          ans = []
          rio('d0').entries(ere).skipfiles(fre).skipdirs(dre).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)

          ans = rio('d0').entries(ere).skipfiles(fre).skipdirs[dre]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').entries(ere).skipdirs(dre).skipfiles[fre]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipfiles(fre).skipdirs(dre).entries[ere]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ere = /1/
          dre = /c/
          fre = /f/
          exp = all.select { |el| el =~ /(d2|l2)$/ }
          ans = []
          rio('d0').skipentries(ere).skipfiles(fre).skipdirs(dre).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)

          ans = rio('d0').skipentries(ere).skipfiles(fre).skipdirs[dre]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipentries(ere).skipdirs(dre).skipfiles[fre]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipfiles(fre).skipdirs(dre).skipentries[ere]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          exp = []
          ans = []
          rio('d0').skipentries.dirs.each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          rio('d0').skipentries.files.each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)

          ans = rio('d0').skipentries.files[]
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipentries.dirs[]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ere = /1/
          exp = all.select { |el| el =~ /2$/ }
          ans = []
          rio('d0').skipentries(ere).each { |el| ans << el }
          assert_equal(exp.sort,smap(ans).sort)
          ans = rio('d0').skipentries[ere]
          assert_equal(exp.sort,smap(ans).sort)
        end
      end
    end
  end

  def ztest_noqae_fs_re
    all = ['d0/d1','d0/d2','d0/c1','d0/c2','d0/f1','d0/f2','d0/n1','d0/n2','d0/l1','d0/l2']
    rio('qp/noqae').chdir do
      begin
        begin
          ans = []
          rio('d0').skipfiles(/2/).each { |el| ans << el }
          exp = all.reject { |el| el =~ /[fl]\d$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').skipfiles('*2').each { |el| ans << el }
          exp = ['d0/f1']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
      
      begin
        begin
          ans = []
          rio('d0').skipfiles.each { |el| ans << el }
          exp = ['d0/d1','d0/d2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').skipdirs(/2/).each { |el| ans << el }
          exp = ['d0/d1']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').skipdirs('*2').each { |el| ans << el }
          exp = ['d0/d1']
          assert_equal(exp.sort,smap(ans).sort)
        end
      end
      begin
        begin
          ans = []
          rio('d0').skipfiles.dirs.each { |el| ans << el }
          exp = ['d0/d1','d0/d2','d0/f1','d0/f2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        begin
          ans = []
          rio('d0').skipfiles.dirs.each { |el| ans << el }
          exp = ['d0/d1','d0/d2','d0/f1','d0/f2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        begin
          ans = []
          rio('d0').skipfiles.dirs.each { |el| ans << el }
          exp = ['d0/d1','d0/d2','d0/f1','d0/f2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        begin
          ans = []
          rio('d0').skipfiles.dirs.each { |el| ans << el }
          exp = ['d0/d1','d0/d2','d0/f1','d0/f2']
          assert_equal(exp.sort,smap(ans).sort)
        end
      end

        
      begin
        begin
          ans = []
          rio('d0').files(/1/).dirs.each { |el| ans << el }
          exp = ['d0/d1','d0/d2','d0/f1']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').files.dirs(/1/).each { |el| ans << el }
          exp = ['d0/d1','d0/f1','d0/f2']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').files(/1/).dirs(/1/).each { |el| ans << el }
          exp = ['d0/d1','d0/f1']
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
    end
  end
  def ztest_noqae_fs_lines 
    rio('qp/noqae').chdir do
      begin
        begin
          ans = []
          rio('d0').files.each { |f|
            f.each { |el|
              ans << el 
            }
          }
          exp = ["L0:d0/f1\n","L1:d0/f1\n","L0:d0/f2\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ans = []
          rio('d0').files.lines.each { |el| ans << el }
          exp = ["L0:d0/f1\n","L1:d0/f1\n","L0:d0/f2\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').lines.files.each { |el| ans << el }
          exp = ["L0:d0/f1\n","L1:d0/f1\n","L0:d0/f2\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').files.lines(/L1/).each { |el| ans << el }
          exp = ["L1:d0/f1\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').lines(/L1/).files.each { |el| ans << el }
          exp = ["L1:d0/f1\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').lines.each { |el| ans << el }
          exp = ["L0:d0/f1\n","L1:d0/f1\n","L0:d0/f2\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').lines(/L1/).each { |el| ans << el }
          exp = ["L1:d0/f1\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
    end
  end

  def ztest_noqae_fs_lines_ss
    rio('qp/noqae').chdir do
      begin
        begin
          ans = []
          rio('d0').files.each { |f|
            f.each { |el|
              ans << el 
            }
          }
          exp = ["L0:d0/f1\n","L1:d0/f1\n","L0:d0/f2\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end

        begin
          ans = rio('d0').files.lines[]
          exp = ["L0:d0/f1\n","L1:d0/f1\n","L0:d0/f2\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').lines.files[]
          exp = ["L0:d0/f1\n","L1:d0/f1\n","L0:d0/f2\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').files.lines[/L1/]
          exp = ["L1:d0/f1\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').lines(/L1/).files[]
          exp = ["L1:d0/f1\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').lines[]
          exp = ["L0:d0/f1\n","L1:d0/f1\n","L0:d0/f2\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = rio('d0').lines[/L1/]
          exp = ["L1:d0/f1\n","L1:d0/f2\n"]
          assert_equal(exp.sort,smap(ans).sort)
        end
        
      end
    end
  end

  def ztest_noqae_chomp 
    rio('qp/noqae').chdir do
      begin
        begin
          ans = []
          rio('d0/f1').each { |el|
            ans << el 
          }
          exp = ["L0:d0/f1\n","L1:d0/f1\n"]
          assert_equal(exp,ans)
        end
        
        begin
          ans = []
          rio('d0/f1').chomp.each { |el|
            ans << el 
          }
          exp = ["L0:d0/f1","L1:d0/f1"]
          assert_equal(exp,ans)
        end
        
      end
    end
  end

  def ztest_noqae_fs_nest
    ds = ['d1/d1','d1/d2','d1/d1/f1','d1/d1/f2','d1/d2/d1','d1/d2/d1/f1','d1/d2/d1/f2','d1/d2/d2',
          'd1/d3','d1/d3/d1','d1/d3/f1','d1/d3/d1/f1','d1/d3/d1/d1']
    rio('qp/noqae').chdir do
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
          exp = ds.select { |el| el =~ %r|^d1/d\d/f1$| }
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
          exp = ds.select { |el| el =~ %r|^d1/d\d/| && el =~ %r|f1$|}
          assert_equal(smap(exp).sort,smap(ans).sort)
        end

      end
    end
  end

  def ztest_noqae_fs_all
    ds = ['d0/d1','d0/d2','d0/f1','d0/f2','d0/d1/d2','d0/d1/d2/d1','d0/d1/d2/f1','d0/d1/d2/d1/f1','d0/d1/d2/d1/f2']
    rio('qp/noqae').chdir do
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
          exp = ds.select { |el| el =~ /(d\d|f1)$/ }
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
          exp = ds.select { |el| el =~ /f1$/ }
          assert_equal(exp.sort,smap(ans).sort)
        end
        
        begin
          ans = []
          rio('d0').all.files('*1').each { |el| ans << el }
          exp = ds.select { |el| el =~ /f1$/ }
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
end
