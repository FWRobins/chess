class Match < ApplicationRecord
  has_many :members

  validates :name, :member1, :member2,  presence: true
end
