class PointLedgerEntry < ApplicationRecord
  belongs_to :purchase
  has_one :user, through: :purchase
end
