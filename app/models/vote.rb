class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  validates :value, presence: true
end
