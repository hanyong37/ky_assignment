class ChangeInvoiceBelongsToRentPhase < ActiveRecord::Migration[5.0]
  def change
    rename_column :invoices, :contract_id, :rent_phase_id
  end
end
