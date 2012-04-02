class AddUserRatingToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :user_rating, :string

  end
end
