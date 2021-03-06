class Game < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :developer, class_name: 'Company', foreign_key: :developer_id
  belongs_to :publisher, class_name: 'Company', foreign_key: :publisher_id

  has_many :game_genres, dependent: :destroy
  has_many :genres, through: :game_genres

  has_many :ownerships, dependent: :destroy
  has_many :owners, through: :ownerships, source: :user

  validates :title, :price, :release_date, :developer, :publisher, presence: true
  validates :title, uniqueness: true

  mount_uploader :image, ImageUploader

  scope :genre, ->(genre) { joins(:genres).where 'genres.slug = ?', genre }
  scope :discount_over, ->(discount) { where 'discount > ?', discount.to_f / 100 }
  scope :months_ago, ->(months) { where 'release_date >= ?', months.to_i.months.ago }
  scope :query, ->(term) { where 'title ILIKE ?', "%#{term}%" }
  scope :order_by, ->(type) do
    case type
    when 'title'
      order :title
    when 'release_asc'
      order release_date: :asc
    when 'release_desc'
      order release_date: :desc
    when 'price_asc'
      order 'price - price * discount ASC'
    when 'price_desc'
      order 'price - price * discount DESC'
    end
  end

  def free?
    price.zero?
  end

  def on_sale?
    discount != 0
  end

  def sale_price
    on_sale? ? (price - price * discount).round(2) : price
  end

  def print_genres
    genres.pluck(:name).join(', ')
  end
end
