require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "generate lineitems case 1" do
    test_c = Contract.create(name: "test contract", start_date: "2011-01-01", end_date: "2012-02-02")

    test_inv = Invoice.create({
      start_date: "2016-08-09",
      end_date: "2016-09-08",
      contract: test_c
    })
    m_price = 1000

    #简单情况
    test_inv.generate_lineitemes(m_price)
    assert test_inv.lineitems.count == 1
    assert test_inv.total == 1000

  end


  test "the lineitems case 2" do
    test_c = Contract.create(name: "test contract", start_date: "2011-01-01", end_date: "2012-02-02")

    test_inv = Invoice.create({
      start_date: "2016-08-09",
      end_date: "2016-09-08",
      contract: test_c
    })
    m_price = 1000

    #边界测试
    test_inv.end_date = "2016-09-09"
    test_inv.generate_lineitemes(m_price)
    assert test_inv.lineitems.count == 2
    assert test_inv.total == 1000 + 1000*12/365

  end

  test "the lineitems case 3" do
    test_c = Contract.create(name: "test contract", start_date: "2011-01-01", end_date: "2012-02-02")

    test_inv = Invoice.create({
      start_date: "2016-08-09",
      end_date: "2016-09-08",
      contract: test_c
    })
    m_price = 1000

    #多条测试
    test_inv.end_date = "2016-11-09"
    test_inv.generate_lineitemes(m_price)
    assert test_inv.lineitems.count == 4
    assert test_inv.total == 1000*3 + 1000*12/365
  end

end
