class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.string :name
      t.integer :result

      t.timestamps
    end
  end
end
