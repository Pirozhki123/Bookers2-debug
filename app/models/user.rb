class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # belongs_to :books
  has_many :books, dependent: :destroy
  has_many :favorite, dependent: :destroy
  has_one_attached :profile_image

  validates :name, presence: true, length: {in:2..20}, uniqueness: true
  validates :introduction, length: {maximum: 50 }



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
