class DropMatch < ActiveRecord::Migration[6.1]
  def change
    drop_table :matches
  end
end
