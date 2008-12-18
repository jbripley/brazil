module Javascripter

  def javascripts(*sources)
    options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }

    # Start the list
    javascripts = Array.new

    # Include extra javascripts
    if options["include"]
      options["include"].each do |javascript|
        javascripts << javascript
      end
    end

    # Controller/action javascripts
    javascripts << "#{controller.controller_name}"
    javascripts << "#{controller.controller_name}_#{controller.action_name}"
    javascripts << "#{controller.controller_name}/#{controller.action_name}"

    # Link to all user javascripts
    javascripts.collect! do |name|
      if File.exist?("#{RAILS_ROOT}/public/javascripts/#{name}.js")
        javascript_include_tag(name)
      end
    end
    
    # Link to applicaton.js and defaults (if requested)
    javascript_include_tag(sources.include?(:defaults) ? (:defaults) : ("application")) + 
    "\n" + javascripts.compact.join("\n").to_s

  end

end