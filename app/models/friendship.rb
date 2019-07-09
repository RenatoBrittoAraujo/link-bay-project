class Friendship < ApplicationRecord
	belongs_to :sender, :class_name => "User"
	belongs_to :receiver, :class_name => "User"

	has_one :chat_room, :dependent => :destroy
end
