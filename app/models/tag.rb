class Tag < ApplicationRecord
  has_many :book_tag_relations, dependent: :destroy #中間テーブルへ関連付け
  has_many :book, through: :book_tag_relations, dependent: :destroy #中間テーブルを介してbookへ関連付け
end
