require 'rio'
require 'test/unit'
require 'test/unit/testsuite'



module RIOSupport
  def supports_symlink
    yes = true
    begin
      File.symlink('dummy','ldummy')
      File.delete('ldummy')
    rescue NotImplementedError
      yes = false
    rescue
    end
    yes
  end
  module_function :supports_symlink

end
$supports_symlink = RIOSupport.supports_symlink
$mswin32 = (RUBY_PLATFORM =~ /mswin32/)
module RIO_TestCase 
  module Util
    def make_lines_file(n_lines=8,*args)
      file = rio(*args)
      lines = (0...n_lines).map { |i| "L#{i}:#{file}" + $/ }
      lines.each do |line|
        file.puts(line)
      end
      file.close
      [lines,file]
    end
    module_function :make_lines_file
  end

  T_ROOT = 'qp'
  def _t_dir_from_class()
    self.class.to_s.sub(/^TC_/,'')
  end
  def tdir() 
    rio(T_ROOT,_t_dir_from_class()) 
  end
  def assert!(a,msg="negative assertion")
    assert((!(a)),msg)
  end
  def assert_array_equal(a,b,msg="array same regardless of order")
    assert_equal(smap(a).sort,smap(b).sort,msg)
  end
  def smap(a) a.map { |el| el.to_s } end
  def mkafile(*args)
    file = rio(*args)
    file < (0..1).map { |i| "L#{i}:#{file.to_s}\n" }
    file
  end

  def mklines(n_lines=8)
    (0...n_lines).map { |i| "L#{i}\n" }
  end
  def mkalinesfile(n_lines,*args)
    file = rio(*args)
    file < (0...n_lines).map { |i| "L#{i}:#{file.to_s}\n" }
    file
  end
  def lines_file(n_lines=8,*args)
    Util::make_lines_file(n_lines,*args)
  end
  def file_lines(n_lines=8)
    file = mkalinesfile(n_lines,'f1')
    lines = file[]
    (2..4).each do |n|
      lines[n] = '#' + lines[n]
    end
    (0..3).each do |n|
      lines[n].sub!(/f1/,'f2')
    end
    file < lines
    [file,lines]
  end
  def setup
    #$trace_states = true
    @cwd = ::Dir.getwd
    tdir.mkpath.chdir
  end
  def teardown
    ::Dir.chdir @cwd
  end
end
module Test
  module RIO
    class TestCase < Unit::TestCase
      include RIO_TestCase::Util
      def setup()
        return if self.class == Test::RIO::TestCase
        #p self.class
        @cwd = ::Dir.getwd
        tdir.mkpath.chdir
      end
      def teardown
        return if self.class == Test::RIO::TestCase
        ::Dir.chdir @cwd
      end
      def rios2str(a) a.map { |el| el.to_s } end

      def assert!(a,msg="negative assertion")
        assert((!(a)),msg)
      end

      def smap(a) a.map { |el| el.to_s } end
      def assert_array_equal(a,b,msg="array same regardless of order")
        if a.nil?
          assert_nil(b)
        elsif b.nil?
          assert_nil(a)
        else
          assert_equal(smap(a).sort,smap(b).sort,msg)
        end
      end
      def assert_dirs_equal(exp,d,msg="")
        exp.each do |ent|
          ds = rio(d,ent.filename)
          assert_equal(ent.symlink?,ds.symlink?,"both symlinks, or not")
          unless ent.symlink?
            assert(ds.exist?,"entry '#{ds}' exists")
          end
          assert_equal(ent.ftype,ds.ftype,"same ftype")
          assert_rios_equal(ent,ds,"sub rios are the same")
        end
      end
      def assert_rios_equal(exp,ans,msg="")
        case
        when exp.symlink?
          assert(ans.symlink?,"entry is a symlink")
          assert_equal(exp.readlink,ans.readlink,"symlinks read the same")
        when exp.file?
          assert(ans.file?,"entry is a file")
          assert_equal(exp.chomp.lines[],ans.chomp.lines[],"file has same contents")
        when exp.dir?
          assert(ans.dir?,"entry is a dir")
          assert_dirs_equal(exp,ans,"directories are the same")
        end
      end

      def self.make_lines_file(n_lines=8,*args)
        file = rio(*args)
        lines = (0...n_lines).map { |i| "L#{i}:#{file}" + $/ }
        lines.each do |line|
          file.puts(line)
        end
        file.close
        [lines,file]
      end
      T_ROOT = 'qp'
      def _t_dir_from_class()
        self.class.to_s.sub(/^TC_/,'')
      end
      def self.tdir_from_class()
        self.to_s.sub(/^TC_/,'')
      end
      def self.tdir()
        rio(T_ROOT,tdir_from_class()) 
      end
      def tdir() 
        rio(T_ROOT,_t_dir_from_class()) 
      end
      def default_test; end
    end
  end
end
