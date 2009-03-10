#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_rename < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true
    rio('a').rmtree.mkpath
    rio('b').rmtree.mkpath
    make_lines_file(3,'a/f0')
    make_lines_file(2,'a/f1')
  end
  def setup
    super
    self.class.once unless @@once

    @l = []; @f = []; @d = []
    @d[0] = rio('a')
    @d[1] = rio('b')
    @f[0] = rio('a/f0')
    @f[1] = rio('a/f1')
    @l[0] = @f[0].readlines
    @l[1] = @f[1].readlines
    @d[1] < @d[0]
    @d[1] < @d[0].files[]
  end
  def test_rename_filename
    indir = rio('tdir').delete!.mkpath < rio(@d[1]).to_a
    oldf = indir.files[].map { |f| f.to_s }
    expf = oldf.map { |f| f.sub(/f/,'q') }
    indir.rename.files do |ent|
      nname = ent.filename.to_s.sub(/f/,'q')
      ent.filename = nname
    end
    assert_array_equal(expf,rio('tdir').files[])

  end
  def test_rename_filename_sub
    indir = rio('tdir').delete!.mkpath < rio(@d[1]).to_a
    oldf = indir.files[].map { |f| f.to_s }
    expf = oldf.map { |f| f.sub(/f/,'q') }

    indir.rename.files do |ent|
      ent.filename = ent.filename.sub(/f/,'q')
    end
    assert_array_equal(expf,rio('tdir').files[])

  end
  def test_rename_basename
    indir = rio('tdir').delete!.mkpath < rio(@d[1]).to_a
    oldf = indir.files[].map { |f| f.to_s }
    expf = oldf.map { |f| f.sub(/f/,'q') }

    indir.rename.files do |ent|
      ent.basename = ent.basename.to_s.sub(/f/,'q')
    end
    assert_array_equal(expf,indir.files[])

  end
  def test_rename
    lines,ario = self.class.make_lines_file(1,'afile')
    assert(ario.file?)
    
    brio = rio('bfile').delete!
    assert!(brio.exist?)
    ario.rename('bfile')
    assert!(ario.exist?)
    assert(brio.file?)
    assert_equal(lines,brio[])
    
  end
  def test_rename!
    lines,ario = self.class.make_lines_file(1,'afile')
    assert(ario.file?)
    
    brio = rio('bfile').delete!
    assert!(brio.exist?)

    crio = ario.rename!('bfile')
    assert(ario.exist?)
    assert_same(ario,crio)
    assert_equal(brio,ario)
    assert_equal(lines,brio[])
    
  end
  def test_rename_assign
    adir = rio('adir').delete!.mkpath
    lines,ario = self.class.make_lines_file(1,adir,'afile.txt')
    assert(ario.file?)
    apath = 'adir/afile.txt'

    ario.rename.extname = '.asc'
    assert_equal(apath.sub!(/\.txt/,'.asc'),ario.to_s)
    assert(ario.file?)
    assert_equal(lines,ario[])

    ario.rename.basename = 'bfile'
    assert_equal(apath.sub!(/afile/,'bfile'),ario.to_s)
    assert(ario.file?)
    assert_equal(lines,ario[])

    bdir = rio('bdir').delete!.mkpath
    ario.rename.dirname = 'bdir'
    assert_equal(apath.sub!(/adir/,'bdir'),ario.to_s)
    assert(ario.file?)
    assert_equal(lines,ario[])

    ario.rename.filename = 'cfile.dat'
    assert_equal(apath.sub!(/bfile\.asc/,'cfile.dat'),ario.to_s)
    assert(ario.file?)
    assert_equal(lines,ario[])

  end
  def test_rename_basename_sub
    indir = rio('tdir').delete!.mkpath < rio(@d[1]).to_a
    oldf = indir.files[].map { |f| f.to_s }
    expf = oldf.map { |f| f.sub(/f/,'q') }

    indir.rename.files do |ent|
      ent.basename = ent.basename.sub(/f/,'q')
    end
    assert_array_equal(expf,indir.files[])

  end
  def test_rename_dirname
    indir = rio('tdir').delete!.mkpath < rio(@d[1]).to_a
    oldf = indir.files[].map { |f| f.to_s }
    expf = oldf.map { |f| f.sub(/tdir/,'qdir') }
    rio('qdir').delete!.mkpath
    indir.rename.files do |ent|
      ent.dirname = 'qdir'
    end

    assert_array_equal(expf,rio('qdir').files[])
    assert_array_equal([],rio('tdir').files[])

  end
  def test_rename_dirname_deep
    indir = rio('dir1/dir2/dir3/tdir').delete!.mkpath < rio(@d[1]).to_a
    oldf = indir.files[].map { |f| f.to_s }
    expf = oldf.map { |f| f.sub(indir.to_s,'shallow') }
    rio('shallow').delete!.mkpath
    indir.rename.files do |ent|
      ent.dirname = 'shallow'
    end
    assert_array_equal(expf,rio('shallow').files[])
    assert_array_equal([],rio(indir.to_s).files[])

  end
  def test_rename_basename_wext
    indir = rio('tdir').delete!.mkpath < rio(@d[1]).to_a

    newext = '.txt'
    indir.files.rename.each { |ent|
      ent.extname = newext
    }
    expf = @f.map { |file| rio(indir,file.basename.to_s + newext) }
    expf.each_with_index do |ef,i|
      assert(ef.file?)
      assert_equal(@l[i],ef.lines[])
    end

    indir = rio('tdir')
    newnames = []
    indir.files.each do |ent|
      ent.basename = ent.basename.sub(/f/,'q')
      newnames << ent
    end
    expnames = @f.map { |file| rio(indir,file.basename.to_s.sub(/f/,'q') + newext) }
    assert_equal(expnames,newnames)
    newf = rio('tdir').files.to_a
    assert_equal(expf,newf)

    indir = rio('tdir')
    indir.rename.files { |ent| ent.basename = ent.basename.to_s.sub(/f/,'q') }

    newf = rio('tdir').files.to_a
    assert_equal(expnames,newf)


    
  end
    
  def test_rename_add_ext
    rio('tdir').delete!.mkpath < rio(@d[1]).to_a
    indir = rio('tdir')
    newext = '.txt'
    rio('tdir').files.rename.each { |ent|
      ent.extname = newext
    }
    assert_equal(@l[0],rio(rio('tdir'),@f[0].basename.to_s + newext).lines[])
    assert_equal(@l[1],rio(rio('tdir'),@f[1].basename.to_s + newext).lines[])
  end
  def test_rename_add_ext_oreq
    indir = (rio('tdir').delete!.mkpath < rio(@d[1]).to_a)

    newext = '.txt'
    indir.files(/0/).rename { |ent| ent.extname = newext }
    assert_equal(@l[0],rio(indir,@f[0].basename.to_s + newext).lines[])
    assert_equal(@l[1],rio(indir,@f[1].basename).lines[])

    newerext = '.asc'
    indir = rio(indir)
    indir.files.rename { |ent| ent.extname ||= newerext }
    assert_equal(@l[0],rio(indir,@f[0].basename.to_s + newext).lines[])
    assert_equal(@l[1],rio(indir,@f[1].basename.to_s + newerext).lines[])
  end

  def test_rename_add_ext_andeq
    indir = (rio('tdir').delete!.mkpath < rio(@d[1]).to_a)
    newext = '.txt'
    indir.files(/0/).rename { |ent|
      ent.extname = newext
    }
    assert_equal(@l[0],rio(indir,@f[0].basename.to_s + newext).lines[])
    assert_equal(@l[1],rio(indir,@f[1].basename).lines[])

    newerext = '.asc'
    indir = rio(indir)
    indir.files.rename { |ent|
      ent.extname &&= newerext
    }
    assert_equal(@l[0],rio(indir,@f[0].basename.to_s + newerext).lines[])
    assert_equal(@l[1],rio(indir,@f[1].basename).lines[])
  end
end
__END__
