class BookCommentsController < ApplicationController
  def create
    # @book_comment = Book_comment.new(book_comment_params)
    # @book_comment.user_id = current_user
    # book = Book.find(params[:id])
    # @book_comment.book_id = book
    # @book_comment.save
    # redirect_to book_path(book)
  end

  def destroy
  end

  private

  def book_commet_params
    params.require(:book_comment).permit(:comment)
  end
end
