#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_each_break < Test::Unit::TestCase
  @@once = false
  include RIO_TestCase
  def self.once
    return if @@once
    @@once = true
    rio('dir').rmtree.mkdir.chdir do
      %w[d1 d2].each { |dname| rio(dname).delete!.mkdir }
      Util::make_lines_file(1,'f1')
      Util::make_lines_file(2,'f2')
      Util::make_lines_file(3,'f3')
      Util::make_lines_file(1,'d1','f1')
      Util::make_lines_file(1,'d2','f1')
      Util::make_lines_file(2,'d2','f2')
    end
  end
  def setup()
    super
    self.class.once unless @@once
    @dir = rio('dir')
    @f1 = rio(@dir,'f1')
    @f2 = rio(@dir,'f2')
    @f3 = rio(@dir,'f3')
    @l1 = @f1.readlines
    @l2 = @f2.readlines
    @l3 = @f3.readlines
    @d1 = rio(@dir,'d1')
    @d2 = rio(@dir,'d2')
    @e1 = %w[d1/f1].map { |ent| rio(@dir,ent) }
    @e2 = %w[d2/f1 d2/f2].map { |ent| rio(@dir,ent) }
    @files = [@f1,@f2,@f3]
    @dirs = [@d1,@d2]
    @ents = @dirs + @files
  end
  def test_nobreak_dir
    ans = []
    @d1.each { |ent| ans << ent }
    assert(@d1.closed?)
    assert_equal(@e1,ans)

    ans = []
    @d2.each { |ent| ans << ent }
    assert(@d2.closed?)
    assert_equal(@e2,ans)

  end

  def test_nobreak_dir_sel
    ans = []
    @dir.entries.each { |ent| ans << ent }
    assert_array_equal(@ents ,ans)

    ans = []
    @dir.files.each { |ent| ans << ent }
    assert_array_equal(@files,ans)

    ans = []
    @dir.dirs.each { |ent| ans << ent }
    assert_array_equal(@dirs,ans)

  end
  def test_dir_sel
    ans = []
    @dir.entries.each { |ent| ans << ent; break }
    assert_array_equal(@ents[0..0],ans)

    ans = []
    @dir.files.each { |ent| ans << ent; break }
    assert_array_equal(@ents[1..1],ans)

    ans = []
    @dir.dirs.each { |ent| ans << ent; break }
    assert_array_equal(@ents[2..2],ans)
    
    @dir.close
    assert(@dir.closed?)

    ans = []
    @dir.dirs.each { |ent| ans << ent; break }
    assert_array_equal(@dirs[0..0],ans)
    
    ans = []
    @dir.files.each { |ent| ans << ent; break }
    assert_array_equal(@ents[1..1],ans)

    ans = []
    @dir.entries.each { |ent| ans << ent; break }
    assert_array_equal(@ents[2..2],ans)

    @dir.close
    assert(@dir.closed?)

    ans = []
    @dir.files.each { |ent| ans << ent; break }
    assert_array_equal(@files[0..0],ans)

    ans = []
    @dir.dirs.each { |ent| ans << ent; break }
    assert_array_equal(@files[1..1],ans)

    ans = []
    @dir.entries.each { |ent| ans << ent; break }
    assert_array_equal(@files[2..2],ans)

    ans = []
    @dir.entries.each { |ent| ans << ent; break }
    assert_array_equal([],ans)

  end
  def test_dir_oneentry
    ans = []
    @d1.each { |ent| ans << ent; break }
    assert(@d1.open?)
    assert_equal(@e1[0..0],ans)

    ans = []
    @d2.each { |ent| ans << ent; break }
    assert(@d2.open?)
    assert_equal(@e2[0..0],ans)

  end
  def test_dir_readmore
    ans = []
    ### LOOK INTO THIS
    ### Something changed in ruby 1.8.3
    ### See the file q/dir_readmore.q for a simple example
    dir1 = rio(@d1)
    dir1.each { |ent| 
      ans << ent; 
      break 
    }
    assert(dir1.open?)
    assert_equal(@e1[0..0],ans)

    ans = []
    #$trace_states = true
    dir1.each { |ent| ans << ent; break }
    assert(dir1.closed?)
    assert_equal([],ans)

    dir2 = rio(@d2)

    ans = []
    dir2.each { |ent| ans << ent; break }
    assert(dir2.open?)
    assert_equal(@e2[0..0],ans)

    ans = []
    dir2.each { |ent| ans << ent; break }
    assert(dir2.open?)
    assert_equal(@e2[1..1],ans)

    ans = []
    dir2.each { |ent| ans << ent; break }
    assert(dir2.closed?)
    assert_equal([],ans)

  end
  def test_nobreak_lines
    ans = []
    @f1.each { |line| ans << line }
    assert(@f1.closed?)
    assert_equal(@l1,ans)

    ans = []
    @f2.each { |line| ans << line }
    assert(@f2.closed?)
    assert_equal(@l2,ans)

    ans = []
    @f3.each { |line| ans << line }
    assert(@f3.closed?)
    assert_equal(@l3,ans)

  end
  def test_lines_oneline
    ans = []
    @f1.each { |line| ans << line; break }
    assert_equal(@l1[0..0],ans)
    assert(@f1.eof?)
    assert(@f1.open?)

    ans = []
    @f2.each { |line| ans << line; break }
    assert_equal(@l2[0..0],ans)
    assert!(@f2.eof?)
    assert(@f2.open?)

    ans = []
    @f3.each { |line| ans << line; break }
    assert_equal(@l3[0..0],ans)
    assert!(@f3.eof?)
    assert(@f3.open?)

  end
  def test_lines_threelines
    ans = []
    @f1.each { |line| ans << line; break }
    assert_equal(@l1[0..0],ans)
    assert(@f1.eof?)
    assert(@f1.open?)

    ans = []
    @f1.each { |line| ans << line; break }
    assert(@f1.eof?,"read 2 at eof")
    assert(@f1.closed?,"read 2 causes close")
    assert_equal([],ans)

    ans = []
    @f1.each { |line| ans << line; break }
    assert(@f1.eof?,"read 3 at eof")
    assert(@f1.open?,"read 3 leaves file open")
    assert_equal(@l1[0..0],ans)

    ans = []
    @f2.each { |line| ans << line; break }
    assert_equal(@l2[0..0],ans)
    assert!(@f2.eof?)
    assert(@f2.open?)

    ans = []
    @f2.each { |line| ans << line; break }
    assert(@f2.eof?,"read 2 at eof")
    assert(@f2.open?,"read 2 does not close close")
    assert_equal(@l2[1..1],ans)

    ans = []
    @f2.each { |line| ans << line; break }
    assert(@f2.eof?,"read 3 at eof")
    assert(@f2.closed?,"read 3 closes")
    assert_equal([],ans)

  end
end
