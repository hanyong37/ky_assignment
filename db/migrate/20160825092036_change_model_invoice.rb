class ChangeModelInvoice < ActiveRecord::Migration[5.0]
  def up
    change_table :invoices do |t|
      t.rename :customer_id, :contract_id
    end
  end

  def down
    change_table :invoices do |t|
      t.rename :contract_id ,:customer_id
    end
  end
end
