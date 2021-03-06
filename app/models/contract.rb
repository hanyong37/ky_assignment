class Contract < ApplicationRecord
  validates :start_date, :end_date, presence: true

  has_many :rent_phases
  validates_associated :rent_phases

  has_many :invoices

  def self.generate_contract(name, phases)
    Contract.create do |c|
      c.name = name
      c.start_date = phases.map{|p| p.start_date}.min
      c.end_date = phases.map{|p| p.end_date}.max
      c.rent_phases = phases
    end
  end

  def generate_invoices
    self.rent_phases.map{|p| p.get_bill_info_list}.flatten.each do |bi|
      begin
        if self.invoices.where(due_date: bi[:due_date]).exists?#如果账单周期存在，则合并；
          self.invoices.where(due_date: bi[:due_date]).first.update_with_bill_info(bi)
        else#如果没有存在的账单周期，则新建一个；
          self.invoices.build.init_with_bill_info(bi)
        end
      end
    end
    return self.reload.invoices
  end

end
