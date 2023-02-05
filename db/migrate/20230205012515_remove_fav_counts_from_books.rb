class RemoveFavCountsFromBooks < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :fav_counts, :integer
  end
end
