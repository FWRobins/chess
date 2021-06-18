class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.date :birthday
      t.integer :games
      t.integer :rank

      t.timestamps
    end
  end
end
