class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.references :housing_facility, foreign_key: true
      # TODO t.integer :number

      t.timestamps
    end
  end
end
