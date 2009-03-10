#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'
require 'open-uri'
require 'ftp/testdef'

class TC_ftp_copy_data < Test::RIO::TestCase
  @@once = false
  include Test::RIO::FTP::Const

  def self.once
    @@once = true
  end
  def setup
    super
    self.class.once unless @@once
    FS_RWROOT.entries { |ent| ent.delete! }
  end

  def test_copy_string
    exp = "a string\n"
    ario = rio(FTP_RWROOT,'file0') < exp
    assert_equal(exp,ario.contents)
  end
  def test_copy_array
    exp = (0..1).map{|n| "Line #{n}\n"}
    ario = rio(FTP_RWROOT,'file0') < exp
    assert_equal(exp,ario[])
  end
end

