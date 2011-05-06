class AddBackgroundInUser < ActiveRecord::Migration
  def self.up
    add_column :users, :background, :string
  end

  def self.down
  end
end
