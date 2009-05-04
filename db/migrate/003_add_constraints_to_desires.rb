class AddConstraintsToDesires < ActiveRecord::Migration
  def self.up
    change_column :desires, :name, :string, :null => false
    change_column :desires, :purchase, :boolean, :default => false
  end

  def self.down
  end
end
