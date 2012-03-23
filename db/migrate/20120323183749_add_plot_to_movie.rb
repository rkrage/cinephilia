class AddPlotToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :plot, :text
  end
end
