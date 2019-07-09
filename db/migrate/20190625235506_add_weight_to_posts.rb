class AddWeightToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :weight, :integer
  end
end
