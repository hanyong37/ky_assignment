class Lineitem < ApplicationRecord
  belongs_to :invoice

  validates :start_date, :end_date,  presence: true

  def init_month_item(start_date, monthly_price)
    self.start_date = start_date
    self.end_date = start_date + 1.months - 1
    self.unit = "月"
    self.unit_price = monthly_price
    self.total = monthly_price
    self
  end

  def init_day_item(start_date, end_date, monthly_price)
    self.start_date = start_date
    self.end_date = end_date
    self.unit = "天"
    self.unit_price = get_day_price(monthly_price)
    self.total = get_day_price(monthly_price)*(end_date-start_date+1)
    self
  end

  private

  def get_day_price(m_price)
    m_price*12/365
  end

end
