atom_feed do |feed|
  feed.title "Brazil: #{@activity}"
  feed.icon '/favicon.ico'
  feed.updated @activity.updated_at
  @activity.changes.all.each do |change|
    feed.entry(change, :url=> app_activity_change_path(@activity.app, @activity, change)) do |entry|
      entry.title "[#{change.state}] #{truncate_words change.sql, 12}"
      entry.content :type => 'xhtml' do |xhtml|
        change.sql.split("\n").each do |sql_part|
          xhtml.text! sql_part.strip
          xhtml.br
        end
      end
      entry.author do |author|
        author.name email_to_realname(change.dba)
        author.email change.dba
      end
      entry.contributor do |contributor|
        contributor.name email_to_realname(change.developer)
        contributor.email change.developer
      end
    end
  end
end
