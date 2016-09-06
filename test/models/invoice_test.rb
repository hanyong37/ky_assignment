require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase

  def init_data
    @old_inv = invoices(:fix_invoice)
    @new_inv = Invoice.new( contract: contracts(:fix_contract))
    @bill_info = {due_date: Date.new(2016,2,15), start_date: Date.new(2016,3,1), end_date: Date.new(2016,3,31), monthly_price: 1000}
  end
  private :init_data

  test "update with bill info" do
    init_data
    assert @old_inv.lineitems.size == 2
    @old_inv.update_with_bill_info(@bill_info)
    assert @old_inv.lineitems.size == 3
    assert @old_inv.start_date == Date.new(2016,3,1)
    assert @old_inv.end_date == Date.new(2016,3,31)
    assert @old_inv.total ==  1900
  end

  test "init with bill info" do
    init_data
    @bill_info[:end_date] = Date.new(2016,4,30)
    @new_inv.init_with_bill_info(@bill_info)
    assert @new_inv.lineitems.size == 2
    assert @new_inv.end_date == Date.new(2016,4,30)

  end

  test "init with bill info with wrong parameter" do
    init_data
    @bill_info[:start_date] = nil
    assert_raises (Exception) { @new_inv.init_with_bill_info(@bill_info)}
  end


end
