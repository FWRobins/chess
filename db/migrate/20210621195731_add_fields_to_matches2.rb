class AddFieldsToMatches2 < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :completed, :boolean, default: false
  end
end
