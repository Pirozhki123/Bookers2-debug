class Room < ApplicationRecord

  # ここからDM
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  # ここまでDM

end
