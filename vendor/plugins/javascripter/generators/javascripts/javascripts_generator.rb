class JavascriptsGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join('public/javascripts')

      # Make an empty list
      javascripts = Array.new

      # Add javascripts for each controller
      controllers = Dir::open("#{RAILS_ROOT}/app/controllers").entries
      controllers.reject! { |x| /^\./ =~ x }
      controllers.each do |controller|
        controller.gsub!(/_controller.rb/,'')
        controller.gsub!(/.rb/,'')
        javascripts << controller
      end

      # Create javascripts (if not present)
      javascripts.each do |javascript|
        if !File.exist?("#{RAILS_ROOT}/public/javascripts/#{javascript}.js")
          m.template 'template.js', File.join('public/javascripts', "#{javascript}.js")
        end
      end
    end
  end

end
