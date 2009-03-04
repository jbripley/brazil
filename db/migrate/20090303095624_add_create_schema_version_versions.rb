class AddCreateSchemaVersionVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :create_schema_version, :boolean

    Version.reset_column_information

    say_with_time "Updating create schema version..." do
      Version.all.each do |version|
        if version.schema_version.nil?
          version.create_schema_version = true
          version.schema_version = '1_0_0'
        else
          version.create_schema_version = false
        end
        version.save
      end
    end
  end

  def self.down
    remove_column :versions, :create_schema_version
  end
end
