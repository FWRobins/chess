class Match < ApplicationRecord

  validates :name, :member1, :member2,  presence: true
  validates_with UniqueMembersOnlyValidator

  def self.member_delete(member)

    the_matches = Match.where(member1: member.id)
    for the_match in the_matches
      the_match.destroy
    end
    the_matches = Match.where(member2: member.id)
    for the_match in the_matches
      the_match.destroy
    end

  end

end
