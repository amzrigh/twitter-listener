class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :user_name
      t.string :display_name
      t.string :message_text
      t.string :message_id

      t.timestamps null: false
    end
  end
end
