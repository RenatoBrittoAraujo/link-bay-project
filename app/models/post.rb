class Post < ApplicationRecord
	belongs_to :category
	belongs_to :author, :class_name => "User"

	validates :title, presence: true, length: { minimum: 5, maximum: 50 }
	validates :body, length: { maximum: 10000 }
	validates :digest, length: { maximum: 140 }
	
	has_many :votes, :dependent => :delete_all
	has_many :votants, through: :votes

	has_many :commenters, through: :comments
  has_many :comments, as: :commentable, :dependent => :delete_all

	has_one_attached :image

	def approval_percentage
		if vote_sum > 0
			((vote_counter / vote_sum) * 100.0).round.to_s + ' %'
		else
			'0 %'
		end
	end

	def approval_absolute
		vote_counter >= 0 ? '+ ' + vote_counter.to_s : '- ' + (-vote_counter).to_s
	end

	def posted_at
		minute = 60
		hour = minute * 60
		day = hour * 24
		year = day * 365
		delta = Time.now - created_at
		
		if delta < minute
			'Just now'
		elsif delta < hour
			(delta / minute).round.to_s + ' minute'.pluralize((delta / minute).round) + ' ago'
		elsif delta < day
			(delta / hour).round.to_s + ' hour'.pluralize((delta / hour).round) +  ' ago'
		elsif delta < year
			(delta / day).round.to_s + ' day'.pluralize((delta / day).round) + ' ago'
		else
			created_at.strftime("%-d/%-m/%y")
		end
	end
	
end
