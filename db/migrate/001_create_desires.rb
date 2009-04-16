class CreateDesires < ActiveRecord::Migration
  def self.up
    create_table :desires do |t|
      t.string :name
      t.decimal :price
      t.boolean :purchase
      t.date :due
      t.string :link
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :desires
  end
end
