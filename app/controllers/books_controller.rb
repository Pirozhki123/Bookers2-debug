class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def is_matching_login_user
    book = Book.find(params[:id])
    user_id = book.user.id.to_i
    unless user_id == current_user.id
      redirect_to books_path
    end
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @books = Book.all
    @book_new = Book.new
    # @favorite = Favorite.new
    # @favorite_book = Favorite.find(params[:book_id])
    @book_comment = BookComment.new
    # ここから閲覧数用
    impressionist(@book, nil, unique: [:ip_address])
  end

  def index
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:evaluation_count]
      @books = Book.evaluation_count
    else
      @books = Book.all.sort { |a, b| b.favorites.count <=> a.favorites.count }
    end

    @book = Book.new
    @favorite = Favorite.new
    @favorites = Favorite.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render "index"
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.delete
    redirect_to books_path
  end

  private
    def book_params
      params.require(:book).permit(:title, :body, :evaluation)
    end
end
