require 'rubygems'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/javascripter'
require 'action_view/helpers/tag_helper'

class JavascripterTest < Test::Unit::TestCase

  include ActionView::Helpers::TagHelper
  include Javascripter
  
  def test_this_plugin
    true
  end

end
