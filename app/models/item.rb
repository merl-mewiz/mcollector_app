class Item < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :keywords

  self.per_page = 15

  validates :name, presence: true
  validates :sku, presence: true
  validates_associated :user
end
