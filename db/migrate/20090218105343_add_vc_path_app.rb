class AddVcPathApp < ActiveRecord::Migration
  def self.up
    add_column :apps, :vc_path, :string
  end

  def self.down
    remove_column :apps, :vc_path
  end
end
