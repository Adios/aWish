class AddColumnPriority < ActiveRecord::Migration
  def self.up
    add_column :wants, :priority, :integer, :default => 0
  end

  def self.down
    remove_column :wants, :priority
  end
end
