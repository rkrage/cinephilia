class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :imdbid
      t.string :title
      t.string :genre1
      t.string :genre2
      t.string :rating
      t.integer :year

      t.timestamps
    end
  end
end
