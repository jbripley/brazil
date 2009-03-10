=begin rdoc

== tempdir.rb - provides class Tempdir

=== Synopsis
In order to

1. create a temporary directory with a name starting with "hoge", 
2. show the name of that directory, and
3. show its properties with the system "ls -dl" command:

  require 'tempdir'

  d = Tempdir.new("hoge")
  p d.to_s
  system("ls", "-dl", d.to_s)

After the run, the directory will appear to be removed. That is: if you
are not running inside it, which may provide you a means to create a
directory with a unique name that will be available after the run.

=== Description
<i>tempdir.rb</i> provides the Tempdir class, which is analogous to the
Tempfile class, but manipulates temporary directories. Derived from a
proposal of nobu.nokada@softhome.net. He added the class to
tempfile.rb, but since it does not seem to appear in cvs, I'll keep
it apart in tempdir.rb.

=end

require 'tmpdir'

module AutoRemoval #:nodoc: all
  MAX_TRY = 10
  @@cleanlist = []

  private

  def make_tmpname(basename, n)
    sprintf('%s%d.%d', basename, $$, n)
  end
  private :make_tmpname

  def createtmp(basename, tmpdir=Dir::tmpdir)	# :nodoc:
    if $SAFE > 0 and tmpdir.tainted?
      tmpdir = '/tmp'
    end

    lock = nil
    n = failure = 0

    begin
      Thread.critical = true
      begin
        tmpname = File.join(tmpdir, make_tmpname(basename, n))
        n += 1
      end until !@@cleanlist.include?(tmpname) and yield(tmpname)
    rescue
      p $!
      failure += 1
      retry if failure < MAX_TRY
      raise "cannot generate tempfile `%s'" % tmpname
    ensure
      Thread.critical = false
    end

    tmpname
  end

  def self.callback(path, clear)	# :nodoc:
    @@cleanlist << path
    data = [path]
    pid = $$
    return Proc.new {
      if pid == $$ 
        path, tmpfile = *data

        print "removing ", path, "..." if $DEBUG

        tmpfile.close if tmpfile

        # keep this order for thread safeness
        if File.exist?(path)
          clear.call(path)
        end
        @@cleanlist.delete(path)

        print "done\n" if $DEBUG
      end
    }, data
  end

  def self.unregister(path)
    @@cleanlist.delete(path)
  end
end

require 'pathname'
class Tempdir < Pathname #:nodoc: all
  include AutoRemoval

  def initialize(*args)
    require 'fileutils'

    tmpname = createtmp(*args) do |tmpname|
      unless File.exist?(tmpname)
        Dir.mkdir(tmpname, 0700)
      end
    end

    super(tmpname)
    @clean_proc, = AutoRemoval.callback(tmpname, FileUtils.method(:rm_rf))
    ObjectSpace.define_finalizer(self, @clean_proc)  end

  def open(basename, *modes, &block)
    File.open(self+basename, *modes, &block)
  end

  def clear
    FileUtils.rm_rf(@tmpname)
    @clean_proc.call
    ObjectSpace.undefine_finalizer(self)
  end
end

if __FILE__ == $0
#  $DEBUG = true
  d = Tempdir.new("hoge")
  p d.to_s
  system("ls", "-dl", d.to_s)
  p d
end
