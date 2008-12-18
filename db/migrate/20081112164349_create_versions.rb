class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.string :state
      t.string :schema
      t.string :schema_version
      t.string :preparation
      t.string :deploy_note
      t.references :activity
      t.text :update_sql
      t.text :rollback_sql

      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
