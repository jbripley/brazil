module ActivitiesHelper
  def activity_author(activity)
    Change.find_by_activity_id(activity.id, :order => 'created_at DESC').dba
  end
  
  def activity_show_dev_actions(activity)
    activity.development?
  end
  
  def activity_actionable_count(activity, format = :html)
    counts = Array.new
    case activity.state
      when Activity::STATE_DEVELOPMENT
         counts << ['Suggested', Change.count(:all, :conditions => {:activity_id => activity.id, :state => [Change::STATE_SUGGESTED]})]
      when Activity::STATE_DEPLOYED
        counts = Version.count(:state, :group => 'state', :conditions => {:activity_id => activity.id, :state => [Version::STATE_CREATED, Version::STATE_TESTED]}).collect do |count|
          [count.first.capitalize, count.last]
        end        
    end
    
    output = String.new
    counts.each do |count|
      if count.last > 0
        output << '(' if count == counts.first
        case format
          when :html
            output << content_tag(:abbr, :title => "#{count.last} #{count.first}") { count.last.to_s }
          when :atom
            output << count.last.to_s
        end
        output << ', ' unless count == counts.last
        output << ')' if count == counts.last
      end
    end
    output
  end
  
  def latest_app_activites(app)
    Activity.find_all_by_app_id(app.id, :order => 'updated_at DESC', :limit => 2)
  end
end
