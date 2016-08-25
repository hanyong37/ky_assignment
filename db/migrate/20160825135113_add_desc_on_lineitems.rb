class AddDescOnLineitems < ActiveRecord::Migration[5.0]
  def change
    change_table :lineitems do |t|
      t.string :desc
    end
  end
end
