class CreateBookmarksTags < ActiveRecord::Migration
  def self.up
    create_table "bookmarks_tags", :id => false do |t|
      t.column "bookmark_id", :integer, :null => false
      t.column "tag_id",  :integer, :null => false
    end
  end

  def self.down
    drop_table :tags
  end
end
