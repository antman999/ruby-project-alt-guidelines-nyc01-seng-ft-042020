class Game < ActiveRecord::Base
    has_many :rentals
    has_many :users, through: :rentals

end