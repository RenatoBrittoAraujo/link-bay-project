class User < ApplicationRecord
	has_secure_password

	validates :email, presence: true, uniqueness: true, length: { maximum: 100 }
	validates :nick, presence: true, uniqueness: true, length: { minimum: 4, maximum: 20 }
	validates :password, presence: true, length: { minimum: 8, maximum: 30 }
	validates :name, length: { minimum: 3, maximum: 200 }
	validates :summary, length: { maximum: 1000 }

	has_many :votes, :dependent => :delete_all
	has_many :liked_posts, through: :votes
	
	has_many :notifications

	has_many :comments, :dependent => :delete_all
	has_many :commenters, through: :comments

	has_many :sent_friendships, :class_name => 'Friendship', :foreign_key => 'sender_id', :dependent => :destroy
  has_many :received_friendships, :class_name => 'Friendship', :foreign_key => 'receiver_id', :dependent => :destroy

	has_one_attached :image

	# Email regex validation
	validates_format_of :email, :with => /\A\S+@.+\.\S+\z/
end
