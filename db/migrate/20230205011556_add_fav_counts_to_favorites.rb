class AddFavCountsToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_column :favorites, :fav_counts, :integer
  end
end
