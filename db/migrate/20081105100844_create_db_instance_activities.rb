class CreateDbInstanceActivities < ActiveRecord::Migration
  def self.up
    create_table :db_instance_activities, :id => false do |t|
      t.references :db_instance
      t.references :activity
    end
  end

  def self.down
    drop_table :db_instance_activities
  end
end
