require 'test_helper'

class ContractTest < ActiveSupport::TestCase

  test "contract testing" do
    #根据付款周期生成合同
    phase_1 = RentPhase.new do |p|
      p.name = '试用期'
      p.start_date = '2016-08-25'
      p.end_date = '2016-09-25'
      p.cycle = 1
      p.monthly_price = 900
    end

    phase_2 = RentPhase.new do |p|
      p.name = '正式入住'
      p.start_date = '2016-09-26'
      p.end_date = '2017-09-24'
      p.cycle = 2
      p.monthly_price = 1200
    end

    phase_3 = RentPhase.new do |p|
      p.name = '常住奖励'
      p.start_date = '2015-09-25'
      p.end_date = '2018-09-24'
      p.cycle = 3
      p.monthly_price = 1100
    end


    phase_list = [phase_1, phase_2, phase_3]
    #请修改以上数据以验证测试结果

    #1.测试generateContract
    contract = Contract.generateContract("A Testing Contract",phase_list)

    assert contract.id > 0 , "合同没有被保存"
    assert contract.rent_phases.count == phase_list.count , "付款周期没有被正确保存保存"

    puts "==============================1.TEST Contract.generateContract=========================="
    puts "==> Contract:[#{contract.name}] Start_date:[#{contract.start_date}] end_date:[#{contract.end_date}]"
    contract.rent_phases.each do |p|
      puts "  ==>Phase:[#{p.name}] \n\t\tstart_date:[#{p.start_date}] \n\t\tend_date:[#{p.end_date}] \n\t\tmonthly price:[#{p.monthly_price}] \n\t\tCycle:[#{p.cycle}]"
    end
    puts "(please modify /test/model/contract_test,line36 for different rent phase data)"

    #2. 测试generateInvoices
    puts "\n==============================2.TEST generateInvoices===================================="
    assert_not_nil contract.generateInvoices

    new_c = Contract.find_by_name('A Testing Contract')

    new_c.rent_phases.each do |p|
      puts "\n=>PHASE:[#{p.name}] [#{p.start_date} ~ #{p.end_date}]  Price:[#{p.monthly_price}]  Cycle:[#{p.cycle}]"
      p.invoices.each do |i|
        puts "\n  =>INVOICE:     [#{i.start_date} ~ #{i.end_date}]  TOTAL:[#{i.total}]  due_date:[#{i.due_date}]"
        i.lineitems.each do |l|
          puts "    =>LINEITEM:  [#{l.start_date} ~ #{l.end_date}]  total:[#{l.total}]  unit:[#{l.unit}]  unit_price:[#{l.unit_price}]"
        end
      end
    end
    puts "\n==============================the end====================================================="
  end
end
