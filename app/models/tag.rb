class Tag < ApplicationRecord
  has_many :book_tag_relations, dependent: :destroy #中間テーブルへ関連付け
  has_many :books, through: :book_tag_relations, dependent: :destroy #中間テーブルを介してbookへ関連付け

  validates :name, presence: true #空白登録NG
  validates :name, uniqueness: true #重複登録NG

  def self.looks(search, word)
    if search == "perfect_match"
      @tags = Tag.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @tags = Tag.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @tags = Tag.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @tags = Tag.where("name LIKE?", "%#{word}%")
    else
      @tags = Tag.all
    end

    return @tags.inject(init = []) {|result, tag| result + tag.books}

  end

end
