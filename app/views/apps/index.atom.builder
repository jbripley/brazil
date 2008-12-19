atom_feed do |feed|
  feed.title "Brazil: Apps"
  feed.icon '/favicon.ico'
  feed.author do |author|
    author.name 'Brazil'
  end
  feed.updated @apps.last.updated_at
  for app in @apps
    feed.entry(app) do |entry|
      entry.title app
      entry.content :type => 'xhtml' do |xhtml|
        xhtml.table(:frame => 'hsides', :cellspacing => '10') do |table|
          table.tr do |tr|
            tr.th 'Activity'
            tr.th 'Description'
            tr.th 'State'
            tr.th 'Updated'
          end
          for activity in app.activities
            xhtml.tr do |tr|
              tr.td do |td|
                td.a(:href => app_activity_path(activity.app, activity)) do |a|
                  a.text! activity.to_s
                end
              end
              tr.td activity.description
              tr.td activity.state
              tr.td activity.updated_at.to_s(:short)
            end
          end
        end
      end
    end
  end
end

