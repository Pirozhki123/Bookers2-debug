class AddFavCountsToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :fav_counts, :integer
  end
end
