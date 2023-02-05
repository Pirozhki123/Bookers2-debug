class RemoveFavCountsFromFavorites < ActiveRecord::Migration[6.1]
  def change
    remove_column :favorites, :fav_counts, :integer
  end
end
