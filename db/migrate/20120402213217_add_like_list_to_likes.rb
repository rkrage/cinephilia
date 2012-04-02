class AddLikeListToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :like_list, :boolean

  end
end
