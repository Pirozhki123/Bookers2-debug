class Book < ApplicationRecord
  belongs_to :user, optional: true
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :book_tag_relations, dependent: :destroy #中間テーブルに関連付け
  has_many :tags, through: :book_tag_relations, dependent: :destroy #throughで中間テーブルを介してtagsに関連付け

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  validates :evaluation, presence: true

  is_impressionable counter_cache: true

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :evaluation_count, -> {order(evaluation: :desc)}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end
end
