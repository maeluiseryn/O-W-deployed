class AddPreciseDateToProjectAction < ActiveRecord::Migration
  def self.up
    add_column :project_actions, :precise_date, :datetime
  end

  def self.down
    remove_column :project_actions, :precise_date
  end
end
