class ChatRoom < ApplicationRecord
  belongs_to :friendship

  has_many :messages, :dependent => :destroy
end
