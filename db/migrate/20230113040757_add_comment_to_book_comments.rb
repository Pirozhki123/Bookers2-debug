class AddCommentToBookComments < ActiveRecord::Migration[6.1]
  def change
    add_column :book_comments, :comment, :string
  end
end
