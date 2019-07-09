class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :body
      t.string :link
      t.references :user

      t.timestamps
    end
  end
end
