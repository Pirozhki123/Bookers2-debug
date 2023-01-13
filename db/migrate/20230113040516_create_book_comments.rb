class CreateBookComments < ActiveRecord::Migration[6.1]
  def change
    create_table :book_comments do |t|
      t.string :user_id
      t.string :book_id

      t.timestamps
    end
  end
end
