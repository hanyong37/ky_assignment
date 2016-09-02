class Invoice < ApplicationRecord
  belongs_to :contract
  has_many :lineitems

  def generate_lineitemes(monthly_price)
    #invoice的id和起止时间不能为空
    #todo：改成异常
    return nil if (self.id.nil? || self.start_date.nil? || self.end_date.nil?)

    loop_date = self.start_date #初始化循环变量

    until loop_date > self.end_date do #从此invoice的开始日期循环到结束日期
      is_full_month = loop_date+1.months-1.days <= self.end_date#判断当前item是否足月
      Lineitem.create do |l|  #根据足月／不足月情况来赋值,并创建item
        l.invoice_id = self.id
        l.start_date = loop_date    #足月：                不足月：
        l.end_date =  is_full_month ? loop_date+1.months-1.days  : self.end_date
        l.unit =      is_full_month ? "月"                : "天"
        l.unit_price= is_full_month ? monthly_price       : get_day_price(monthly_price)
        l.total =     is_full_month ? monthly_price       : get_day_price(monthly_price)*(self.end_date-loop_date+1)
      end
      loop_date += 1.months
      #byebug
    end
      self.total = Lineitem.where(invoice_id: self.id).sum(:total)
      self.save
  end

  private
  #规则可能会变化
  def get_day_price(m_price)
    m_price*12/365
  end

end
