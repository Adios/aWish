class AddColumnPriority < ActiveRecord::Migration
  def self.up
    add_column :desires, :priority, :integer, :default => 0
  end

  def self.down
    remove_column :desires, :priority
  end
end
