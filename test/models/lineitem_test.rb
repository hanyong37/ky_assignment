require 'test_helper'

class LineitemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  test "init month item from invoice" do
    init_data
    test_item = Lineitem.new.init_from_invoice(@start_date, @end_date_1, @monthly_price)
    assert_equal test_item.unit, Lineitem::Lineitem_Unit[:month]
    assert_equal test_item.total, @monthly_price
  end

  test "init day item from invoice" do
    init_data
    test_item = Lineitem.new.init_from_invoice(@start_date, @end_date_2, @monthly_price)
    assert_equal test_item.unit, Lineitem::Lineitem_Unit[:day]
    #how to get right value?
    #assert_equal test_item.total.to_i, (@monthly_price*12/365*11).to_i
  end

  private
  def init_data
    @start_date = Date.new(2016,1,1)
    @end_date_1 = Date.new(2016,1,31)
    @end_date_2 = Date.new(2016,1,10)
    @monthly_price = BigDecimal.new(1000)
  end

end
