class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :room_id
      t.integer :user_id

      t.timestamps
    end
  end
end
