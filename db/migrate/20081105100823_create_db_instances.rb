class CreateDbInstances < ActiveRecord::Migration
  def self.up
    create_table :db_instances do |t|
      t.string :db_alias
      t.string :host
      t.integer :port
      t.string :db_env
      t.string :db_type

      t.timestamps
    end
  end

  def self.down
    drop_table :db_instances
  end
end
