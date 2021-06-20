class RemoveReferencesFromMatches < ActiveRecord::Migration[6.1]
  def change
    remove_reference :matches, [:member, :member]
  end
end
