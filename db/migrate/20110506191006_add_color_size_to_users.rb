class AddColorSizeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :color, :string
    add_column :users, :size, :int
  end

  def self.down
    remove_column :users, :size
    remove_column :users, :color
  end
end
