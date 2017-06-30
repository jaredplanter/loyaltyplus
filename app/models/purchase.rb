class Purchase < ApplicationRecord
  belongs_to :user
  has_many :point_ledger_entries, dependent: :destroy
end
