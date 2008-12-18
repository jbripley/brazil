atom_feed do |feed|
  feed.title "Brazil: Apps"
  feed.icon '/favicon.ico'
  for app in @apps
    feed.entry(app) do |entry|
      entry.title app
      entry.content :type => 'xhtml' do |xhtml|
        xhtml.table(:frame => 'hsides', :cellspacing => '10') do
          xhtml.tr do
            xhtml.th 'Activity'
            xhtml.th 'Description'
            xhtml.th 'State'
          end
          for activity in app.activities
            xhtml.tr do
              xhtml.td activity
              xhtml.td activity.description
              xhtml.td activity.state
            end
          end
        end
      end
    end
  end
end

