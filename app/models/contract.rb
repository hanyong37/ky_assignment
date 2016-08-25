class Contract < ApplicationRecord
  validates :start_date, :end_date, presence: true
  has_many :rent_phases


  def self.generateContract(name, phases)
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

  def generateInvoices

    phases = self.rent_phases
    contract_name = self.name
    #byebug
    #按照每个交租周期产生账单，每个周期可能有多个账单；
    #如果周期cycle＝n，时间跨度大于1的会产生多个账单；
    #

    if phases.empty? || phases.nil?
       return 'DEBUG MSG => rent phases is empty or nil'
    else
      #一个合同有多个周期
      phases.each do |p|
        #每个周期有1个或多个账单
        mark_date = p.start_date
          #puts "\n=>  phase:<#{p.name}>[#{p.start_date} ~ #{p.end_date}]"
        loop do
          inv = Invoice.create({rent_phase_id: p.id}) #create以获取id
          inv.start_date = mark_date
          inv.end_date = (mark_date+p.cycle.months-1) >= p.end_date ? p.end_date : (mark_date+p.cycle.months-1)
          inv.due_date = ''
          inv.total = 0
          #puts "  =>invoice:#{inv.id}  [#{inv.start_date} ~ #{inv.end_date}] "
          #每个账单有多个item
          i_date = inv.start_date
          loop do
            item = Lineitem.new
            item.invoice_id = inv.id
            item.start_date = i_date
            #周期内最后一天
            the_last_day = item.start_date + 1.months - 1

            if the_last_day  > inv.end_date # 不足月情况
              item.end_date = inv.end_date
              item.total = getDayPrice(p.monthly_price)*(item.end_date - item.start_date + 1)
              item.desc = "不足月"
              item.unit = "天"
              item.unit_price = getDayPrice(p.monthly_price)
            elsif #足月情况
              item.end_date = the_last_day
              item.total = p.monthly_price
              item.desc = "足月"
              item.unit = "月"
              item.unit_price = p.monthly_price
            end
            item.invoice_id = inv.id
            #puts "    => item:\t\t[#{item.start_date} ~ #{item.end_date}] with total:#{item.total}, on invoice:#{inv.id}"
            item.save #保存item
            #byebug
            inv.total += item.total
            break if inv.end_date == item.end_date
             i_date += 1.months
          end #构建lineitem结束
          inv.due_date = (inv.start_date - 1.months).change(day: 15)
          inv.title = "合同:[#{contract_name}] => 周期:[#{p.name}] 的#[#{inv.due_date}]账单"
          inv.save #保存数据数据
          break if inv.end_date == p.end_date
          mark_date += p.cycle.months
        end #构建invoice结束
      end
    return "Invoices and linitems were created successfully!"
    end

  end

  private

  def getDayPrice(monthly_price)
    monthly_price*12/365
  end

  def getMonthNumber(phase)
    (phase.end_date.year - phase.start_date.year)*12 + phase.end_date.month - phase.start_date.month + 1
  end

end
