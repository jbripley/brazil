class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :name
      t.string :description
      t.string :schema
      t.string :state
      t.references :app

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
