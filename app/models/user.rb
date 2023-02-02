class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # belongs_to :books
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  # ここから中間テーブル
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :follower, source: :followed
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :followed, source: :follower
  # 中間テーブルここまで
  has_one_attached :profile_image

  validates :name, presence: true, length: { in: 2..20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def is_followed_by?(user)
    followed.find_by(follower_id: user.id).present?
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : "no_image.jpg"
  end

  def self.guest
    find_or_create_by!(name: "guestuser", email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
end
