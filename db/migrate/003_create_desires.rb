class CreateDesires < ActiveRecord::Migration
  def self.up
    create_table :desires do |t|
      t.integer :priority, :default => 0
      t.boolean :meet, :default => false
      t.decimal :budget
      t.date :due_at
      t.date :met_at
      t.references :user
      t.references :item
      t.references :feedback
      t.timestamps
    end
  end

  def self.down
    drop_table :desires
  end
end
