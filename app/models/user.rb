class User < ApplicationRecord
  has_many :purchases
  has_many :point_ledger_entries, through: :purchases
end
