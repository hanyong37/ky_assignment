class Invoice < ApplicationRecord
  validates :start_date, :end_date, presence: true

  belongs_to :contract
  has_many :lineitems

  def refresh_with_bill_info(bill_info)
    self.start_date = [self.start_date, bill_info[:start_date]].min
    self.end_date = [self.end_date,bill_info[:end_date]].max
    self.generate_lineitemes(bill_info[:monthly_price])
  end

  def create_with_bill_info(bill_info)
    self.title = "合同#{self.contract.name}的#{bill_info[:due_date].to_s}账单"
    self.due_date = bill_info[:due_date]
    self.start_date = bill_info[:start_date]
    self.end_date = bill_info[:end_date]
    self.generate_lineitemes(bill_info[:monthly_price])
  end

  def generate_lineitemes(monthly_price)
    #invoice的id和起止时间不能为空
    #TODO：改成异常
    self.valid?

    loop_date = self.start_date #初始化循环变量
    until loop_date > self.end_date do #从此invoice的开始日期循环到结束日期

      self.lineitems << (loop_date+1.months-1 <= self.end_date ?  Lineitem.new.init_month_item(loop_date, monthly_price) : Lineitem.new.init_day_item(loop_date, self.end_date, monthly_price))

      loop_date += 1.months
      #byebug
    end
    # 更新Invoice的总金额
    # TODO: change to callback
    self.total = self.lineitems.map{|i| i.total}.inject(:+)
    self.save!
  end

end
