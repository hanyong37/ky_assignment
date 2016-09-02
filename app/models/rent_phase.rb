class RentPhase < ApplicationRecord
  belongs_to :contract

=begin
     获得本付款周期可能的账单清单，形式为：
[
  {due_date: xxx, start_date: xxx, end_date: xxx},
  {due_date: yyy, start_date: yyy, end_date: yyy},
  {due_date: zzz, start_date: zzz, end_date: zzz}
]
=end
  def get_bill_list
     bill_list = []
     loop_date = self.start_date
     #pp self
     until loop_date > self.end_date do
       #reach_last_cycle = last_day_of_cycle(loop_date) < self.end_date
       bill_list << {
         due_date: get_due_date(loop_date),
         start_date: loop_date,
         end_date: (last_day_of_cycle(loop_date) < self.end_date ? last_day_of_cycle(loop_date) : self.end_date)
       }
       loop_date += self.cycle.months
     end
     return bill_list
  end

  private

  def last_day_of_cycle (date)
    date + self.cycle.months - 1
  end

  def get_due_date(start_date)
    start_date.prev_month.change(day: 15)
  end
end
