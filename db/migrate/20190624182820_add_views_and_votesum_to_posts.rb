class AddViewsAndVotesumToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :views, :integer
    add_column :posts, :vote_sum, :integer
  end
end
