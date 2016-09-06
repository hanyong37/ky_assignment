class Invoice < ApplicationRecord
  validates :start_date, :end_date, :due_date, presence: true

  belongs_to :contract
  has_many :lineitems

  before_save :caculate_total

  def update_with_bill_info(bill_info)
    self.start_date = [self.start_date, bill_info[:start_date]].min
    self.end_date = [self.end_date,bill_info[:end_date]].max
    generate_lineitemes(bill_info[:monthly_price])
  end

  def init_with_bill_info(bill_info)
    self.title = "合同#{self.contract.name}的#{bill_info[:due_date].to_s}账单"
    self.due_date = bill_info[:due_date]
    self.start_date = bill_info[:start_date]
    self.end_date = bill_info[:end_date]
    generate_lineitemes(bill_info[:monthly_price])
  end

  private

  def generate_lineitemes(monthly_price)
    loop_date = self.start_date #初始化循环变量
    until loop_date > self.end_date do #从此invoice的开始日期循环到结束日期
      self.lineitems << Lineitem.new.init_from_invoice(loop_date, self.end_date, monthly_price)
      loop_date += 1.months
    end
    self.save!
  end

  def caculate_total
    self.total = self.lineitems.map{|i| i.total}.inject(:+)
  end
end
