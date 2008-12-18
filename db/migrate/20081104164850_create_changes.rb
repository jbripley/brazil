class CreateChanges < ActiveRecord::Migration
  def self.up
    create_table :changes do |t|
      t.string :dba
      t.string :developer
      t.string :state
      t.references :activity
      t.text :sql

      t.timestamps
    end
  end

  def self.down
    drop_table :changes
  end
end
