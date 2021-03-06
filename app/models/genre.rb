class Genre < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :game_genres, dependent: :destroy
  has_many :games, through: :game_genres

  validates :name, presence: true, uniqueness: true
end
