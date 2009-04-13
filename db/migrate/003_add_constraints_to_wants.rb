class AddConstraintsToWants < ActiveRecord::Migration
  def self.up
    change_column :wants, :name, :string, :null => false
    change_column :wants, :purchase, :boolean, :default => false
  end

  def self.down
  end
end
