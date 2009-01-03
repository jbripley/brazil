module ActivitiesHelper
  def activity_author(activity)
    activity.changes(:order => 'created_at DESC').first.dba
  end
  
  def activity_show_dev_actions(activity)
    activity.development?
  end
  
  def activity_actionable_count(activity, format = :html)
    counts = Array.new
    case activity.state
      when Activity::STATE_DEVELOPMENT
         counts << ['Suggested', activity.changes.count(:all, :conditions => {:state => [Change::STATE_SUGGESTED]})]
      when Activity::STATE_DEPLOYED
        counts = activity.versions.count(:state, :group => 'state', :conditions => {:state => [Version::STATE_CREATED, Version::STATE_TESTED]}).collect do |count|
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

        unless count == counts.last
          output << ', '
        else
          output << ')'
        end
      end
    end
    
    return output
  end
end
