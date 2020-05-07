class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :title
      t.string :platform
      t.string :developer
      t.string :genre
      t.string :release_date
      t.string :esrb_rating
    end
  end
end
