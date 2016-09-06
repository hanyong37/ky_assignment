require 'test_helper'

class RentPhaseTest < ActiveSupport::TestCase

  test "get bill info list normal case" do

    init_data
    #正常测试
    assert @phase_1.get_bill_info_list.length ==  6

    @phase_1.cycle = 2
    assert @phase_1.get_bill_info_list.length ==  3

    @phase_1.cycle = 3
    assert @phase_1.get_bill_info_list.length ==  2

  end

  test "get bill info list edge case" do
    #边缘测试
    init_data
    @phase_1.end_date = Date.parse("2016-07-25")

    @phase_1.cycle = 1
    assert @phase_1.get_bill_info_list.length ==  7

    @phase_1.cycle = 2
    assert @phase_1.get_bill_info_list.length ==  4

    @phase_1.cycle = 3
    assert @phase_1.get_bill_info_list.length ==  3

  end

  test "get bill info list failed case" do
    init_data
    #validators test:
    @phase_1.start_date = nil
    assert_nil @phase_1.get_bill_info_list
  end



  private

  def init_data
    @phase_1 = RentPhase.new do |p|
      p.name = '测试用'
      p.start_date = Date.parse('2016-01-25')
      p.end_date = Date.parse('2016-07-24')
      p.cycle = 1
      p.monthly_price = 900
      p.contract = Contract.new
    end

  end
end
