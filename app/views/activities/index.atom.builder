atom_feed do |feed|
  feed.title "Brazil: Activities"
  feed.icon '/favicon.ico'
  feed.updated @activities.first.updated_at
  @activities.each do |activity|
    feed.entry(activity, :url => app_activity_path(activity.app, activity)) do |entry|
      entry.title "[#{activity.state}] #{activity} #{activity_actionable_count(activity, :atom)}"
      entry.content activity.description
      entry.author do |author|
        author.name email_to_realname(activity_author(activity))
        author.email activity_author(activity)
      end
    end
  end
end
