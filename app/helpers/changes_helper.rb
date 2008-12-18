module ChangesHelper
  def change_action_link(change)
    unless activity_show_dev_actions(change.activity)
      return
    end
    
    case change.state
    when Change::STATE_SUGGESTED
      button_name = 'Approve'
    when Change::STATE_SAVED
      button_name = 'Edit'
    else
      button_name = nil
    end
    
    if button_name
      link_to button_name, edit_app_activity_change_path(change.activity.app, change.activity, change), :class => 'edit_change_button'
    end
  end
end
