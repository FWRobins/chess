class Member < ApplicationRecord


  validates :name, :surname, :email, :birthday, :games, :rank, presence: true

end
