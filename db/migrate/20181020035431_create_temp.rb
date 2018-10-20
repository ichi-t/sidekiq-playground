class CreateTemp < ActiveRecord::Migration[5.2]
  def change
    create_table :temp do |t|
      t.timestamp
      t.integer
    end
  end
end
