class FriendshipsController < ApplicationController

	def accept
		friendship = Friendship.find_by(id: params[:friendship][:friendship_id])
		unless current_user == friendship.receiver
			flash[:alert] = 'Chill man... Stop doing this'
			return redirect_to '/users/' + friendship.receiver.id.to_s
		end
		friendship.update_attribute(:accepted, true)
		chat_room = ChatRoom.new
		chat_room.save
		friendship.chat_room = chat_room
		flash[:success] = 'Friendship accepted, say hi to ' + friendship.sender.nick + '!'
		redirect_to '/users/' + friendship.sender.id.to_s
	end

	def reject
		friendship = Friendship.find_by(id: params[:friendship][:friendship_id])
		unless current_user == friendship.receiver
			flash[:alert] = 'Chill man... Stop doing this'
			return redirect_to '/users/' + friendship.receiver.id.to_s
		end
		receiver_id = friendship.receiver.id
		friendship.delete
		flash[:success] = 'Friendship rejected'
		redirect_to '/users/' + receiver_id.to_s
	end

	def create
		invalid = false

		unless current_user
			invalid = true
			flash[:alert] = 'You must be logged in to send a friendship request'
		end

		unless !invalid && params[:friendship][:receiver_id] != params[:friendship][:sender_id]
			invalid = true
			flash[:alert] = 'Are you trying to send a friend request to yourself? Come here, give me hug :D'
		end

		unless !invalid && current_user.sent_friendships.where(id: params[:friendship][:receiver_id]).empty? &&
					 current_user.received_friendships.where(id: params[:friendship][:receiver_id]).empty?
			invalid = true
			flash[:alert] = 'Already sent friendship request or are already friends'
		end

		if invalid
			return redirect_to '/users/' + params[:friendship][:receiver_id].to_s
		end
		request = Friendship.new(friendship_params)
			Notification.new(
				body: request.sender.nick.capitalize + ' has sent you a friendship request',
				link: url_for(request.receiver),
				user: request.receiver
			).save
		request.accepted = false
		request.save
		flash[:success] = 'Friendship request sent'
		redirect_to '/users/' + params[:friendship][:receiver_id].to_s
	end

	def destroy
		friendship = Friendship.find_by(id: params[:id])
		unless current_user && (current_user == friendship.sender || current_user == friendship.receiver)
			flash[:alert] = 'Mission failed, try again next time'
			return redirect_to '/'
		end
		flash[:success] = 'Friendship ended :c'
		friendship.destroy
		redirect_to '/users/' + current_user.id.to_s
	end

	private

		def friendship_params
			params.require(:friendship).permit(:sender_id, :receiver_id)
		end

end
