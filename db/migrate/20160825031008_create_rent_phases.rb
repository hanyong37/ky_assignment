class CreateRentPhases < ActiveRecord::Migration[5.0]
  def change
    create_table :rent_phases do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :cycle
      t.decimal:monthly_price,  precision: 10, scale: 2
      t.string :contract_id

      t.timestamps
    end
  end
end
