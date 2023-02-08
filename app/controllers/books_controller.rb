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
    @book_tags = @book.tags
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
    tag_list = params[:book][:name].delete(' ').delete('　').split(',') #送られたtag情報を「,」で区切ってスペースを削除
    if @book.save
      @book.save_posts(tag_list) #save_postsメソッドを実行
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render "index"
    end
  end

  def edit
    @book = Book.find(params[:id])
    @tag_list = @book.tags.pluck(:tag_name).join(',')
  end

  def update
    @book = Book.find(params[:id])
    tag_list = params[:book][:name].delete(' ').delete('　').split(',')
    if @book.update(book_params)
      @book.save_posts(tag_list)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
    def book_params
      params.require(:book).permit(:title, :body, :evaluation)
    end
end
