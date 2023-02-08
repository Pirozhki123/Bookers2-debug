class Book < ApplicationRecord
  belongs_to :user, optional: true
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :book_tag_relations, dependent: :destroy #中間テーブルに関連付け
  has_many :tags, through: :book_tag_relations, dependent: :destroy#throughで中間テーブルを介してtagsに関連付け

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

  def save_posts(tags) #既存のタグが被らないようにデータベースに保存
    current_tags = self.tags.pluck(:name) unless self.tags.nil? #タグが存在していれば、タグの名前を配列として全て取得
    old_tags = current_tags - tags #取得したタグから送られたタグを除いてold_tagsとする
    new_tags = tags - current_tags #送られたタグから存在するタグを除いてnew_tagsとする

    old_tags.each do |old_name| #古いタグの削除
      self.tags.delete Tag.find_by(name: old_name) #old_nameの最初の一件を取得
    end

    new_tags.each do |new_name| #新しいタグの保存
      post_tag = Tag.find_or_create_by(name: new_name) #new_nameのタグがあるか初めの1件を取得し,なければ作成
      self.tags << post_tag
    end
  end
end
