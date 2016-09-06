ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'simplecov'

SimpleCov.start 'rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def print_generate_invoices_info
    puts "\n==============================2.TEST generateInvoices===================================="
  end

  def print_contract_detail_info(c)
    c.invoices.each do |i|
      puts "\n  =>INVOICE:     [#{i.start_date} ~ #{i.end_date}]  TOTAL:[#{i.total}]  due_date:[#{i.due_date}]"
      i.lineitems.each do |l|
        puts "    =>LINEITEM:  [#{l.start_date} ~ #{l.end_date}]  total:[#{l.total}]  unit:[#{l.unit}]  unit_price:[#{l.unit_price}]"
      end
    end
    puts "\n==============================the end====================================================="

  end

  def print_contract_generate_infor (contract)
    puts "==============================1.TEST Contract.generateContract=========================="
    puts "==> Contract:[#{contract.name}] Start_date:[#{contract.start_date}] end_date:[#{contract.end_date}]\n"
    contract.rent_phases.each do |p|
      puts "  ==>Phase:[#{p.name}] \n\t\tstart_date:[#{p.start_date}] \n\t\tend_date:[#{p.end_date}] \n\t\tmonthly price:[#{p.monthly_price}] \n\t\tCycle:[#{p.cycle}]"
    end
  end


end
