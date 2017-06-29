class User < ApplicationRecord
  has_many :purchases
  has_many :point_ledger_entries, through: :purchases

  def point_balance
    @point_balance ||= point_ledger_entries.last.balance
  end
end
