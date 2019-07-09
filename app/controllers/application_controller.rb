class ApplicationController < ActionController::Base

	helper_method :current_user, :user_admin?, :empty_user_image, :upvote_image, :downvote_image
	
  def current_user
    if session[:user_id] && User.exists?(session[:user_id])
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
	end
	
	def user_admin?
		current_user && current_user.admin?
	end

	def empty_user_image
		"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYIPvxsi7tN12FmBbJfxoXopOl4PrBlzqTZFGOzSRz1wOGAovE"
	end

	def upvote_image
		"https://image.flaticon.com/icons/svg/25/25649.svg"
	end

	def downvote_image
		"https://image.flaticon.com/icons/svg/25/25629.svg"
	end

end