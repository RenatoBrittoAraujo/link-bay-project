class UsersController < ApplicationController
	
  before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
		if !user_admin?
			flash[:alert] = 'Gotcha, dirty little cheater'
			redirect_to root_path
		else
			@users = User.all
		end
  end

	def show
		@requested_friendships = Friendship.where(receiver: @user, accepted: false)
		@friends = Friendship.where(receiver: @user, accepted: true)
			.or(Friendship.where(sender: @user, accepted: true))
		@valid_friendship = (Friendship.where(sender: current_user , receiver: @user)
			.or(Friendship.where(sender: @user, receiver: current_user))).empty? && @user != current_user
		@posts = Post.where(author: @user).order(created_at: :desc)
	end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
		if @user.save
			flash[:success] = 'Welcome aboard to Link Bay!'
			session[:user_id] = @user.id
			redirect_to @user
		else
			render :new 
		end
  end

	def update
		if @user != current_user
			redirect_to root_path
		elsif @user.update(user_params)
			flash[:success] = 'Your account was succesfully updated'
			redirect_to @user 
		else
			render :edit 
		end
  end

  def destroy
		@user.destroy
		flash[:alert] = 'We are sad that you are leaving...'
    redirect_to root_path
  end

  private

		def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :summary, :admin, :nick, :image_link)
		end
		
end
