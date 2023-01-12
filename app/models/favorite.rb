class Favorite < ApplicationRecord
  belongs_to :book
  has_many :user, dependent: :destroy
end
