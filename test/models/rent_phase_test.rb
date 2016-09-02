require 'test_helper'

class RentPhaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  test "bill list" do

    phase_1 = RentPhase.new do |p|
      p.name = '测试用'
      p.start_date = '2016-01-25'
      p.end_date = '2016-07-24'
      p.cycle = 1
      p.monthly_price = 900
    end

    #正常测试
    assert phase_1.get_bill_list.length ==  6

    phase_1.cycle = 2
    assert phase_1.get_bill_list.length ==  3

    phase_1.cycle = 3
    assert phase_1.get_bill_list.length ==  2


    #边缘测试
    phase_1.end_date = "2016-07-25"

    phase_1.cycle = 1
    assert phase_1.get_bill_list.length ==  7

    phase_1.cycle = 2
    assert phase_1.get_bill_list.length ==  4

    phase_1.cycle = 3
    assert phase_1.get_bill_list.length ==  3

  end

end
