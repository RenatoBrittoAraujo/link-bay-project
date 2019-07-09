class Message < ApplicationRecord
	belongs_to :chat_room
	belongs_to :user

	validates :body, length: { minimum: 1, maximum: 200 }
end
