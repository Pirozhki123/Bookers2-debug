class TagSearchesController < ApplicationController

  def search
    # @word = params[:word]
    # # tags = Tag.where("name LIKE?", "#{@word}")
    @books = params[:tag_id].present? ? Tag.find(params[:tag_id]).books : Book.all
    # render "tag_search_result"
  end

end
