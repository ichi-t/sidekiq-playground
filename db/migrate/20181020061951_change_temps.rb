class ChangeTemps < ActiveRecord::Migration[5.2]
  def change
    change_table :temps do |t|
      t.timestamp :timestamp
      t.integer :temperture
    end
  end
end
