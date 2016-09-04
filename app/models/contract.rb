class Contract < ApplicationRecord
  validates :start_date, :end_date, presence: true

  has_many :rent_phases
  has_many :invoices

  def self.generate_contract(name, phases)
    #计算开始结束日期
    new_contract  = Contract.new do |c|
      c.name = name
      c.start_date = phases.map{|p| p.start_date}.min
      c.end_date = phases.map{|p| p.end_date}.max
    end
    new_contract.save
    phases.each{|p| p.contract_id = new_contract.id ; p.save}
    return new_contract
  end

  def generate_invoices
    self.rent_phases.each do |rp|
      rp.get_bill_list.each do |bl|
        begin
        #创建invoice；
        #如果账单周期存在，则合并；
          if self.invoices.where(due_date: bl[:due_date]).exists?
            old_inv = self.invoices.where(due_date: bl[:due_date]).first
            old_inv.start_date = [old_inv.start_date, bl[:start_date]].min
            old_inv.end_date = [old_inv.end_date,bl[:end_date]].max
            old_inv.generate_lineitemes(rp.monthly_price)
            old_inv.save!
          else#如果没有存在的账单周期，则新建一个；
            inv = self.invoices.create! do |i|
              i.title = "合同#{self.name}的#{bl[:due_date].to_s}账单"
              i.due_date = bl[:due_date]
              i.start_date = bl[:start_date]
              i.end_date = bl[:end_date]
              i.contract = self
            end
            inv.generate_lineitemes(rp.monthly_price)
          end
        end
      end
    end
  end

end
