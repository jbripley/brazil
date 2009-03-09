atom_feed do |feed|
  feed.title "Brazil: Versions for #{@version.activity}"
  feed.icon '/favicon.ico'
  feed.updated @version.updated_at
  for version in @versions
    feed.entry(version, :url=> app_activity_version_path(version.activity.app, version.activity, version)) do |entry|
      entry.title "[#{version.state}] #{version}"
      entry.content :type => 'xhtml' do |xhtml|
        xhtml.p do |p|
          p.b "Update SQL"
          create_update_sql(version).split("\n").each do |sql_part|
            p.br
            p.text! sql_part
          end
        end

        xhtml.p do |p|
          p.b "Rollback SQL"
          create_rollback_sql(version).split("\n").each do |sql_part|
            p.br
            p.text! sql_part
          end
        end

        xhtml.p do |p|
          p.b "Schema"
          p.text! version.schema
        end

        xhtml.p do |p|
          p.b "Schema Version"
          p.text! version.schema_version
        end

        for db_instance in version.db_instances
          xhtml.p do |p|
            p.b "#{db_instance.db_env.capitalize} Database"
            p.text! db_instance.to_s
          end
        end
      end # entry.content

      for change in @version.activity.changes
        entry.author do |author|
          author.email change.dba
          author.name email_to_realname(change.dba)
        end
      end
    end
  end # for version in @versions

end
