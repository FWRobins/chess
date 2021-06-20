class RemoveMatchFromMembers < ActiveRecord::Migration[6.1]
  def change
    remove_reference :members, :match
  end
end
