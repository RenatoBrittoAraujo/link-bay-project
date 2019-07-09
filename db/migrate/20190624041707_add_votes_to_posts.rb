class AddVotesToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :vote_counter, :integer
  end
end
