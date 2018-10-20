class CreateTemps < ActiveRecord::Migration[5.2]
  def change
    create_table :temps do |t|
      t.timestamp :timestamp
      t.integer :temperture
    end
  end
end
