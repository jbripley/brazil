#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

class TC_RIO_eq < Test::Unit::TestCase
  def assert_case_equal(q,p,msg=nil)
    begin
      assert_block { 
        q === p
      }
    rescue Test::Unit::AssertionFailedError => e
      raise e.exception("#{q.inspect}\n ===\n#{p.inspect}")
    end
  end
  def assert_eq(q,p,msg=nil)
    begin
      assert_block { 
        q == p
      }
    rescue Test::Unit::AssertionFailedError => e
      raise e.exception("#{q.inspect}\n ==\n(#{p.inspect})")
    end
  end
  def assert_eql(q,p,msg=nil)
    begin
      assert_block { 
        q.eql?(p)
      }
    rescue Test::Unit::AssertionFailedError => e
      raise e.exception("#{q.inspect}\n.eql?\n(#{p.inspect})")
    end
  end
  def assert_not_eql(q,p,msg=nil)
    begin
      assert_block { 
        !q.eql?(p)
      }
    rescue Test::Unit::AssertionFailedError => e
      raise e.exception("#{q.inspect}\n NOT eql?\n(#{p.inspect})")
    end
  end
  def all_eq(q1,q2)
    q = rio(q1)
    z = rio(q2)

    assert_eq(q,z)
    assert_case_equal(q,z,"===")
    assert_case_equal(q,q2,"===")
  end
  
  def test_eq
    s_dir = ''
    #$trace_states = true
    rio(%w/qp eq/).rmtree.mkpath.chdir do
      q1 = 'q'
      q2 = 'q'
      all_eq(q1,q2)
      #$trace_states = true
      all_eq(?-,'stdio:')
      
      
      dir = rio('dir')
      all_eq(rio('dir'),dir)
      all_eq(dir,rio('dir'))
      all_eq(rio('dir'),'dir')
      all_eq(dir,'dir')

#       p rio('dir') == 'dir'

#       f = ::File.open('dir/f1')
#       p rio(f).to_s
#       r2 = rio(?_,f)
#       p dir.to_s,dir.to_rl
#       p rio(f) == r2

#       p rio(?-).to_s
#       p rio(?-).to_rl
#       p rio(??).to_s
#       p rio(??,'rio','/tmp').to_s
#       p rio(?$).to_s
#       p rio(?=).to_s
#       p rio('tcp://localhost:systime').to_s
#       p rio('rio:tcp://:systime').to_s
#       p rio('rio:tcp://:systime').rl.rl
#       p rio('http://ruby-doc.org/').to_s
#       require 'uri'
#       u = URI('http://ruby-doc.org/')
#       p rio(u).to_s
#       p rio(u).rl.rl
#       p rio('file:///tmp/zippy.tmp').to_s
#       p rio('file:///tmp/zippy.tmp').rl.rl
#       p rio('./-').to_s
#       p rio('-').to_s
    end
  end
end
