class User < ApplicationRecord
  has_many :purchases, dependent: :destroy
  has_many :point_ledger_entries, through: :purchases

  def points_balance
    @points_balance ||= point_ledger_entries.last.balance
  end
end
