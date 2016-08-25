class Invoice < ApplicationRecord
  belongs_to :rent_phase
  has_many :lineitems
end
