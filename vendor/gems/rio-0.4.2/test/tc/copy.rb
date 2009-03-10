#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end
require 'rio'
require 'test/unit'
require 'test/unit/testsuite'

#require 'tc_myfirsttests'
#require 'tc_moretestsbyme'
#require 'ts_anothersetoftests'

class TC_RIO_copy < Test::Unit::TestCase
  def test_copy
    require 'rio'
    datadir = rio('qp/test_copy').rmtree.mkpath
    inline = "Source Stuff\n"
    src = rio(datadir,'src')
    src.print(inline)
    src.close
    src = rio(datadir,'src')
    dst1 = rio(datadir,'dst1')
    src > dst1
    dst2 = rio(datadir,'dst2').mkdir
    src > dst2
    sline = rio(datadir,'src').readline
    l1 = rio(datadir,'dst1').readline
    l2 = rio(datadir,'dst2/src').readline
    assert_equal(inline,sline,'a message in an assertion')
    assert_equal(inline,l1)
    assert_equal(inline,l2)

    # copy directories
    sd1 = rio(datadir,'dir1/sd1').rmtree.mkpath
    txt = "Hello f1.txt"
    sd1.join('f1.txt').puts(txt).close
    oline = rio(datadir,'dir1/sd1/f1.txt').readline

#     dir2 = rio(datadir,'dir2').rmtree.mkpath
#     sd1.copy_to(dir2)
#     $trace_states = true
#     nline = rio(datadir,'dir2/sd1/f1.txt').readline
#     assert_equal(oline,nline)
    
#     dir2 = rio(datadir,'dir2').rmtree.mkpath
#     sd1 > dir2
#     $trace_states = false
#     nline = rio(datadir,'dir2/sd1/f1.txt').readline
#     assert_equal(oline,nline)
    
#     dir2 = rio(datadir,'dir2').rmtree.mkpath
#     dir2 < rio(datadir,'dir1/sd1')
#     nline = rio(datadir,'dir2/sd1/f1.txt').readline
#     assert_equal(oline,nline)
    
#     dir2 = rio(datadir,'dir2').rmtree.mkpath
#     sd1 > dir2.to_s
#     nline = rio(datadir,'dir2/sd1/f1.txt').readline
#     assert_equal(oline,nline)
    
    dir2 = rio(datadir,'dir2').rmtree.mkpath
    dir2 < rio(datadir,'dir1/sd1').to_s
    nline = rio(datadir,'dir2/sd1/f1.txt').readline
    assert_equal(oline,nline)
    
  end
end
__END__
require 'test/unit/ui/console/testrunner'
#Test::Unit::UI::Console::TestRunner.run(TC_RIO,Test::Unit::UI::SILENT)
#Test::Unit::UI::Console::TestRunner.run(TC_RIO,Test::Unit::UI::PROGRESS_ONLY)
#Test::Unit::UI::Console::TestRunner.run(TC_RIO_copy,Test::Unit::UI::NORMAL)
Test::Unit::UI::Console::TestRunner.run(TC_RIO_copy,Test::Unit::UI::VERBOSE)
