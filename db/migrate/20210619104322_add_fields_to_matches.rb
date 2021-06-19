class AddFieldsToMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :member1, :integer
    add_column :matches, :member2, :integer
  end
end
