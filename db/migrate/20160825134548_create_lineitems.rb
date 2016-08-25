class CreateLineitems < ActiveRecord::Migration[5.0]
  def change
    create_table :lineitems do |t|
      t.date :start_date
      t.date :end_date
      t.string :unit
      t.decimal :total, precision: 10, scale: 2
      t.decimal :unit_price, precision: 10, scale: 2
      t.string :invoice_id

      t.timestamps
    end
  end
end
