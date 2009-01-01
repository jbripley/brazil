# ResouceControllerRespondTo
# see explanation from http://groups.google.com/group/resource_controller/browse_thread/thread/ec9100db655bc5a9
#
module ResourceControllerRespondTo
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      class << self        
        puts '##loading...'
        alias_method_chain :init_default_actions, :json
        alias_method_chain :init_default_actions, :xml
      end
    end
  end

  module ClassMethods
    def init_default_actions_with_json(klass)
      init_default_actions_without_json(klass)
      klass.class_eval do    
        puts '##loading json'
        index.wants.json { render :json => collection.to_json, :status => :ok }
        show.wants.json  { render :json  => object}
        edit.wants.json  { render :json  => object}
        new_action.wants.json { render :json => object }

        create.wants.json { render :json => object, :status => :created, :location => object }
        create.failure.wants.json { render :json => object.errors, :status => :unprocessable_entity }
        destroy.wants.json { head :ok }
        update.wants.json { head :ok }
        update.failure.wants.json { render :json => object.errors, :status => :unprocessable_entity }
        # Response doesn't make sense for edit action
      end
    end


    def init_default_actions_with_xml(klass)
      init_default_actions_without_xml(klass)
      klass.class_eval do
        puts '##loading xml'
        index.wants.xml { render :xml => collection.to_xml, :status => :ok }
        show.wants.xml  { render :xml  => object}
        edit.wants.xml  { render :xml  => object}
        new_action.wants.xml { render :xml => object }
      
        create.wants.xml { render :xml => object, :status => :created, :location => object }
        create.failure.wants.xml { render :xml => object.errors, :status => :unprocessable_entity }
        destroy.wants.xml { head :ok }
        update.wants.xml { head :ok }
        update.failure.wants.xml { render :xml => object.errors, :status => :unprocessable_entity }
        # Response doesn't make sense for edit action
      end
    end

  end     
end

ResourceController::Controller.send :include, ResourceControllerRespondTo

