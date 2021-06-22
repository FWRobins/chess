class Match < ApplicationRecord

  validates :name, :member1, :member2,  presence: true
  validates_with UniqueMembersOnlyValidator

end
