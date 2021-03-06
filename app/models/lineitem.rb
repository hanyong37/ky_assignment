class Lineitem < ApplicationRecord
  Lineitem_Unit = {month: "月", day: "天"}

  belongs_to :invoice

  validates :start_date, :end_date,  presence: true

  def init_from_invoice(start_date, end_date, monthly_price)
    if is_full_month?(start_date, end_date)
      init_month_item(start_date, monthly_price)
    else
      init_day_item(start_date, end_date, monthly_price)
    end
  end

private
  def is_full_month?(s_d, e_d)
    s_d.next_month.prev_day <= e_d
  end

  def init_month_item(start_date, monthly_price)
    self.start_date = start_date
    self.end_date = start_date + 1.months - 1
    self.unit = Lineitem_Unit[:month]
    self.unit_price = monthly_price
    self.total = monthly_price
    self
  end

  def init_day_item(start_date, end_date, monthly_price)
    self.start_date = start_date
    self.end_date = end_date
    self.unit = Lineitem_Unit[:day]
    self.unit_price = get_day_price(monthly_price)
    self.total = get_day_price(monthly_price)*(end_date-start_date+1)
    self
  end

  def get_day_price(m_price)
    m_price*12/365
  end

end
