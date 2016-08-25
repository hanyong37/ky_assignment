class CreateContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :contracts do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :customer_id

      t.timestamps
    end
  end
end
