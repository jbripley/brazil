#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'
require 'tc/testcase'

class TC_uri_meta < Test::RIO::TestCase
  @@once = false
  def self.once
    @@once = true

  end
  def setup
    super
    self.class.once unless @@once
  end
  RTHOST = ENV['RIO_TEST_HOST'] ||= 'localhost'
  RTPORT = ENV['RIO_TEST_PORT'] || 80
  RTHOSTPORT = "#{RTHOST}:#{RTPORT}"
  RTDIR = 'riotest'
  HWFILENAME = 'hw.html'
  GZFILENAME = 'lines.txt.gz'
  DRFILENAME = 'dir'
  HWURL = "http://#{RTHOSTPORT}/#{RTDIR}/#{HWFILENAME}"
  GZURL = "http://#{RTHOSTPORT}/#{RTDIR}/#{GZFILENAME}"
  DRURL = "http://#{RTHOSTPORT}/#{RTDIR}/#{DRFILENAME}"
  LOCALRTDIR = rio('../../srv/www/htdocs',RTDIR)
  HWFILE = LOCALRTDIR/HWFILENAME
  GZFILE = LOCALRTDIR/GZFILENAME
  URLS = [HWURL,GZURL,DRURL]

  def check_meta(r)
    f = open(r.to_url)
    [:content_type,:charset,:base_uri,:content_encoding,:last_modified].each do |sym|
      exp = f.__send__(sym)
      ans = r.__send__(sym)
      assert_equal(exp,ans)
    end
  end
  
  def test_meta_new()
    URLS.each do |url|
      check_meta(rio(url))
    end
  end

  def test_meta_open()
    URLS.each do |url|
      check_meta(rio(url).open('r'))
    end
  end

  def test_meta_read()
    URLS.each do |url|
      r = rio(url)
      contents = r.contents
      check_meta(r)
    end
  end

  def test_meta_read_some()
    URLS.each do |url|
      r = rio(url)
      str = r.gets
      check_meta(r)
    end
  end

end
