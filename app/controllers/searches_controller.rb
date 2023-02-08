class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    # @content = params[:content]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    elsif @range == "Book"
      @books = Book.looks(params[:search], params[:word])
    else
      @books = Tag.looks(params[:search], params[:word])
    end
    # render "/searches/search_result"
  end

end
