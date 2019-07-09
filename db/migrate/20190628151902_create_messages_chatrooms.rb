class CreateMessagesChatrooms < ActiveRecord::Migration[5.2]
  def change
		create_table :chat_rooms do |t|
      t.references :friendship, foreign_key: true

      t.timestamps
		end
		
    create_table :messages do |t|
      t.text :body
      t.references :user, foreign_key: true 
      t.references :chat_room, foreign_key: true 

      t.timestamps
    end
  end
end
