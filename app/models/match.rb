class Match < ApplicationRecord

  validates :name, :member1, :member2,  presence: true
end
