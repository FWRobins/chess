class UniqueMembersOnlyValidator < ActiveModel::Validator

  def validate(record)
    if record.member1 == record.member2
      record.errors.add(:record, "Players cannot be matched with themselves")
    end
  end

end
