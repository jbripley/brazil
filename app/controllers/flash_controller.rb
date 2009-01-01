class FlashController < ApplicationController
  layout false
  
  skip_filter :add_controller_crumbs

  def notice
  end
end
