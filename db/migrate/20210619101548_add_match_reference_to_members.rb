class AddMatchReferenceToMembers < ActiveRecord::Migration[6.1]
  def change
    add_reference :matches, [:member, :member]
  end
end
