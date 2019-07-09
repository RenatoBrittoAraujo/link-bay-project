class ChatRoomsController < ApplicationController
  def show
    friendship = Friendship.find_by(id: params[:id])
    unless friendship
      flash[:alert] = 'Something went very wrong, sorry for that'
      return redirect_to '/chats'
    end
    unless current_user == friendship.sender || current_user == friendship.receiver
      flash[:alert] = "Spying on people? That is not ok man..."
      return redirect_to '/chats'
    end
		@chat_room = friendship.chat_room
    @messages = @chat_room.messages.reverse
    @target_user = friendship.sender
    if @target_user == current_user
      @target_user = friendship.receiver
    end
  end

	def index
		unless current_user
			flash[:alert] = 'You must be logged in to use chats'
			return redirect_to root_path
		end
		@friendships = Friendship.where(sender: current_user, accepted: true)
			.or(Friendship.where(receiver: current_user, accepted: true))
  end
end
