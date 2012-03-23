class CreateLikes < ActiveRecord::Migration
  def self.up
    create_table :likes do |t|
      t.integer :user_id
      t.integer :movie_id

      t.timestamps
    end
    add_index :likes, [:user_id, :movie_id], :unique => true
  end

  def self.down
    drop_table :likes
  end

end
