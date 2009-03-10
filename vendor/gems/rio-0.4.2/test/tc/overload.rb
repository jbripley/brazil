#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'tc/testcase'

class TC_RIO_overload < Test::Unit::TestCase
  def test_overload
    qp = RIO.rio('qp')
    rio(qp,'test_overload').rmtree.mkpath.chdir {
      line0 = "Line 0\n"
      src = rio('src').print!(line0)

      rio('src') > rio('dst1')
      assert_equal(line0,rio('dst1').contents)
#      $trace_states = true
      rio('dst2') < rio('src') 
      $trace_states = false
      assert_equal(line0,rio('dst2').contents)
      rio('dst2') << rio('src') 
      assert_equal(line0+line0,rio('dst2').contents)

      rio('dst3') << rio('src') 
      assert_equal(line0,rio('dst3').contents)
      rio('dst3') << rio('src') 
      assert_equal(line0+line0,rio('dst3').contents)

      rio('dst4') < rio('src') 
      assert_equal(line0,rio('dst4').contents)

      rio('dst5') < line0
      assert_equal(line0,rio('dst5').contents)
      rio('dst5') << line0
      assert_equal(line0+line0,rio('dst5').contents)
      
      rio('dst6') < ::File.new('src','r')
      assert_equal(line0,rio('dst6').contents)
      rio('dst6') << ::File.new('src','r')
      assert_equal(line0+line0,rio('dst6').contents)
      
      rio('dst7') < "Line 0\n"
      assert_equal(line0,rio('dst7').contents)
      rio('dst7') << "Line 0\n"
      assert_equal(line0+line0,rio('dst7').contents)
      
      rio('dst8').puts!("Zippy DO\n")
      rio('dst8') < rio('src') 
      assert_equal(line0,rio('dst8').contents)
      
      rio('src') > rio('dst10')
      assert_equal(line0,rio('dst10').contents)
      rio('src') >> rio('dst10')
      assert_equal(line0+line0,rio('dst10').contents)
      
      rio('src') > rio('dst1')
      assert_equal(line0,rio('dst1').contents)
      
      rio('src') >> rio('dst1a')
      rio('src') >> rio('dst1a')
      assert_equal(line0+line0,rio('dst1a').contents)
      
      str = 'Hello World'
      rio('src') > str
      assert_equal(line0,str)
      rio('src') >> str
      assert_equal(line0+line0,str)
      
      fh = ::File.new('dst2','w')
      rio('src') > fh
      fh.close
      assert_equal(line0,rio('dst2').contents)
      
      unless $mswin32
        rio('src.gz').gzip < rio('src')
        rio('dst3') < rio('src.gz').gzip
        assert_equal(line0,rio('dst3').contents)

        str = 'Hello World'
        rio('src.gz').gzip > str
        assert_equal(line0,str)

        rio('src') > rio('src.gz').gzip 
        rio('src.gz').gzip > str
        assert_equal(line0,str)
        rio('src.gz').gzip >> str
        assert_equal(line0+line0,str)
      end
      
    }


#     dst2 = rio(datadir,'dst2').mkdir
#     src > dst2
#     sline = rio(datadir,'src').contents
#     l2 = rio(datadir,'dst2/src').contents
#     assert_equal(line0,sline,'a message in a assertion')
#     assert_equal(line0,l2)

#     # copy directories
#     sd1 = rio(datadir,'dir1/sd1').rmtree.mkpath
#     txt = "Hello f1.txt"
#     sd1.catpath('f1.txt').puts(txt).close
#     oline = rio(datadir,'dir1/sd1/f1.txt').contents

#     dir2 = rio(datadir,'dir2').rmtree.mkpath
#     sd1.copy_to(dir2)
#     nline = rio(datadir,'dir2/sd1/f1.txt').contents
#     assert_equal(oline,nline)
    
#     dir2 = rio(datadir,'dir2').rmtree.mkpath
#     sd1 > dir2
#     nline = rio(datadir,'dir2/sd1/f1.txt').contents
#     assert_equal(oline,nline)
    
#     dir2 = rio(datadir,'dir2').rmtree.mkpath
#     dir2 < rio(datadir,'dir1/sd1')
#     nline = rio(datadir,'dir2/sd1/f1.txt').contents
#     assert_equal(oline,nline)
    
#     dir2 = rio(datadir,'dir2').rmtree.mkpath
#     sd1 > dir2.to_s
#     nline = rio(datadir,'dir2/sd1/f1.txt').contents
#     assert_equal(oline,nline)
    
#     dir2 = rio(datadir,'dir2').rmtree.mkpath
#     dir2 < rio(datadir,'dir1/sd1').to_s
#     nline = rio(datadir,'dir2/sd1/f1.txt').contents
#     assert_equal(oline,nline)
    
  end
end
__END__
require 'test/unit/ui/console/testrunner'
#Test::Unit::UI::Console::TestRunner.run(TC_RIO,Test::Unit::UI::SILENT)
#Test::Unit::UI::Console::TestRunner.run(TC_RIO,Test::Unit::UI::PROGRESS_ONLY)
#Test::Unit::UI::Console::TestRunner.run(TC_RIO_copy,Test::Unit::UI::NORMAL)
Test::Unit::UI::Console::TestRunner.run(TC_RIO_copy,Test::Unit::UI::VERBOSE)
