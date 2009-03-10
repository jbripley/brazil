#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

if ENV['TEST_RIO'] == 'gem'
  require 'rubygems'
  require_gem 'rio'
else
  require 'rio'
end

require 'tc/testcase'

class TC_dir_iter < Test::RIO::TestCase
  @@once = false
  @@exp = {}
  def self.once
    @@once = true
    (0..3).each { |n_ents|
      d = rio('d'+n_ents.to_s).delete!.mkdir
      @@exp[d.to_s] = []
      d.chdir { |dir|
        (0...n_ents).each { |fnum|
          @@exp[d.to_s] << rio('f'+fnum.to_s).touch
        }
      }
    }
  end
  def setup
    super
    self.class.once unless @@once
  end
  def otest_dir
    (1..1).each do |n_ents|
      get_each_dir(n_ents)
    end
  end
  def doem(&block)
    rio('.').each { |d|
      ma = /d(\d)/.match(d.to_s)
      n_ents = ma[1].to_i
      exp = @@exp[d.to_s]
      d.chdir { |dir|
        yield(dir,n_ents,exp)
      }
    }
  end
  def test_ss
    doem { |d,n,exp|
      ans = d[]
      assert_array_equal(exp,ans)
    }
  end
  def test_each
    doem { |d,n,exp|
      ans = []
      d.each { |e| ans << e }
      assert_array_equal(exp,ans)
    }
  end
  def test_read
    doem { |d,n,exp|
      ans = []
      while e = d.read
        ans << e
      end
      ans.reject! { |el| el =~ /^\.{1,2}$/ }
      assert_array_equal(exp,ans)
    }
  end
  def test_each_get_break
    doem { |d,n,exp|
      ans = []
      d.each { |e| 
        ans << e 
        break
      }
      assert_array_equal(exp[0..0],ans)
      ent = d.get
      assert_equal(exp[1],ent)
      ent2 = d.get
      if ent.nil?
        assert_equal(exp[0],ent2)
      else
        assert_equal(exp[2],ent2)
      end
    }
  end
  def test_each_get
    doem { |d,n,exp|
      ans = []
      d.each { |e| 
        ans << e 
      }
      assert_array_equal(exp,ans)
      ent = d.get
      assert_equal(exp[0],ent)
    }
  end
  def test_each_get_nceof
    doem { |d,n,exp|
      ans = []
      d.nocloseoneof.each { |e| 
        ans << e 
        break
      }
      assert_array_equal(exp[0..0],ans)
      ent = d.get
      assert_equal(exp[1],ent)
      ent2 = d.get
      assert_equal(exp[2],ent2)
    }
  end
  def test_each_get_nac
    doem { |d,n,exp|
      ans = []
      d.noautoclose.each { |e| 
        ans << e 
        break
      }
      assert_array_equal(exp[0..0],ans)
      ent = d.get
      assert_equal(exp[1],ent)
      ent2 = d.get
      assert_equal(exp[2],ent2)
    }
  end
  def test_get_get
    doem { |d,n,exp|
      ans = []
      while e = d.get
        ans << e
      end
      while e = d.get
        ans << e
      end
      assert_array_equal(exp+exp,ans)
    }
  end
  def test_get_get_nac
    doem { |d,n,exp|
      ans = []
      d.noautoclose
      while e = d.get
        ans << e
      end
      while e = d.get
        ans << e
      end
      assert_array_equal(exp,ans)
    }
  end
  def test_each_each
    doem { |d,n,exp|
      ans = []
      d.each { |e| 
        ans << e 
      }
      d.each { |e|
        ans << e
      }
      assert_array_equal(exp+exp,ans)
    }
  end
  def test_each_each_nac
    doem { |d,n,exp|
      ans = []
      d.noautoclose.each { |e| 
        ans << e 
      }
      d.each { |e|
        ans << e
      }
      assert_array_equal(exp,ans)
    }
  end
  def test_get
    doem { |d,n,exp|
      ans = []
      while e = d.get
        ans << e
      end
      assert_array_equal(exp,ans)
    }
  end
  def test_get_select
    doem { |d,n,exp|
      ans = []
      d.entries(/1/)
      while e = d.get
        ans << e
      end
      exp = exp.select { |el| el =~ /1/ }
      assert_array_equal(exp,ans)
    }
  end
  def test_get_skip
    doem { |d,n,exp|
      ans = []
      d.skip(/1/)
      while e = d.get
        ans << e
      end
      exp = exp.reject { |el| el =~ /1/ }
      assert_array_equal(exp,ans)
    }
  end
  def test_get_skip_files
    doem { |d,n,exp|
      ans = []
      d.skip.files(/1/)
      while e = d.get
        ans << e
      end
      exp = exp.reject { |el| el =~ /1/ }
      assert_array_equal(exp,ans)
    }
  end
  def test_get_skipfiles
    doem { |d,n,exp|
      ans = []
      d.skipfiles(/1/)
      while e = d.get
        ans << e
      end
      exp = exp.reject { |el| el =~ /1/ }
      assert_array_equal(exp,ans)
    }
  end
  def get_each_dir(n_ents)
    expa = []
    d = rio('dir').delete!.mkdir
    (0..n_ents-1).each { |n| 
      expa << (d/'f'+n.to_s).touch
    }
    
    d = rio('dir')
    assert_array_equal(expa,d[])

    begin
      d = rio('dir')
      ans = []
      d.each { |ent| ans << ent }
      assert_equal(expa,ans)
    end
    begin
      d = rio('dir')
      ans = []
      while ent = d.get
        ans << rec
      end
      assert_equal(expa,ans)
    end
    begin
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
    end

    #  $trace_states = true

    # iterate twice using #get (no auto close)
    begin
      f = rio('f.txt').nocloseoneof
      ans = []
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
    end

    # iterate using #get then using #each (no auto close)
    begin
      f = rio('f.txt').nocloseoneof
      ans = []
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)
    end
    
    # iterate using #each then using #get (no auto close)
    begin
      f = rio('f.txt').nocloseoneof
      ans = []
      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
    end
    
    # iterate twice using #get (with auto close)
    begin
      f = rio('f.txt')
      ans = []
      while rec = f.get
        ans << rec
      end
      assert_equal(expa,ans)
      while rec = f.get
        ans << rec
      end
      assert_equal(expa+expa,ans)
    end
    
    # assure get returns nil once after iteration using #get (with auto close)
    begin
      f = rio('f.txt')
      ans = []

      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)

      rec = f.get
      assert_nil(rec)

      rec = f.get
      assert_equal(expa[0],rec)
    end

    begin
      f = rio('f.txt')
      ans = []

      rec = f.get
      assert_equal(expa[0],rec)
      ans << rec unless rec.nil?
      f.each do |rec|
        ans << rec
      end
      rec = f.get
      assert_nil(rec)
    end

    begin
      f = rio('f.txt')
      ans = []

      (0...n_lines).each do |n|
        rec = f.get
        assert_equal(expa[n],rec)
      end
      rec = f.get
      assert_nil(rec)

      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)
    end

    begin
      f = rio('f.txt')
      ans = []

      (0...n_lines).each do |n|
        rec = f.get
        assert_equal(expa[n],rec)
      end
      f.each do |rec|
        ans << rec
      end
      assert_equal(expa,ans)
    end
  end
end
