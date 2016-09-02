require 'test_helper'

class ContractTest < ActiveSupport::TestCase

  test "contract testing" do
    #根据付款周期生成合同
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


    phase_list = [phase_1,phase_2]
    #请修改以上数据以验证测试结果

    #1.测试generateContract
    contract = Contract.generate_contract("A Testing Contract",phase_list)

    assert contract.id > 0 , "合同没有被保存"
    assert contract.rent_phases.count == phase_list.count , "付款周期没有被正确保存保存"

    puts "==============================1.TEST Contract.generateContract=========================="
    puts "==> Contract:[#{contract.name}] Start_date:[#{contract.start_date}] end_date:[#{contract.end_date}]\n"
    contract.rent_phases.each do |p|
      puts "  ==>Phase:[#{p.name}] \n\t\tstart_date:[#{p.start_date}] \n\t\tend_date:[#{p.end_date}] \n\t\tmonthly price:[#{p.monthly_price}] \n\t\tCycle:[#{p.cycle}]"
    end

    #2. 测试generateInvoices
    #print_generate_invoices_info
    assert_not_nil contract.generate_invoices
    new_c = Contract.find_by_name('A Testing Contract')
    print_contract_info(new_c)

  end


  private


  def print_generate_invoices_info
    puts "\n==============================2.TEST generateInvoices===================================="
    puts "Mainflow: "
    puts "  1. Phases information showed above, was used to generate a Contract;"
    puts "  2. Then contract.generateInvoices() was called;"
    puts "  3. The method will calculate Invoices and Linitems, and store them in the Database;"
    puts "  4. I fetch the contract by name, and list all Phases/Invoices/Lineitems onto screen."
    puts "  5. you can modify data to check for different scenariaes, \n\t\t\t(in /test/model/contract_test)"
  end

  def print_contract_info(c)
    c.invoices.each do |i|
      puts "\n  =>INVOICE:     [#{i.start_date} ~ #{i.end_date}]  TOTAL:[#{i.total}]  due_date:[#{i.due_date}]"
      i.lineitems.each do |l|
        puts "    =>LINEITEM:  [#{l.start_date} ~ #{l.end_date}]  total:[#{l.total}]  unit:[#{l.unit}]  unit_price:[#{l.unit_price}]"
      end
    end
    puts "\n==============================the end====================================================="

  end
end
