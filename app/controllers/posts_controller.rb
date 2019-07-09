class PostsController < ApplicationController

	before_action :set_post, only: [:show, :edit, :update, :destroy]

	@@per_page_pagination = 5

	# -	:category means a tag for a post like 'science' or 'art'
	# -	:keywords come from the search bar, it displays any result in the database that matches
	# either a post title or body
	def index
		if params.has_key?(:category)
			@category = Category.find_by(name: params[:category])
			@posts = Post.where(category: @category)
				.order(:weight)
				.paginate(:page => params[:page], per_page: @@per_page_pagination)
		elsif params.has_key?(:keywords)
			@posts = Post.where('title LIKE ? OR body LIKE ?',
				"%#{params[:keywords]}%", "%#{params[:keywords]}%")
				.order(:weight)
				.paginate(:page => params[:page], per_page: @@per_page_pagination)
		else
			@posts = Post.order(:weight)
				.paginate(:page => params[:page], per_page: @@per_page_pagination)
		end
	end

	def show
		@post.update_attribute(:views, @post.views + 1)
	end

	def new
		unless current_user
			flash[:alert] = 'You must be logged in to post'
			return redirect_to root_path
		end
		@post = Post.new
	end

	def edit
		unless user_is_poster?
			return redirect_to posts_url
		end
	end
	
	def create
		unless current_user # && current_user.id == post_params[:user_id]
			return redirect_to root_path
		end
		@post = Post.new(post_params)
		@post.author = current_user
		@post.vote_counter = 0
		@post.vote_sum = 0
		@post.views = 0
		@post.weight = 0
		if @post.save
			flash[:success] = 'Your post has been created'
			return redirect_to @post
		else
			return render :new
		end
	end

	def update
		unless user_is_poster?
			return redirect_to posts_url
		end
		if @post.update(post_params)
			flash[:success] = 'Your post has been updated'
			return redirect_to @post
		else
			return render :edit
		end
	end

	def destroy
		unless user_is_poster?
			return redirect_to posts_url
		end
		@post.destroy
		flash[:success] = 'Your post has been deleted'
		return redirect_to posts_url
	end

	private

		def set_post
			@post = Post.find(params[:id])
		end

		def post_params
			params.require(:post).permit(:title, :body, :category_id, :image_link, :author_id, :digest)
		end

		def user_is_poster?
			unless current_user && ((@post.author == current_user) || (current_user.admin))
				return false
			end
			return true
		end
		
end
