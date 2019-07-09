class CommentsController < ApplicationController

	before_action :find_commentable, only: :create

	def new
    @comment = Comment.new
  end

	def create
		unless current_user
			flash[:alert] = 'You must be logged in to comment'
			return redirect_to post_path(find_post(@commentable))
		end
		@commentable.comments.build(comment_params)
		if @commentable.save
			unless current_user == (@commentable.class == Post ? @commentable.author : @commentable.user)
				Notification.new(
					body: current_user.nick.capitalize + ' sent you a comment', 
					user: @commentable.class == Post ? @commentable.author : @commentable.user,
					link: url_for( find_post(@commentable) )
				).save
				flash[:success] = 'Comment sent'
			end
		else
			flash[:alert] = 'Something went wrong, please try again'
		end
		redirect_to post_path(find_post(@commentable))
	end
	
	def destroy
		comment = Comment.find_by(id: params[:id])
		post = find_post(comment.commentable) 
		unless current_user
			return redirect_to post_path(post)
		end
		unless comment.user == current_user || current_user.admin
			return redirect_to post_path(post)
		end
		comment.delete
		flash[:success] = 'Comment deleted'
		redirect_to post_path(post)
	end

	private

    def comment_params
      params.require(:comment).permit(:text, :user_id)
    end

		def find_commentable
      if params[:comment][:comment_id]
        @commentable = Comment.find_by(id: params[:comment][:comment_id]) 
      elsif params[:comment][:post_id]
        @commentable = Post.find_by(id: params[:comment][:post_id])
			end
		end
		
		def find_post(commentable)
			post = commentable
			while post.class != Post do
				post = post.commentable
			end
			post
		end

end