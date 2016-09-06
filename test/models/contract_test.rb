require 'test_helper'

class ContractTest < ActiveSupport::TestCase

  test "generate contract" do
    init_data
    contract = Contract.generate_contract("A Testing Contract",@phase_list)

    assert contract.id > 0
    assert contract.rent_phases.size == @phase_list.count

    print_contract_generate_infor(contract)
  end

  test "generate invoices" do
    init_data
    print_generate_invoices_info
    contract = Contract.generate_contract("Another Testing Contract",@phase_list)

    assert_not_nil invs = contract.generate_invoices
    assert invs.size == 3
    assert invs.map{|i| i.due_date}.uniq.size == 3
    assert invs.map{|i| i.lineitems.size}.sum == 8

    print_contract_detail_info(contract)
  end

  def init_data
    phase_1 = RentPhase.new do |p|
      p.name = '试用期'
      p.start_date = '2016-08-25'
      p.end_date = '2016-10-25'
      p.cycle = 2
      p.monthly_price = 900
    end

    phase_2 = RentPhase.new do |p|
      p.name = '正式入住'
      p.start_date = '2016-10-26'
      p.end_date = '2017-02-24'
      p.cycle = 3
      p.monthly_price = 1200
    end

    phase_3 = RentPhase.new do |p|
      p.name = '常住奖励'
      p.start_date = '2015-09-25'
      p.end_date = '2018-09-24'
      p.cycle = 4
      p.monthly_price = 1100
    end

    @phase_list = [phase_1,phase_2]

  end
end
