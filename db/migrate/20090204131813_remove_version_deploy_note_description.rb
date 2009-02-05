class RemoveVersionDeployNoteDescription < ActiveRecord::Migration
  def self.up
    remove_column :versions, :deploy_note
  end

  def self.down
    add_column :versions, :deploy_note, :string
  end
end
