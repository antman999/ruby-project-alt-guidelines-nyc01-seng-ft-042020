class CreateRentals < ActiveRecord::Migration[5.2]
  def change
    create_table :rentals do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :rating, max:5
      t.boolean :returned?, default: false
      t.timestamps
    end
  end
end
