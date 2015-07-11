class IndexMessageIdAndAddRating < ActiveRecord::Migration
  def change
  	add_index :posts, :message_id, unique: true
  	add_column :posts, :rating, :integer
  end
end
