class Comment < ApplicationRecord
  belongs_to :user
	
	belongs_to :commentable, polymorphic: true
	has_many :comments, as: :commentable
	
	validates :text, length: { minimum: 1, maximum: 500 }
end
