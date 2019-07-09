class MessagesController < ApplicationController
	def create
		message = Message.new(message_params)
		unless current_user.id == message.user_id
			return redirect_to '/chats'
		end
		message.save
		friendship = ChatRoom.find_by(id: params[:message][:chat_room_id].to_s).friendship
		target_user = friendship.sender
		if target_user == current_user
			target_user = friendship.receiver
		end
		if current_user != target_user
			Notification.new(
				body: current_user.nick.capitalize + ' has sent you a message',
				link: '/chats/show?id=' + params[:message][:chat_room_id].to_s,
				user: target_user
			).save
		end
		return redirect_to '/chats/show?id=' + params[:message][:chat_room_id].to_s
	end

	def destroy
		message = Message.find_by(id: params[:id])
		unless current_user == message.user
			return redirect_to '/chats'
		end
		message.delete
		return redirect_to '/chats'
	end
	
	private

		def message_params
			params.require(:message).permit(:user_id, :body, :chat_room_id)
		end

end
