# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def generate_title(crumbs)
    title = ''
    crumbs[1..-1].each do |crumb|
      title += crumb.first.to_s
      unless crumb == crumbs.last
        title += ' > '
      end
    end
    title
  end
  
  def activity_link_to(activity)
    case activity.state
    when Activity::STATE_DEVELOPMENT
      link_to activity, app_activity_path(activity.app, activity)
    when Activity::STATE_VERSIONED
      link_to activity, app_activity_versions_path(activity.app, activity)
    when Activity::STATE_DEPLOYED
      link_to activity, app_activity_versions_path(activity.app, activity)
    else
      logger.warn "Tried to link to a activity with unknown state (#{activity.to_s})"
      link_to activity, app_activities_path(activity.app)
    end
  end
  
  def brazil_release
    "#{AppConfig.release_version} (#{AppConfig.release_name})"
  end
  
  def atom_feed_tag
    case "#{controller.controller_name}-#{controller.action_name}"
    when 'apps-index'
      auto_discovery_link_tag :atom, formatted_apps_path(:id => params[:id], :format => 'atom'), {:title => "Apps"}    
    when 'activities-index'
      auto_discovery_link_tag :atom, formatted_app_activities_path(:app_id => params[:app_id], :format => 'atom'), {:title => "Activities"}
    when 'activities-show'
      auto_discovery_link_tag :atom, formatted_app_activity_path(:app_id => params[:app_id], :id => params[:id], :format => 'atom'), {:title => "Activity Changes"}
    when 'versions-index'
      auto_discovery_link_tag :atom, formatted_app_activity_versions_path(:id => params[:id], :format => 'atom'), {:title => "Activity Versions"}
    end    
  end
  
  def truncate_words(text, length = 30, end_string = '…')
    words = text.split
    words[0...length].join(' ') + (words.length > length ? end_string : '')
  end

  def email_to_realname(email)
    email.split('@').first.split('.').each {|email_part| email_part.capitalize!}.join(' ') unless email.nil?
  end
end
