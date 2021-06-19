class Member < ApplicationRecord
  belongs_to :match

  validates :name, :surname, :email, :birthday, :games, :rank, presence: true

end
