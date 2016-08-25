class RentPhase < ApplicationRecord
  belongs_to :contract
  has_many :invoices

end
