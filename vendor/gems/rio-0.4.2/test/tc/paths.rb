#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_paths < Test::Unit::TestCase
  def smap(a) a.map { |el| el.to_s } end
  def pmap(a)
    a.sort
  end
  def gmap(io)
    smap(io.to_a).sort
  end

  def test_paths
    s_dir = ''
    tdir = rio(%w/qp test_paths/)
    tdir.rmtree.mkpath.chdir {
      rio(%w/dir0 dir00 dir000/).mkpath
      rio(%w/dir1 dir10 dir000/).mkpath
      rio(%w/dir1 dir10 dir100/).mkpath
      rio(%w/dir1 dir11/).mkpath
      rio(%w/dir1 f0.txt/).touch
      rio(%w/dir1 dir10 f0.txt/).touch
      rio(%w/dir1 dir10 f1.txt/).touch
      rio(%w/dir1 dir10 f2.emp/).touch
      rio(%w/f0.txt/).touch
      rio(%w/dir1 dir10 dir000 f100.txt/).touch
    }

    tdir.chdir  {
      io = rio('dir1')
      exp = %w{ dir1/dir10 dir1/dir11 dir1/f0.txt}
      assert_equal(pmap(exp), gmap(io))
      io = rio('dir1').dirs
      exp = %w{ dir1/dir10 dir1/dir11}
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').files
      exp = %w{ dir1/f0.txt}
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').dirs("*1")
      exp = %w{ dir1/dir11}
      assert_equal(pmap(exp), gmap(io))
      
      io = rio('dir1').glob('**/*.txt')
      exp = %w{dir1/f0.txt dir1/dir10/f0.txt dir1/dir10/f1.txt dir1/dir10/dir000/f100.txt}
      assert_equal(pmap(exp), gmap(io))
      
      rio('dir1').chdir {
        io = rio('dir10').files('*.txt')
        exp = %w{ dir10/f0.txt dir10/f1.txt}
        assert_equal(pmap(exp), gmap(io))

        io = rio('dir10').files('*.txt')
        exp = %w{ dir10/f0.txt dir10/f1.txt}
        assert_equal(pmap(exp), gmap(io))
      }
    }
    tdir.chdir  {
      rio('dir1').chdir {
        io = rio('dir10').files('*.txt')
        exp = %w{ dir10/f0.txt dir10/f1.txt}
        assert_equal(pmap(exp), gmap(io))
        
        io = rio('dir10').glob("**/*.txt")
        exp = %w{ dir10/f0.txt dir10/f1.txt dir10/dir000/f100.txt}
        assert_equal(pmap(exp), gmap(io))
        
        io = rio('dir10').all.files('*.txt')
        exp = %w{ dir10/f0.txt dir10/f1.txt dir10/dir000/f100.txt}
        assert_equal(pmap(exp), gmap(io))

        io = rio('dir10').all.files
        exp = %w{ dir10/f0.txt dir10/f1.txt dir10/f2.emp dir10/dir000/f100.txt}
        assert_equal(pmap(exp), gmap(io))
      }
    }
    tdir.chdir  {
      io = rio('dir1').all.dirs
      exp = %w{ dir1/dir10 dir1/dir10/dir000 dir1/dir11 dir1/dir10/dir100    }
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').all.dirs('*0')
      exp = %w{ dir1/dir10 dir1/dir10/dir100 dir1/dir10/dir000}
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').glob('**/*100*')
      exp = %w{ dir1/dir10/dir100 dir1/dir10/dir000/f100.txt}
      assert_equal(pmap(exp), gmap(io))
    }
    tdir.chdir  {
      io = rio('dir1').all.dirs('*0')
      exp = %w{ dir1/dir10 dir1/dir10/dir100 dir1/dir10/dir000}
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').glob('*1')
      exp = %w{ dir1/dir11 }
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').glob('**/*1')
      exp = %w{ dir1/dir11 }
      assert_equal(pmap(exp), gmap(io))

      $trace_states = true
      io = rio('dir1').recurse('*0')
      exp = %w[dir1/dir10 dir1/dir10/dir000 dir1/dir10/dir100 dir1/dir11 dir1/f0.txt dir1/dir10/f0.txt dir1/dir10/f1.txt
               dir1/dir10/f2.emp dir1/dir10/dir000/f100.txt]
      $trace_states = false
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').recurse('*1')
      exp = %w{ dir1/dir11 dir1/dir10 dir1/f0.txt}
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').recurse('*1').files
      exp = %w{ dir1/f0.txt }
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').recurse('*1').dirs
      exp = %w{ dir1/dir11 dir1/dir10 }
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').recurse('*1').dirs('*1')
      exp = %w{ dir1/dir11 }
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').recurse('*0').files
      exp = %w[dir1/f0.txt dir1/dir10/f0.txt dir1/dir10/f1.txt
               dir1/dir10/f2.emp dir1/dir10/dir000/f100.txt]
      assert_equal(pmap(exp), gmap(io))

      io = rio('dir1').recurse('*0').files(/f\d\..../)
      exp = %w[dir1/f0.txt dir1/dir10/f0.txt dir1/dir10/f1.txt
               dir1/dir10/f2.emp ]
      assert_equal(pmap(exp), gmap(io))

    }
  end
end
