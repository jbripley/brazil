class CreateDbInstanceVersions < ActiveRecord::Migration
  def self.up
    create_table :db_instance_versions, :id => false do |t|
      t.references :db_instance
      t.references :version
    end
  end

  def self.down
    drop_table :db_instance_versions
  end
end
