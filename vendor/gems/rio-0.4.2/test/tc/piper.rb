#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'rio/piper'

class TC_piper < Test::RIO::TestCase
  @@once = false
  @@dname = 'd'
  @@fnames = ['f0','f1','f2','g0','g1']

  require 'tc/programs_util'
  include Test::RIO::Programs

  def self.once
    @@once = true
    rio(@@dname).rmtree.mkpath.chdir {
      @@fnames.each { |fn|
        make_lines_file(2,fn)
      }
    }
  end
  def setup
    super
    self.class.once unless @@once
  end

  def checkit(exp,*args)
    args.push(out = rio(?").chomp)
    rp = RIO::Piper::Base.new(*args)
    rp.run
    assert_equal(exp,out[])
    rp = RIO::Piper::Base.new(*args)
    rp.run
    assert_equal(exp,out[])
    rp.run
    assert_equal(exp,out[])
  end

  def test_cmd_out
    ls = rio(?-,PROG['list_dir'])
    checkit([@@dname],ls)
  end

  def test_cmd_out2
    ls = rio(?-,PROG['list_dir']+' d')
    checkit(@@fnames,ls)
  end

  def test_cmd_cmd_out
    ls = rio(?-,PROG['list_dir']+' d')
    grep = rio(?-,PROG['find_lines']+' 1').w!
    checkit(@@fnames.select { |s| s =~ /1/ },ls,grep)
  end

  def test_cmd_cmd_cmd_out
    ls = rio(?-,PROG['list_dir']+' d')
    grep = rio(?-,PROG['find_lines']+' 1').w!
    grep2 = rio(?-,PROG['find_lines']+' g').w!
    checkit(@@fnames.select { |s| s =~ /g1/ },ls,grep,grep2)
  end

  def test_cmd_cmd_cmd_cmd_out
    ls = rio(?-,PROG['list_dir']+' d')
    grep = rio(?-,PROG['find_lines']+' 1').w!
    grep2 = rio(?-,PROG['find_lines']+' g').w!
    wc = rio(?-,PROG['count_lines']).w!

    checkit(["1"],ls,grep,grep2,wc)
  end
  def test_piper_out
    ls = rio(?-,PROG['list_dir']+' d')
    grep = rio(?-,PROG['find_lines']+' 1').w!
    rp1 = RIO::Piper::Base.new(ls,grep)
    checkit(@@fnames.select { |s| s =~ /1/ },rp1)
  end

  def test_piper_cmd_out
    ls = rio(?-,PROG['list_dir']+' d')
    grep = rio(?-,PROG['find_lines']+' 1').w!
    rp1 = RIO::Piper::Base.new(ls,grep)
    grep2 = rio(?-,PROG['find_lines']+' g').w!
    checkit(@@fnames.select { |s| s =~ /g1/ },rp1,grep2)
  end

  def test_cmd_piper_out
    ls = rio(?-,PROG['list_dir']+' d')
    grep = rio(?-,PROG['find_lines']+' 1').w!
    grep2 = rio(?-,PROG['find_lines']+' g').w!
    rp1 = RIO::Piper::Base.new(grep,grep2)
    checkit(@@fnames.select { |s| s =~ /g1/ },ls,rp1)
  end

  def test_piper_piper_out
    ls = rio(?-,PROG['list_dir']+' d')
    grep = rio(?-,PROG['find_lines']+' 1').w!
    grep2 = rio(?-,PROG['find_lines']+' g').w!
    wc = rio(?-,PROG['count_lines']).w!
    rp1 = RIO::Piper::Base.new(ls,grep)
    rp2 = RIO::Piper::Base.new(grep2,wc)
    checkit(["1"],rp1,rp2)
  end

  def test_file_out
    f = rio('d/f2')
    checkit(rio('d/f2').chomp[],f)
  end

  def test_file_cmd_out
    f = rio('d/f2')
    grep = rio(?-,PROG['find_lines']+' 2').w!
    checkit(rio('d/f2').chomp[/2/],f,grep)
  end

  def test_file_cmd_cmd_out
    f = rio('d/f2')
    grep = rio(?-,PROG['find_lines']+' 2').w!
    grep2 = rio(?-,PROG['find_lines']+' 0').w!
    checkit(rio('d/f2').chomp[/0/],f,grep,grep2)
  end

  def test_file_cmd_cmd_cmd_out
    f = rio('d/f2')
    grep = rio(?-,PROG['find_lines']+' 2').w!
    grep2 = rio(?-,PROG['find_lines']+' 0').w!
    wc = rio(?-,PROG['count_lines']).w!
    checkit(["1"],f,grep,grep2,wc)
  end


  def test_file_piper_out
    f = rio('d/f2')
    grep = rio(?-,PROG['find_lines']+' 2').w!
    grep2 = rio(?-,PROG['find_lines']+' 0').w!
    rp1 = RIO::Piper::Base.new(grep,grep2)
    checkit(rio('d/f2').chomp[/0/],f,rp1)
  end

end
