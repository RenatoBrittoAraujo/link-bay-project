class AddDigestToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :digest, :string
  end
end
