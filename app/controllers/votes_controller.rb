class VotesController < ApplicationController

	def upvote
		create(params.require(:vote).permit(:post_id)[:post_id], 1)
		return 'upvote'
	end

	def downvote
		create(params.require(:vote).permit(:post_id)[:post_id], -1)
		return 'downvote'
	end

	private
		# If user never voted, create new vote and update post accordingly,
		# if user has voted the same vote before, remove vote
		# if user has voted and now voted differently, change value to the opposite (2*) 
		def create(post_id, value)
			post = Post.find_by(id: post_id)
			@postVotes = post.vote_counter
			if current_user && !Vote.exists?(user_id: current_user.id, post_id: post_id)
				vote = new_vote current_user.id, post_id, value
				vote.save
				update_post_vote_counter post, value
				add_to_post_vote_sum post, 1
				update_post_weight post, -value
			elsif current_user
				oldVote = Vote.find_by(user_id: current_user.id, post_id: post_id)
				if oldVote.value == value
					oldVote.delete
					update_post_vote_counter post, -value
					add_to_post_vote_sum post, -1
					update_post_weight post, value
				else
					oldVote.update_attribute(:value, -oldVote.value)
					update_post_vote_counter post, 2 * value
					update_post_weight post, -2 * value 
				end
			end
			@postVotes = post.vote_counter
			@postPercentage = post.approval_percentage
		end

		def update_post_vote_counter(post, delta)
			post.update_attribute(:vote_counter, post.vote_counter + delta)
		end

		def add_to_post_vote_sum(post, delta)
			post.update_attribute(:vote_sum, post.vote_sum + delta)
		end

		def update_post_weight(post, delta)
			post.update_attribute(:weight, post.weight + delta)
		end

		def new_vote(user_id, post_id, value)
			vote = Vote.new
			vote.user_id = current_user.id
			vote.post_id = post_id
			vote.value = value
			vote
		end
end
