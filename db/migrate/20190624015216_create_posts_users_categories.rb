class CreatePostsUsersCategories < ActiveRecord::Migration[5.2]
	def change

		# Note: postgresql does not allow for declaring a reference to a table before creating such a table, we discovered that
		# with very little time to our deadline, and such, the migrations are a mess. This will be fixed. We were using sqlite3 before discovering that.

		create_table :categories do |t|
      t.string :name
      t.text :description

			t.timestamps
		end
		
	  create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :summary
      t.boolean :admin
			t.string :nick
			t.string :image_link

      t.timestamps
		end
		
		add_index :users, :email, unique: true
		add_index :users, :nick, unique: true

		create_table :posts do |t|
      t.string :title
      t.text :body
			t.references :category, foreign_key: true
			t.references :author
			t.string :image_link

      t.timestamps
		end
		
		add_foreign_key :posts, :users, column: :author_id, primary_key: :id
  end
end
