class AddWatchListToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :watch_list, :boolean

  end
end
